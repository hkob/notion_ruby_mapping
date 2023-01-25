module NotionRubyMapping
  class MermaidDatabase

    def initialize(key)
      @key = key
      @name = key
      @title = nil
      @properties = {}
      @relations = {}
      @real_db = nil
      @reverse_name_queue = {}
    end
    attr_reader :properties, :relations, :real_db, :title
    attr_accessor :name

    def add_property(key, value)
      if key == "title"
        @title = value
      else
        @properties[value] = key
      end
    end

    def append_relation(other, relation)
      @relations[relation] = other
    end

    def attach_database(db)
      @real_db = db
    end

    # @param [NotionRubyMapping::Page] target_page
    def create_notion_db(target_page, inline)
      unless @title
        print "Database must have a title property"
        exit
      end
      @real_db = target_page.create_child_database(@name, TitleProperty, @title) do |d, _|
        d.is_inline = inline
      end
    end

    def update_properties
      ps = @real_db.properties
      title_property = ps.select { |p| p.is_a? TitleProperty }.first
      title_property.new_name = @title unless title_property.name == @title
      @properties.each do |(value, key)|
        name, *options = value.split("|")
        property = ps.values_at(name).first
        case key
        when /checkbox|created_by|created_time|date|email|files|last_edited_by|last_edited_time|people|phone_number|text|url|status/
          klass = {
            checkbox: CheckboxProperty, created_by: CreatedByProperty, created_time: CreatedTimeProperty,
            date: DateProperty, email: EmailProperty, files: FilesProperty, last_edited_by: LastEditedByProperty,
            last_edited_time: LastEditedTimeProperty, people: PeopleProperty, phone_number: PhoneNumberProperty,
            rich_text: RichTextProperty, url: UrlProperty, status: StatusProperty
          }[key.to_sym]
          @real_db.add_property klass, name unless property
        when "formula"
          f_e = options.first&.gsub "@", '"'
          if property
            property.formula_expression = f_e unless property.formula_expression == f_e
          else
            @real_db.add_property(FormulaProperty, name) { |dp| dp.formula_expression = f_e }
          end
        when "multi_select"
          if property
            (options - (property.multi_select_options.map { |h| h["name"] })).each do |select_name|
              property.add_multi_select_option name: select_name, color: "default"
            end
          else
            @real_db.add_property(MultiSelectProperty, name) do |dp|
              options.each do |select_name|
                dp.add_multi_select_option name: select_name, color: "default"
              end
            end
          end
        when "number"
          format_value = options.empty? ? "number" : options.first
          if property
            property.format = format_value unless property.format == format_value
          else
            @real_db.add_property(NumberProperty, name) { |p| p.format = format_value }
          end
        when "select"
          if property
            (options - (property.select_options.map { |h| h["name"] })).each do |select_name|
              property.add_select_option name: select_name, color: "default"
            end
          else
            @real_db.add_property(SelectProperty, name) do |dp|
              options.each do |select_name|
                dp.add_select_option name: select_name, color: "default"
              end
            end
          end
        else
          nil
        end
      end
      @relations.each do |value, relation_db|
        db_id = relation_db.real_db.id
        forward, reverse = value.split "|"
        property = ps.values_at(forward).first
        if property
          if reverse
            next if property.database_id == db_id && property.synced_property_name == reverse

            property.replace_relation_database database_id: db_id
            relation_db.append_reverse_name_queue self, forward, reverse
          else
            next if property.database_id == db_id

            property.replace_relation_database database_id: db_id, type: "single_property"
          end
        else
          @real_db.add_property(RelationProperty, forward) do |p|
            if reverse
              p.replace_relation_database database_id: relation_db.real_db.id
              relation_db.append_reverse_name_queue self, forward, reverse
            else
              p.replace_relation_database database_id: relation_db.real_db.id, type: "single_property"
            end
          end
        end
      end
      @real_db.property_schema_json
    end

    def append_reverse_name_queue(other_db, forward, reverse)
      @reverse_name_queue[reverse] = [other_db, forward]
    end

    def update_database
      update_properties
      @real_db.save
    end

    def rename_reverse_name
      save = false
      @reverse_name_queue.each do |reverse, (other_db, forward)|
        frp = other_db.real_db.properties[forward]
        rp_id = frp.synced_property_id
        rrp = @real_db.properties.filter { |pp| pp.property_id == rp_id }.first
        if rrp && rrp.name != reverse
          rrp.new_name = reverse
          save = true
        end
      end
      @real_db.save if save
    end

    def update_rollup_schema
      ps = @real_db.properties
      @properties.each do |(value, key)|
        next unless key == "rollup"

        name, *options = value.split("|")
        property = ps.values_at(name).first

        relation_name, rollup_name, function = options
        if property
          property.function = function unless property.function == function
          property.relation_property_name = relation_name unless property.relation_property_name == relation_name
          property.rollup_property_name = rollup_name unless property.rollup_property_name == rollup_name
        else
          @real_db.add_property(RollupProperty, name) do |dp|
            dp.function = function
            dp.relation_property_name = relation_name
            dp.rollup_property_name = rollup_name
          end
        end
      end
      @real_db.property_schema_json
    end

    def update_rollup
      update_rollup_schema
      @real_db.save
    end
  end
end
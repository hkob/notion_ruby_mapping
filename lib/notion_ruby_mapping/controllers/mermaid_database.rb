module NotionRubyMapping
  class MermaidDatabase
    def initialize(key)
      @key = key
      @name = key
      @title = nil
      @properties = {}
      @finish_flag = {}
      @working = []
      @relations = {}
      @relation_queue = []
      @real_db = nil
      @reverse_name_queue = {}
    end
    attr_reader :properties, :relation_queue, :relations, :real_db, :title, :finish_flag
    attr_accessor :name

    def add_property(key, value)
      key_sym = key.to_sym
      if key_sym == :title
        @title = value
      else
        @properties[value] = key_sym
      end
    end

    def append_relation_queue(other, relation)
      @relation_queue << [relation, other]
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

    def blocked?(name)
      @finish_flag[name.to_sym].nil?
    end

    def count
      @properties.count + @relation_queue.count + 1
    end

    def remain
      count - @finish_flag.count
    end

    def update_title
      ps = @real_db.properties
      title_property = ps.select { |p| p.is_a? TitleProperty }.first
      title_property.new_name = @title unless title_property.name == @title
      @finish_flag[@title] = true
    end

    def update_properties
      ps = @real_db.properties
      @properties.each do |(value, key)|
        name, *options = value.split("|")
        name_sym = name.to_sym
        key_sym = key.to_sym
        next if @finish_flag[name_sym]

        property = ps.values_at(name_sym).first
        case key_sym
        when /checkbox|created_by|created_time|date|email|files|last_edited_by|last_edited_time|people|phone_number|text|url|status/
          klass = {
            checkbox: CheckboxProperty, created_by: CreatedByProperty, created_time: CreatedTimeProperty,
            date: DateProperty, email: EmailProperty, files: FilesProperty, last_edited_by: LastEditedByProperty,
            last_edited_time: LastEditedTimeProperty, people: PeopleProperty, phone_number: PhoneNumberProperty,
            rich_text: RichTextProperty, url: UrlProperty, status: StatusProperty
          }[key.to_sym]
          @real_db.add_property klass, name_sym unless property
          @working << name_sym
        when :formula
          f_e = options.first&.gsub "@", '"'
          dependencies = f_e&.scan(/prop\("([^"]+)"\)/) || []
          blocked_key = dependencies.select { |k| blocked? k.first }
          if blocked_key.empty?
            if property
              property.formula_expression = f_e unless property.formula_expression == f_e
            else
              @real_db.add_property(FormulaProperty, name_sym) { |dp| dp.formula_expression = f_e }
            end
            @working << name_sym
          else
            print("#{name_sym} blocked by #{blocked_key.flatten}\n")
            next
          end

        when :multi_select
          if property
            (options - (property.multi_select_options.map { |h| h[:name] })).each do |select_name|
              property.add_multi_select_option name: select_name, color: "default"
            end
          else
            @real_db.add_property(MultiSelectProperty, name_sym) do |dp|
              options.each do |select_name|
                dp.add_multi_select_option name: select_name, color: "default"
              end
            end
          end
          @working << name_sym
        when :number
          format_value = options.empty? ? "number" : options.first
          if property
            property.format = format_value unless property.format == format_value
          else
            @real_db.add_property(NumberProperty, name_sym) { |p| p.format = format_value }
          end
          @working << name_sym
        when :rollup
          name, *options = value.split("|").map(&:to_sym)
          relation_name, rollup_name, function = options
          if blocked? relation_name
            print("#{name} blocked by #{relation_name}\n")
            next
          else
            relation_db = @relations[relation_name]
            if relation_db.nil? || relation_db.blocked?(rollup_name)
              print "#{name} blocked by #{relation_name}-#{rollup_name}\n"
              next
            else
              property = ps.values_at(name).first

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
              @working << name
            end
          end
        when :select
          if property
            (options - (property.select_options.map { |h| h[:name] })).each do |select_name|
              property.add_select_option name: select_name, color: "default"
            end
          else
            @real_db.add_property(SelectProperty, name) do |dp|
              options.each do |select_name|
                dp.add_select_option name: select_name, color: "default"
              end
            end
          end
          @working << name
        end
      end
      while (array = @relation_queue.shift)
        value, relation_db = array
        db_id = relation_db.real_db.id
        forward, reverse = value.split("|").map(&:to_sym)
        property = ps.values_at(forward).first
        if property
          if reverse
            if property.database_id == db_id && property.synced_property_name == reverse
              relation_db.add_property :relation, reverse
              relation_db.finish_flag[reverse] = true
            else
              unless @finish_flag[forward]
                property.replace_relation_database database_id: db_id
                relation_db.append_reverse_name_queue self, forward, reverse
              end
              @working << forward
              add_property :relation, forward
            end
            relation_db.relations[reverse] = self
          else
            unless property.database_id == db_id
              property.replace_relation_database database_id: db_id, type: "single_property"
              @working << forward
              add_property :relation, forward
            end
          end
          @relations[forward] = relation_db
        else
          @real_db.add_property(RelationProperty, forward) do |p|
            if reverse
              p.replace_relation_database database_id: relation_db.real_db.id
              relation_db.append_reverse_name_queue self, forward, reverse
              relation_db.relations[reverse] = self
            else
              p.replace_relation_database database_id: relation_db.real_db.id, type: "single_property"
            end
          end
          @relations[forward] = relation_db
          @working << forward
          add_property :relation, forward
        end
      end
      @real_db.property_schema_json
    end

    def append_reverse_name_queue(other_db, forward, reverse)
      @reverse_name_queue[reverse] = [other_db, forward]
      add_property :relation, reverse
    end

    def update_database
      update_properties
      @real_db.save
      while (name = @working.shift)
        @finish_flag[name] = true
      end
    end

    def rename_reverse_name
      save = false
      reverses = []
      clears = []
      @reverse_name_queue.each do |reverse, (other_db, forward)|
        frp = other_db.real_db.properties[forward]
        rp_id = frp.synced_property_id
        rrp = @real_db.properties.filter { |pp| pp.property_id == rp_id }.first
        if rrp && rrp.name != reverse
          rrp.new_name = reverse
          reverses << other_db.real_db
          clears << rrp
          save = true
        end
        @finish_flag[reverse] = true
      end
      if save
        @real_db.save
        clears.map(&:clear_will_update)
        reverses.map(&:reload)
      end
      @reverse_name_queue = {}
    end
  end
end

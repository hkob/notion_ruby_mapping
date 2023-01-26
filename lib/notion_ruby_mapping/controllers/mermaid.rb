# frozen_string_literal: true

module NotionRubyMapping
  class Mermaid
    # @param [String] full_text
    def initialize(full_text)
      @lines = full_text.split "\n"
      @databases = Hash.new {}
      parse_text
    end
    attr_reader :lines, :databases

    def parse_text
      return unless @lines.shift =~ /^erDiagram/

      until @lines.empty?
        case @lines.shift
        when / *(\w+) *[|}][|o]--[o|][|{] *(\w+) *: *"(.*)" */
          db_or_create(Regexp.last_match(1)).append_relation_queue db_or_create(Regexp.last_match(2)), Regexp.last_match(3)
        when / *(\w+) *{ */
          append_db_with_attributes Regexp.last_match(1)
        else
          nil
        end
      end
    end

    def db_or_create(db_name)
      @databases[db_name] ||= MermaidDatabase.new db_name
    end

    def append_db_with_attributes(db_name)
      db = db_or_create db_name
      until @lines.empty?
        case @lines.shift
        when /^ *} *$/
          break
        when /^ *Database +title +"(.*)" *$/
          db.name = Regexp.last_match(1)
        when /^ *([^ ]+) +[^ ]+ +"(.*)" *$/
          db.add_property Regexp.last_match(1), Regexp.last_match(2)
        when /^ *([^ ]+) +([^ ]+) *$/
          db.add_property Regexp.last_match(1), Regexp.last_match(2)
        else
          nil
        end
      end
    end

    def attach_database(db)
      @databases.values.select { |mdb| mdb.name == db.database_title.full_text }.first&.attach_database(db)
    end

    def create_notion_db(target_page, inline)
      @databases.each_value do |mdb|
        mdb.create_notion_db(target_page, inline) unless mdb.real_db
      end
    end

    def update_title
      @databases.each_value do |mdb|
        mdb.update_title
      end
    end

    def update_databases
      @databases.each_value(&:update_database)
    end

    def rename_reverse_name
      @databases.each_value(&:rename_reverse_name)
    end

    def count
      @databases.values.map(&:count).sum
    end

    def remain
      @databases.values.map(&:remain).sum
    end
  end
end

#! /usr/bin/env ruby

require "notion_ruby_mapping"
include NotionRubyMapping

def append_database(text, db)
  text << "#{db_title db} {"
  db.properties.reject { |p| p.is_a? RelationProperty }.each_with_index do |p, i|
    class_name = p.class.name.split("::").last.sub /Property/, ""
    text << %Q[  #{class_name} p#{i} "#{p.name}"]
  end
  text << "}\n"
end

def db_title(db)
  db.database_title.full_text.gsub " ", "_"
end

if ARGV.length < 2
  print "Usage: createErDiagram.rb top_database_id code_block_id"
  exit
end
database_id, code_block_id = ARGV
NotionCache.instance.create_client ENV["NOTION_API_KEY"]
block = Block.find code_block_id
unless block.is_a? CodeBlock
  print "#{code_block_id} is not CodeBlock's id"
end
dbs = [Database.find(database_id)]
text = %w[erDiagram]

finished = {}
until dbs.empty?
  db = dbs.shift
  finished[db] = true
  append_database(text, db)
  db.properties.select { |p| p.is_a? RelationProperty }.each_with_index do |p, i|
    new_db = Database.find p.relation_database_id
    text << "#{db_title db} |o--o{ #{db_title new_db} : r#{i}"
    dbs << new_db unless finished[new_db]
  end
  text << ""
end
block.rich_text_array.rich_text_objects = text.join("\n  ")
block.language = "mermaid"
block.save
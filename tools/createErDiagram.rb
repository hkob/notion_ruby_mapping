#! /usr/bin/env ruby

require "notion_ruby_mapping"
include NotionRubyMapping

def append_database(text, db, db_titles)
  base_title = db_title db
  normalize_db_title(db, db_titles) if db_titles[db].nil?
  text << "#{db_titles[db]} {"
  text << %(  Database title "#{base_title}") unless base_title == db_titles[db]
  db.properties.reject { |p| p.is_a? RelationProperty }.each_with_index do |p, i|
    class_name = p.class.name.split("::").last.sub /Property/, ""
    text << %(  #{class_name} p#{i} "#{p.name}")
  end
  text << "}\n"
end

def normalize_db_title(db, db_titles)
  base_title = db_title db
  db_titles[db] = base_title.gsub(/[\w\d\-_]+/, "").empty? ? base_title : "d#{db_titles.count}"
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
  exit
end
dbs = [Database.find(database_id)]
text = %w[erDiagram]

finished = {}
db_titles = {}
until dbs.empty?
  db = dbs.shift
  finished[db] = true
  append_database(text, db, db_titles)
  db.properties.select { |pp| pp.is_a? RelationProperty }.each_with_index do |pp, i|
    new_db = Database.find pp.relation_database_id
    normalize_db_title(new_db, db_titles) if db_titles[new_db].nil?
    text << "#{db_titles[db]} |o--o{ #{db_titles[new_db]} : r#{i}"
    dbs << new_db unless finished[new_db]
  end
  text << ""
end
block.rich_text_array.rich_text_objects = text.join("\n  ")
block.language = "mermaid"
block.save

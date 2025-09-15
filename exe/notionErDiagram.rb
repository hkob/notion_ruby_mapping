#! /usr/bin/env ruby

require "notion_ruby_mapping"
include NotionRubyMapping

def append_data_source(text, ds, ds_titles)
  base_title = ds_title ds
  normalize_ds_title(ds, ds_titles) if ds_titles[ds].nil?
  text << "  #{ds_titles[ds]} {"
  text << %(    Database title "#{base_title}") unless base_title == ds_titles[ds]
  ds.properties.reject { |p| p.is_a? RelationProperty }.each_with_index do |p, i|
    class_name = p.class.name.split("::").last.sub(/Property/, "")
    text << %(    #{class_name} p#{i} "#{p.name}")
  end
  text << "  }\n"
end

def normalize_ds_title(db, db_titles)
  base_title = ds_title db
  db_titles[db] = base_title.gsub(/[\w\d\-_]+/, "").empty? ? base_title : "d#{db_titles.count}"
end

def ds_title(db)
  db.data_source_title.full_text.gsub " ", "_"
end

if ARGV.length < 2
  print "Usage: notionErDiagram.rb top_data_source_id code_block_id"
  exit
end
data_source_id, code_block_id = ARGV
NotionRubyMapping.configure { |c| c.notion_token = ENV["NOTION_API_KEY"] }
block = Block.find code_block_id
unless block.is_a? CodeBlock
  print "#{code_block_id} is not CodeBlock's id"
  exit
end
dss = [DataSource.find(data_source_id)]
text = %w[erDiagram]

finished = {}
ds_titles = {}
until dss.empty?
  ds = dss.shift
  append_data_source(text, ds, ds_titles)
  ds.properties.select { |pp| pp.is_a? RelationProperty }.each_with_index do |pp, _i|
    new_ds = DataSource.find pp.relation_data_source_id
    normalize_ds_title(new_ds, ds_titles) if ds_titles[new_ds].nil?
    if pp.dual_property?
      unless finished[new_ds]
        text << %(  #{ds_titles[ds]} }o--o{ #{ds_titles[new_ds]} : "#{pp.name} / #{pp.synced_property_name}" )
      end
    else
      text << %(  #{ds_titles[ds]} |o--o{ #{ds_titles[new_ds]} : "#{pp.name}")
    end
    dss << new_ds unless finished[new_ds]
  end
  finished[ds] = true
  text << ""
end

text_objects = text.each_with_object([]) do |str, ans|
  strn = "#{str}\n"
  if (last = ans.last)
    if last.length + strn.length > 1999
      ans << strn
    else
      ans[-1] += strn
    end
  else
    ans << strn
  end
end
block.rich_text_array.rich_text_objects = text_objects
block.language = "mermaid"
block.save

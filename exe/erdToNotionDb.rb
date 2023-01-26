#! /usr/bin/env ruby

require "notion_ruby_mapping"
include NotionRubyMapping

if ARGV.length < 2
  print "Usage: erdToNotion.rb code_block_id target_page_id [--inline]"
  exit
end

mermaid_url, target_page_url, inline_flag = ARGV
inline = inline_flag == "--inline"
NotionRubyMapping.configure { |c| c.notion_token = ENV["NOTION_API_KEY"] }
nc = NotionCache.instance
mermaid_block = Block.find mermaid_url
unless mermaid_block.is_a? CodeBlock
  print "#{mermaid_url} is not CodeBlock's id"
  exit
end

# Parse mermaid ER
mermaid = Mermaid.new mermaid_block.rich_text_array.full_text

# Retrieve child databases
target_page = Page.find target_page_url
target_page_id = target_page.id
db_titles = target_page.children.select { |b| b.is_a? ChildDatabaseBlock }.map(&:title)
exist_dbs = Search.new(query: "(#{db_titles.join('|')})", database_only: true).exec.select do |db|
  nc.hex_id(db.parent_id) == target_page_id
end

# Attach existing databases to mermaid database
exist_dbs.each do |db|
  mermaid.attach_database db
end

mermaid.create_notion_db target_page, inline
mermaid.update_title
pass = 1
pre_remain = nil
loop do
  print "=== Pass #{pass} ===\n"
  mermaid.update_databases
  mermaid.rename_reverse_name
  count = mermaid.count
  remain = mermaid.remain
  print "Pass #{pass} Remain #{remain} in #{count}\n"
  if pre_remain == remain
    print "Dependency loop detected.\n"
    exit
  end
  pre_remain = remain
  break if remain.zero?
  pass += 1
end
print "Finish!!!"
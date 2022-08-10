#! /usr/bin/env ruby

require "notion_ruby_mapping"
include NotionRubyMapping

# see https://zenn.dev/kinkinbeer135ml/articles/f08ce790091aca
def escape_title(title)
  title.gsub /[(){}\[\]！”＃＄％＆’（）＝＾〜｜￥１２３４５６７８９０＠｀「」｛｝；：＋＊＜＞、。・？＿]/, ""
end

class Sitemap
  def initialize(top_page, orient, nolink)
    @top_page = top_page
    @code = {@top_page => "p0"}
    @queue = [@top_page]
    @finished = {}
    @page_links = Hash.new { |h, k| h[k] = [] }
    @text = ["flowchart #{orient}"]
    @nolink = nolink
  end
  attr_reader :text

  def dig_pages
    until @queue.empty?
      page = @queue.shift
      @finished[page] = true
      search_blocks(page)
      @text << %(click #{@code[page]} "#{page["url"]}")
    end
  end

  def code_with_title(page)
    "#{@code[page]}(#{escape_title page.title})"
  end

  def search_blocks(page)
    print "#{page.title}\n"
    @children = []
    @block_queue = page.children.to_a
    search_block page, @block_queue.shift until @block_queue.empty?
    unless @children.empty?
      title = page == @top_page ? code_with_title(page) : @code[page]
      @text << [title, @children.map { |p| code_with_title p }.join(" & ")].join(" --> ")
    end
    print "\n"
  end

  def search_block(page, block)
    case block
    when ChildPageBlock
      add_child block.children.first.parent
    when LinkToPageBlock
      add_link page, block.page_id unless @nolink
    else
      @block_queue += block.children.to_a if block.has_children
      search_link_in_rta(page, block.rich_text_array) if !@nolink && block.is_a?(TextSubBlockColorBaseBlock)
    end
  end

  def add_child(child)
    @queue << child
    @children << child
    set_code child
    print "  --> #{child.title}\n"
  end

  def set_code(page)
    @code[page] ||= "p#{@code.length}"
  end

  def add_link(page, link_page_id)
    return unless link_page_id

    begin
      link_page = Page.find link_page_id
    rescue
      print "\n#{link_page_id} can not read by this integration\n"
      return
    end
    set_code link_page
    @page_links[page] << link_page
    print "  -.-> #{link_page.title} "
  end

  def search_link_in_rta(page, rta)
    rta.each { |to| add_link page, to.page_id if to.is_a?(MentionObject) && to.page_id }
  end

  def link_pages
    @page_links.each do |org, array|
      link_finished = {}
      array.each do |lp|
        link_finished[lp] = @finished[lp] ? @code[lp] : code_with_title(lp)
      end
      @text << [@code[org], link_finished.values.join(" & ")].join(" -.-> ")
    end
  end
end

if ARGV.length < 3
  print "Usage: notionSitemap.rb top_page_id code_block_id orient(LR or TD) [--nolink]"
  exit
end
top_page_id, code_block_id, orient, nolink = ARGV
NotionCache.instance.create_client ENV["NOTION_API_KEY"]
code_block = Block.find code_block_id
unless code_block.is_a? CodeBlock
  print "#{code_block_id} is not CodeBlock's id"
  exit
end

top_page = Page.find top_page_id
sm = Sitemap.new top_page, orient, nolink == "--nolink"
sm.dig_pages
sm.link_pages unless nolink
text_objects = sm.text.each_with_object([]) do |str, ans|
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
code_block.rich_text_array.rich_text_objects = text_objects
code_block.language = "mermaid"
code_block.save

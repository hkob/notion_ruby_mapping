# frozen_string_literal: true

%w[version notion_cache base page database list block property text_property title_property rich_text_property
   url_property email_property phone_number_property number_property checkbox_property select_property
   multi_property multi_select_property date_base_property date_property created_time_property last_edited_time_property
   people_property created_by_property last_edited_by_property files_property relation_property formula_property
   query].each do |k|
  require_relative "notion_ruby_mapping/#{k}"
end

module NotionRubyMapping
  class Error < StandardError; end
  # Your code goes here...
end

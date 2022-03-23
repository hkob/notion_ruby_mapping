# frozen_string_literal: true

require "yaml"

%w[version notion_cache base page database list block property text_property title_property rich_text_property
   url_property email_property phone_number_property number_property checkbox_property select_property multi_property
   multi_select_property date_base_property date_property created_time_property last_edited_time_property
   people_property created_by_property last_edited_by_property files_property relation_property formula_property
   rollup_property query payload property_cache rich_text_object text_object mention_object user_object
   rich_text_array].each do |k|
  require_relative "notion_ruby_mapping/#{k}"
end

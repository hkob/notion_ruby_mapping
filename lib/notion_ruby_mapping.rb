# frozen_string_literal: true

require "yaml"

require_relative "notion_ruby_mapping/version"
{
  blocks: %w[base block database list page],
  controllers: %w[notion_cache payload property_cache query rich_text_array],
  objects: %w[rich_text_object mention_object text_object user_object],
  properties: %w[property checkbox_property multi_property created_by_property date_base_property created_time_property
                 date_property email_property files_property formula_property last_edited_by_property
                 last_edited_time_property multi_select_property number_property people_property phone_number_property
                 relation_property text_property rich_text_property rollup_property select_property title_property
                 url_property],
}.each do |key, values|
  values.each do |klass|
    require_relative "notion_ruby_mapping/#{key}/#{klass}"
  end
end

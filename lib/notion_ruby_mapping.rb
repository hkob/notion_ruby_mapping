# frozen_string_literal: true

require "yaml"

require_relative "notion_ruby_mapping/version"
{
  blocks: %w[base block database list page url_caption_base_block bookmark_block breadcrumb_block
             text_sub_block_color_base_block bulleted_list_item_block callout_block child_base_block
             child_database_block child_page_block code_block column_list_block column_block divider_block
             embed_block equation_block file_base_block file_block heading1_block heading2_block heading3_block
             image_block toggle_heading1_block toggle_heading2_block toggle_heading3_block url_base_block
             link_preview_block link_to_page_block numbered_list_item_block paragraph_block pdf_block quote_block
             synced_block table_block table_row_block table_of_contents_block template_block to_do_block
             toggle_block video_block],
  controllers: %w[notion_cache payload property_cache query rich_text_array],
  objects: %w[rich_text_object emoji_object equation_object file_object mention_object text_object user_object],
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

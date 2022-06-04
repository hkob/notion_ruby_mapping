# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe TableRowBlock do
    type = "table_row"

    context "table_row" do
      it_behaves_like :retrieve_block, described_class, TestConnection::BLOCK_ID_HASH[type.to_sym], false, {
        "object" => "block",
        "type" => "table_row",
        "table_row" => {
          "cells" => [
            [
              {
                "annotations" => {
                  "bold" => false,
                  "code" => false,
                  "color" => "default",
                  "italic" => false,
                  "strikethrough" => false,
                  "underline" => false,
                },
                "href" => nil,
                "plain_text" => "Title",
                "text" => {
                  "content" => "Title",
                  "link" => nil,
                },
                "type" => "text",
              },
            ],
            [
              {
                "annotations" => {
                  "bold" => false,
                  "code" => false,
                  "color" => "default",
                  "italic" => false,
                  "strikethrough" => false,
                  "underline" => false,
                },
                "href" => nil,
                "plain_text" => " Contents",
                "text" => {
                  "content" => " Contents",
                  "link" => nil,
                },
                "type" => "text",
              },
            ],
          ],
        },
      }
    end
  end
end

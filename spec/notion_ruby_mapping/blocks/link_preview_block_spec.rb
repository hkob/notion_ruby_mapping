# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe LinkPreviewBlock do
    # type = "link_preview"

    it_behaves_like "retrieve block", described_class, TestConnection.block_id("link_preview_dropbox"), false, {
      "object" => "block",
      "type" => "link_preview",
      "link_preview" => {
        "url" => "https://www.dropbox.com/s/8d6kjlpdlfqiec5/complex.pdf?dl=0",
      },
    }
  end
end

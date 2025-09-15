# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe BreadcrumbBlock do
    type = "breadcrumb"

    it_behaves_like "retrieve block", described_class, TestConnection.block_id(type), false, {
      "object" => "block",
      "type" => type,
      type => {},
    }

    describe "create_child_block" do
      let(:target) { described_class.new }

      it_behaves_like "create child block", described_class,
                      "26cd8e4e98ab819b9354def743626636", "26cd8e4e98ab8136ae54f2651935aec1"
    end
  end
end

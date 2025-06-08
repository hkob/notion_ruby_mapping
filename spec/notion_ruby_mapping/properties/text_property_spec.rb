# frozen_string_literal: true

module NotionRubyMapping
  [TitleProperty, RichTextProperty].each do |c|
    RSpec.describe c do
      it_behaves_like "filter test", c,
                      %i[equals does_not_equal contains does_not_contain starts_with ends_with],
                      value: "abc"
      it_behaves_like "filter test", c, %i[is_empty is_not_empty]
    end
  end

  RSpec.describe TextProperty do
    it "raise error to construct parent TextProperty directly" do
      expect { described_class.new "name" }.to raise_error(StandardError)
    end
  end
end

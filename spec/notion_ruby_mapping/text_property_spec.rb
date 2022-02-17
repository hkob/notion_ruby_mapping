# frozen_string_literal: true

module NotionRubyMapping
  [
    [TitleProperty, "title"],
    [RichTextProperty, "rich_text"],
    [UrlProperty, "url"],
    [EmailProperty, "email"],
    [PhoneNumberProperty, "phone_number"],
  ].each do |c, type|
    RSpec.describe c do
      let(:property) { c.new "tp" }
      describe "a text property" do
        it "has name" do
          expect(property.name).to eq "tp"
        end

        context "create filter" do
          subject { query.filter }
          %w[equals does_not_equal contains does_not_contain starts_with ends_with].each do |key|
            context key do
              let(:query) { property.send "filter_#{key}", "abc" }
              it { is_expected.to eq({"property" => "tp", type => {key => "abc"}}) }
            end
          end

          %w[is_empty is_not_empty].each do |key|
            context key do
              let(:query) { property.send "filter_#{key}" }
              it { is_expected.to eq({"property" => "tp", type => {key => true}}) }
            end
          end
        end
      end
    end
  end
end
# frozen_string_literal: true

require_relative "../spec_helper"

module NotionRubyMapping
  RSpec.describe PropertyCache do
    let(:property_cache) { PropertyCache.new }
    describe "constructor" do
      it "can create an object" do
        expect(property_cache).not_to be_nil
      end
    end
  end
end

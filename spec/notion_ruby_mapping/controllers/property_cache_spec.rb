# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe PropertyCache do
    describe "constructor" do
      context "without json" do
        let(:property_cache) { PropertyCache.new }

        it "can create an object" do
          expect(property_cache).not_to be_nil
        end

        it("does not have a page_id") { expect(property_cache.page_id).to be_nil }
      end

      context "when with json" do
        let(:json) { {"np" => {"type" => "number", "number" => 123}} }
        let(:property_cache) { PropertyCache.new json, page_id: "abc" }

        context "without json" do
          it "can create an object" do
            expect(property_cache).not_to be_nil
          end

          it "has a NumberProperty" do
            expect(property_cache["np"]).to be_an_instance_of(NumberProperty)
          end

          it("has a page_id") { expect(property_cache.page_id).to eq "abc" }

          it "page?, database?, data_source?" do
            expect(property_cache.page?).to be_truthy
            expect(property_cache.database?).to be_falsey
            expect(property_cache.data_source?).to be_falsey
            expect(property_cache.database_or_data_source?).to be_falsey
          end
        end
      end
    end

    describe "add_property (Page)" do
      subject { PropertyCache.new page_id: "def" }
      let(:np) { NumberProperty.new "np", json: 123 }
      let(:target) { subject["np"] }

      before { subject.add_property np }

      it "page?, database?, data_source?" do
        expect(subject.page?).to be_truthy
        expect(subject.database?).to be_falsey
        expect(subject.data_source?).to be_falsey
        expect(subject.database_or_data_source?).to be_falsey
      end

      context "when no update" do
        it "has the NumberProperty" do
          expect(target).to eq np
        end

        it "the NumberProperty will not update" do
          expect(target.will_update).to be_falsey
        end
      end

      context "when update value" do
        before { np.number = 456 }

        it "has the NumberProperty" do
          expect(subject["np"]).to eq np
        end

        it "the NumberProperty will not update" do
          expect(subject["np"].will_update).to be_truthy
        end

        it "can generate property values json" do
          expect(subject.property_values_json).to eq({"properties" => {"np" => {"number" => 456, "type" => "number"}}})
        end
      end
    end

    describe "add_property (Database)" do
      subject { PropertyCache.new base_type: "database" }
      let(:np) { NumberProperty.new "np", base_type: "database" }

      before { subject.add_property np }

      it "page?, database?, data_source?" do
        expect(subject.page?).to be_falsey
        expect(subject.database?).to be_truthy
        expect(subject.data_source?).to be_falsey
        expect(subject.database_or_data_source?).to be_truthy
      end

      context "no update" do
        it "has the NumberProperty" do
          expect(subject["np"]).to eq np
        end

        it "the NumberProperty will not update" do
          expect(subject["np"].will_update).to be_falsey
        end

        it "can generate update property schema json" do
          expect(subject.update_property_schema_json).to eq({"initial_data_source" => {}})
        end

        it "can generate property schema json" do
          expect(subject.property_schema_json).to eq({"initial_data_source" => {}})
        end
      end

      context "update value" do
        before { np.format = "percent" }

        it "has the NumberProperty" do
          expect(subject["np"]).to eq np
        end

        it "the NumberProperty will not update" do
          expect(subject["np"].will_update).to be_truthy
        end

        it "can generate update property schema json" do
          expect(subject.update_property_schema_json).to eq({
                                                              "initial_data_source" => {
                                                                "properties" => {
                                                                  "np" => {
                                                                    "number" => {"format" => "percent"},
                                                                  },
                                                                },
                                                              },
                                                            })
        end

        it "can generate property schema json" do
          expect(subject.property_schema_json).to eq({
                                                       "initial_data_source" => {
                                                         "properties" => {
                                                           "np" => {
                                                             "number" => {"format" => "percent"},
                                                           },
                                                         },
                                                       },
                                                     })
        end
      end
    end

    describe "add_property (DataSource)" do
      subject { PropertyCache.new base_type: "data_source" }
      let(:np) { NumberProperty.new "np", base_type: "data_source" }

      before { subject.add_property np }

      it "page?, database?, data_source?" do
        expect(subject.page?).to be_falsey
        expect(subject.database?).to be_falsey
        expect(subject.data_source?).to be_truthy
        expect(subject.database_or_data_source?).to be_truthy
      end

      context "no update" do
        it "has the NumberProperty" do
          expect(subject["np"]).to eq np
        end

        it "the NumberProperty will not update" do
          expect(subject["np"].will_update).to be_falsey
        end

        it "can generate update property schema json" do
          expect(subject.update_property_schema_json).to eq({})
        end

        it "can generate property schema json" do
          expect(subject.property_schema_json).to eq({})
        end
      end

      context "update value" do
        before { np.format = "percent" }

        it "has the NumberProperty" do
          expect(subject["np"]).to eq np
        end

        it "the NumberProperty will not update" do
          expect(subject["np"].will_update).to be_truthy
        end

        it "can generate update property schema json" do
          expect(subject.update_property_schema_json).to eq({
                                                              "properties" => {
                                                                "np" => {
                                                                  "number" => {"format" => "percent"},
                                                                },
                                                              },
                                                            })
        end

        it "can generate property schema json" do
          expect(subject.property_schema_json).to eq({"properties" => {"np" => {"number" => {"format" => "percent"}}}})
        end
      end
    end

    describe "enumerators" do
      subject { PropertyCache.new }
      let(:np) { NumberProperty.new "np", json: 123 }
      let(:tp) { TitleProperty.new "tp", text_objects: [TextObject.new("ABC")] }

      before { [np, tp].each { |p| subject.add_property p } }

      it "can map properties" do
        expect(subject.map(&:name)).to eq %w[np tp]
      end

      it "can select properties" do
        expect(subject.filter { |p| p.is_a? TitleProperty }).to eq [tp]
      end

      it "can obtain some properties using values_at" do
        expect(subject.values_at("np", "tp")).to eq [np, tp]
      end
    end
  end
end

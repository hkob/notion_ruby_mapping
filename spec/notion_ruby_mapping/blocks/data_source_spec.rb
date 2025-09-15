# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe DataSource do
    let(:tc) { TestConnection.instance }
    let!(:nc) { tc.nc }
    let(:create_data_source_title) { "New data source by database_id" }

    describe "find" do
      subject { -> { DataSource.find data_source_id } }

      context "For an existing data_source" do
        let(:data_source_id) { TestConnection::DATA_SOURCE_ID }

        it "receive id" do
          expect(subject.call.id).to eq nc.hex_id(TestConnection::DATA_SOURCE_ID)
        end

        describe "data_source_title" do
          it {
            expect(subject.call.data_source_title.full_text).to eq "Sample table"
          }
        end

        describe "dry_run" do
          let(:dry_run) { DataSource.find "data_source_id", dry_run: true }

          it_behaves_like "dry run", :get, :data_source_path, id: "data_source_id"
        end
      end

      context "Wrong data_source" do
        context "wrong format id" do
          let(:data_source_id) { "AAA" }

          it "raise exception" do
            expect { subject.call }.to raise_error(StandardError)
          end
        end

        context "wrong id" do
          let(:data_source_id) { TestConnection::UNPERMITTED_DATA_SOURCE_ID }

          it "Can't receive data_source" do
            expect { subject.call }.to raise_error(StandardError)
          end
        end
      end
    end

    describe "new and reload" do
      let(:data_source) { DataSource.new id: data_source_id }

      subject { -> { data_source.reload } }

      context "For an existing data_source" do
        let(:data_source_id) { TestConnection::DATA_SOURCE_ID }

        it "has not json before reload" do
          expect(data_source.json).to be_nil
        end

        it "receive id" do
          expect(subject.call.id).to eq nc.hex_id(TestConnection::DATA_SOURCE_ID)
        end

        it "has json after reloading" do
          expect(subject.call.json).not_to be_nil
        end
      end

      context "Wrong data_source" do
        context "wrong format id" do
          let(:data_source_id) { "AAA" }

          it "has not json before reload" do
            expect(data_source.json).to be_nil
          end

          it "raise exception" do
            expect { subject.call }.to raise_error(StandardError)
          end
        end

        context "wrong id" do
          let(:data_source_id) { TestConnection::UNPERMITTED_DATA_SOURCE_ID }

          it "raise exception" do
            expect { subject.call }.to raise_error(StandardError)
          end
        end
      end
    end

    describe "properties" do
      let(:properties) { data_source.properties }

      context "loaded data_source" do
        let(:data_source) { DataSource.find TestConnection::DATA_SOURCE_ID }

        [
          ["Title", TitleProperty],
          ["NumberTitle", NumberProperty],
          ["SelectTitle", SelectProperty],
          ["MultiSelectTitle", MultiSelectProperty],
          ["DateTitle", DateProperty],
          ["UserTitle", PeopleProperty],
          ["File&MediaTitle", FilesProperty],
          ["CheckboxTitle", CheckboxProperty],
          ["MailTitle", EmailProperty],
          ["TelTitle", PhoneNumberProperty],
        ].each do |key, klass|
          it "has #{key}" do
            expect(properties[key]).to be_a klass
          end
        end

        it "raise error when unknown property is accessed" do
          expect { properties["Unknown"] }.to raise_error(StandardError)
        end
      end

      context "unloaded data_source" do
        let(:data_source) { DataSource.new id: TestConnection::DATA_SOURCE_ID }

        context "obtain properties after autoloading" do
          [
            ["Title", TitleProperty],
            ["NumberTitle", NumberProperty],
            ["SelectTitle", SelectProperty],
            ["MultiSelectTitle", MultiSelectProperty],
            ["DateTitle", DateProperty],
            ["UserTitle", PeopleProperty],
            ["File&MediaTitle", FilesProperty],
            ["CheckboxTitle", CheckboxProperty],
            ["UrlTitle", UrlProperty],
            ["MailTitle", EmailProperty],
            ["TelTitle", PhoneNumberProperty],
            ["CreatedTimeTitle", CreatedTimeProperty],
            ["CreatedByTitle", CreatedByProperty],
            ["LastEditedTimeTitle", LastEditedTimeProperty],
            ["LastEditedByTitle", LastEditedByProperty],
            ["FormulaTitle", FormulaProperty],
            ["RelationTitle", RelationProperty],
            ["RollupTitle", RollupProperty],
          ].each do |key, klass|
            it "has #{key} after autoloading" do
              expect(properties[key]).to be_a klass
            end
          end

          it "raise error when unknown property is accessed" do
            expect { properties["Unknown"] }.to raise_error(StandardError)
          end
        end

        context "obtain properties after assigning" do
          before { data_source.assign_property NumberProperty, "NumberTitle" }

          it "has NumberProperty without API access" do
            expect(properties["NumberTitle"]).to be_a NumberProperty
          end

          it "raise error when unassigned property is accessed" do
            expect { properties["Title"] }.to raise_error(StandardError)
          end
        end
      end

      context "unloaded data_source with assign" do
        let(:data_source) { DataSource.new id: TestConnection::DATA_SOURCE_ID, assign: [NumberProperty, "NumberTitle"] }

        it "has NumberProperty without API access" do
          expect(properties["NumberTitle"]).to be_a NumberProperty
        end

        it "raise error when unassigned property is accessed" do
          expect { properties["Title"] }.to raise_error(StandardError)
        end
      end
    end

    describe "build_child_page" do
      let(:db) { DataSource.find TestConnection::PARENT_DATA_SOURCE_ID }

      context "with assign" do
        let(:target) { db.build_child_page TitleProperty, "Name" }

        before { target.properties["Name"] << "New Page by data_source_id" }

        context "properties.map(&:name)" do
          let(:ans) { "Name" }

          it { expect(target.properties.map(&:name).sort.join(":")).to eq ans }
        end

        describe "dry_run" do
          let(:dry_run) { target.save dry_run: true }

          it_behaves_like "dry run", :post, :pages_path, json_method: :property_values_json
        end

        describe "save" do
          before { target.save }

          it { expect(target.id).to eq "267d8e4e98ab81ce88f2c23f71324a63" }
        end
      end

      context "without assign (no block)" do
        let(:target) { db.build_child_page }

        before { target.properties["Name"] << "New Page by data_source_id" }

        context "properties.map(&:name)" do
          let(:ans) { ["Name", "Related to Sample table (Column)", "Tags", "title2"] }

          it { expect(target.properties.map(&:name).sort).to eq ans }
        end

        describe "dry_run" do
          let(:dry_run) { target.save dry_run: true }

          it_behaves_like "dry run", :post, :pages_path, json_method: :property_values_json
        end

        describe "save" do
          before { target.save }

          it { expect(target.id).to eq "267d8e4e98ab81ce88f2c23f71324a63" }
        end
      end

      context "without assign (with block)" do
        let(:target) do
          db.build_child_page do |_, properties|
            properties["Name"] << "New Page by data_source_id"
          end
        end

        context "properties.map(&:name)" do
          let(:ans) { ["Name", "Related to Sample table (Column)", "Tags", "title2"] }

          it { expect(target.properties.map(&:name).sort).to eq ans }
        end

        describe "dry_run" do
          let(:dry_run) { target.save dry_run: true }

          it_behaves_like "dry run", :post, :pages_path, json_method: :property_values_json
        end

        describe "save" do
          before { target.save }

          it { expect(target.id).to eq "267d8e4e98ab81ce88f2c23f71324a63" }
        end
      end
    end

    describe "query" do
      let(:target) do
        DataSource.new id: TestConnection::DATA_SOURCE_ID,
                       assign: [NumberProperty, "NumberTitle", UrlProperty, "UrlTitle"]
      end
      let(:np) { target.properties["NumberTitle"] }
      let(:up) { target.properties["UrlTitle"] }
      let(:query) { np.filter_greater_than(100).and(up.filter_starts_with("https")).ascending(np) }
      let(:dry_run) { target.query_data_source query, dry_run: true }

      it_behaves_like "dry run", :post, :query_data_source_path, use_id: true, use_query: true
    end

    describe "query with filter_properties" do
      let(:db) { DataSource.find TestConnection::DATA_SOURCE_ID }
      let(:np) { db.properties["NumberTitle"] }
      let(:ep) { db.properties["MailTitle"] }
      let(:query) { Query.new(filter_properties: [np, ep]) }
      let(:target) { db.query_data_source query }

      it { expect(target.count).to eq 5 }
    end

    describe "created_time and last_edited_time" do
      let(:target) { DataSource.new id: TestConnection::DATA_SOURCE_ID }
      let(:ct) { target.created_time }
      let(:lt) { target.last_edited_time }
      let(:query) { ct.filter_past_week.and(lt.filter_after(Date.new(2022, 5, 10))) }
      let(:dry_run) { target.query_data_source query, dry_run: true }

      it_behaves_like "dry run", :post, :query_data_source_path, use_id: true, use_query: true
    end

    describe "build_data_source" do
      let(:parent_db) { Database.find TestConnection::DATABASE_ID }
      let(:target) do
        parent_db.build_child_data_source create_data_source_title,
                                          CheckboxProperty, "Checkbox",
                                          CreatedByProperty, "CreatedBy",
                                          CreatedTimeProperty, "CreatedTime",
                                          DateProperty, "Date",
                                          EmailProperty, "Email",
                                          FilesProperty, "Files",
                                          FormulaProperty, "Formula",
                                          LastEditedByProperty, "LastEditedBy",
                                          LastEditedTimeProperty, "LastEditedTime",
                                          MultiSelectProperty, "MultiSelect",
                                          NumberProperty, "Number",
                                          PeopleProperty, "People",
                                          PhoneNumberProperty, "PhoneNumber",
                                          RelationProperty, "Relation",
                                          RollupProperty, "Rollup",
                                          RichTextProperty, "RichText",
                                          SelectProperty, "Select",
                                          TitleProperty, "Title",
                                          UrlProperty, "Url" do |db, ps|
          fp, msp, np, rp, rup, sp = ps.values_at "Formula", "MultiSelect", "Number", "Relation", "Rollup", "Select"
          fp.formula_expression = "now()"
          msp.add_multi_select_option name: "MS1", color: "orange"
          msp.add_multi_select_option name: "MS2", color: "green"
          np.format = "yen"
          rp.replace_relation_data_source data_source_id: TestConnection::DATA_SOURCE_ID
          rup.relation_property_name = "Relation"
          rup.rollup_property_name = "NumberTitle"
          rup.function = "sum"
          sp.add_select_option name: "S1", color: "yellow"
          sp.add_select_option name: "S2", color: "default"
          db.set_icon emoji: "🎉"
        end
      end

      describe "title.full_text" do
        it { expect(target.data_source_title.full_text).to eq create_data_source_title }
      end

      describe "property_schema_json" do
        let(:ans) do
          {
            "title" => [
              {
                "href" => nil,
                "plain_text" => create_data_source_title,
                "text" => {
                  "content" => create_data_source_title,
                  "link" => nil,
                },
                "type" => "text",
              },
            ],
            "icon" => {"emoji" => "🎉", "type" => "emoji"},
            "parent" => {
              "type" => "database_id",
              "database_id" => "c37a2c66e3aa4a0da44773de3b80c253",
            },
            "properties" => {
              "Checkbox" => {"checkbox" => {}},
              "CreatedBy" => {"created_by" => {}},
              "CreatedTime" => {"created_time" => {}},
              "Date" => {"date" => {}},
              "Email" => {"email" => {}},
              "Files" => {"files" => {}},
              "Formula" => {"formula" => {"expression" => "now()"}},
              "LastEditedBy" => {"last_edited_by" => {}},
              "LastEditedTime" => {"last_edited_time" => {}},
              "MultiSelect" => {
                "multi_select" => {
                  "options" => [
                    {"color" => "orange", "name" => "MS1"},
                    {"color" => "green", "name" => "MS2"},
                  ],
                },
              },
              "Number" => {"number" => {"format" => "yen"}},
              "People" => {"people" => {}},
              "PhoneNumber" => {"phone_number" => {}},
              "Relation" => {
                "relation" => {
                  "data_source_id" => "4f93db514e1d4015b07f876e34c3b0b1",
                  "type" => "dual_property",
                  "dual_property" => {},
                },
              },
              "RichText" => {"rich_text" => {}},
              "Rollup" => {
                "rollup" => {
                  "function" => "sum",
                  "relation_property_name" => "Relation",
                  "rollup_property_name" => "NumberTitle",
                },
              },
              "Select" => {
                "select" => {
                  "options" => [
                    {"color" => "yellow", "name" => "S1"},
                    {"color" => "default", "name" => "S2"},
                  ],
                },
              },
              "Title" => {"title" => {}},
              "Url" => {"url" => {}},
            },
          }
        end

        it { expect(target.property_schema_json).to eq ans }

        describe "dry_run" do
          let(:dry_run) { target.save dry_run: true }

          it_behaves_like "dry run", :post, :data_sources_path, json_method: :property_schema_json
        end

        describe "save" do
          before { target.save }

          describe "id" do
            it { expect(target.id).to eq TestConnection::CREATED_DATA_SOURCE_ID }
          end
        end
      end
    end

    describe "create_data_source" do
      let(:parent_db) { Database.new id: TestConnection::DATABASE_ID }

      context "not dry_run" do
        let(:target) do
          parent_db.create_child_data_source create_data_source_title,
                                             CheckboxProperty, "Checkbox",
                                             CreatedByProperty, "CreatedBy",
                                             CreatedTimeProperty, "CreatedTime",
                                             DateProperty, "Date",
                                             EmailProperty, "Email",
                                             FilesProperty, "Files",
                                             FormulaProperty, "Formula",
                                             LastEditedByProperty, "LastEditedBy",
                                             LastEditedTimeProperty, "LastEditedTime",
                                             MultiSelectProperty, "MultiSelect",
                                             NumberProperty, "Number",
                                             PeopleProperty, "People",
                                             PhoneNumberProperty, "PhoneNumber",
                                             RelationProperty, "Relation",
                                             RollupProperty, "Rollup",
                                             RichTextProperty, "RichText",
                                             SelectProperty, "Select",
                                             TitleProperty, "Title",
                                             UrlProperty, "Url" do |db, ps|
            fp, msp, np, rp, rup, sp = ps.values_at "Formula", "MultiSelect", "Number", "Relation", "Rollup", "Select"
            fp.formula_expression = "now()"
            msp.add_multi_select_option name: "MS1", color: "orange"
            msp.add_multi_select_option name: "MS2", color: "green"
            np.format = "yen"
            rp.replace_relation_data_source data_source_id: TestConnection::DATA_SOURCE_ID
            rup.relation_property_name = "Relation"
            rup.rollup_property_name = "NumberTitle"
            rup.function = "sum"
            sp.add_select_option name: "S1", color: "yellow"
            sp.add_select_option name: "S2", color: "default"
            db.set_icon emoji: "🎉"
          end
        end

        describe "id" do
          it { expect(target.id).to eq TestConnection::CREATED_DATA_SOURCE_ID }
        end
      end

      context "dry_run" do
        let(:target) do
          parent_db.build_child_data_source create_data_source_title, NumberProperty, "Number" do |_, pc|
            pc["Number"].format = "percent"
          end
        end
        let(:dry_run) do
          parent_db.create_child_data_source create_data_source_title, NumberProperty, "Number",
                                             dry_run: true do |_, pc|
            pc["Number"].format = "percent"
          end
        end

        it_behaves_like "dry run", :post, :data_sources_path, json_method: :property_schema_json
      end
    end

    describe "update_data_source" do
      let(:target) { DataSource.find TestConnection::CREATED_DATA_SOURCE_ID }

      before do
        tc.clear_object_hash
        fp, msp, np, rp, rup, sp = target.properties.values_at "Formula", "MultiSelect", "Number", "Relation",
                                                               "Rollup", "Select"
        fp.formula_expression = "pi()"
        msp.add_multi_select_option name: "MS3", color: "blue"
        np.format = "percent"
        rp.replace_relation_data_source data_source_id: TestConnection::DATA_SOURCE_ID
        rup.function = "average"
        sp.add_select_option name: "S3", color: "red"
        target.set_icon emoji: "🎉"
        target.data_source_title << "(Added)"
      end

      describe "title.full_text" do
        it { expect(target.data_source_title.full_text).to eq "New data source title(Added)" }
      end

      describe "update_property_schema_json" do
        let(:ans) do
          {
            "title" => [
              {
                "href" => nil,
                "plain_text" => "New data source title",
                "text" => {
                  "content" => "New data source title",
                  "link" => nil,
                },
                "annotations" => {
                  "bold" => false,
                  "code" => false,
                  "color" => "default",
                  "italic" => false,
                  "strikethrough" => false,
                  "underline" => false,
                },
                "type" => "text",
              },
              {
                "href" => nil,
                "plain_text" => "(Added)",
                "text" => {
                  "content" => "(Added)",
                  "link" => nil,
                },
                "type" => "text",
              },
            ],
            "icon" => {"emoji" => "🎉", "type" => "emoji"},
            "properties" => {
              "Formula" => {"formula" => {"expression" => "pi()"}},
              "MultiSelect" => {
                "multi_select" => {
                  "options" => [
                    {"color" => "orange", "description" => nil, "id" => "f041d708-e5bd-4302-90cf-5826e2d6e2d4",
                     "name" => "MS1"},
                    {"color" => "green", "description" => nil, "id" => "79466eab-d44d-4669-9722-105a43fa6240",
                     "name" => "MS2"},
                    {"color" => "blue", "name" => "MS3"},
                  ],
                },
              },
              "Number" => {"number" => {"format" => "percent"}},
              "Relation" => {
                "relation" => {
                  "database_id" => "c37a2c66-e3aa-4a0d-a447-73de3b80c253",
                  "data_source_id" => TestConnection::DATA_SOURCE_ID,
                  "type" => "dual_property",
                  "dual_property" => {},
                },
              },
              "Rollup" => {
                "rollup" => {
                  "function" => "average",
                  "relation_property_name" => "Relation",
                  "rollup_property_name" => "NumberTitle",
                },
              },
              "Select" => {
                "select" => {
                  "options" => [
                    {"color" => "yellow", "description" => nil, "id" => "6d3eded4-d111-465d-ab96-978d4bf63b65",
                     "name" => "S1"},
                    {"color" => "default", "description" => nil, "id" => "42111e2e-4f29-483e-91b6-e7d08adc0b5b",
                     "name" => "S2"},
                    {"color" => "red", "name" => "S3"},
                  ],
                },
              },
            },
          }
        end

        it { expect(target.update_property_schema_json).to eq ans }

        describe "dry_run" do
          let(:dry_run) { target.save dry_run: true }

          it_behaves_like "dry run", :patch, :data_source_path, use_id: true, json_method: :update_property_schema_json
        end

        describe "save" do
          before { target.save(dry_run: true) }

          describe "id" do
            it { expect(target.id).to eq TestConnection::CREATED_DATA_SOURCE_ID }
          end
        end
      end
    end

    describe "add_property" do
      let(:target) { DataSource.find TestConnection::CREATED_DATA_SOURCE_ID }
      let(:ans) do
        {
          "properties" => {
            "added number property" => {
              "number" => {
                "format" => "euro",
              },
            },
            "added url property" => {
              "url" => {},
            },
          },
        }
      end

      before do
        tc.clear_object_hash
        target.add_property NumberProperty, "added number property" do |np|
          np.format = "euro"
        end
        target.add_property UrlProperty, "added url property"
      end

      it { expect(target.update_property_schema_json).to eq ans }

      describe "dry_run" do
        let(:dry_run) { target.save dry_run: true }

        it_behaves_like "dry run", :patch, :data_source_path, use_id: true, json_method: :update_property_schema_json
      end

      describe "save" do
        before { target.save }

        describe "id" do
          it { expect(target.properties["added url property"]).to be_an_instance_of UrlProperty }
        end
      end
    end

    describe "rename_property" do
      let(:target) { DataSource.find TestConnection::CREATED_DATA_SOURCE_ID }
      let(:ans) do
        {
          "properties" => {
            "added number property" => {"name" => "renamed number property"},
            "added url property" => {"name" => "renamed url property"},
          },
        }
      end

      before do
        tc.clear_object_hash
        target.add_property(NumberProperty, "added number property") { |np| np.format = "euro" }
        target.add_property UrlProperty, "added url property"
        target.save
        target.rename_property "added number property", "renamed number property"
        target.rename_property "added url property", "renamed url property"
      end

      it { expect(target.update_property_schema_json).to eq ans }

      describe "dry_run" do
        let(:dry_run) { target.save dry_run: true }

        it_behaves_like "dry run", :patch, :data_source_path, use_id: true, json_method: :update_property_schema_json
      end

      describe "save" do
        before { target.save }

        describe "id" do
          it { expect(target.properties["renamed number property"]).to be_an_instance_of NumberProperty }
        end
      end
    end
  end
end

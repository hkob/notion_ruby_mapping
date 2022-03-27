# frozen_string_literal: true

require_relative "../spec_helper"

module NotionRubyMapping
  RSpec.describe Database do
    let(:tc) { TestConnection.instance }
    let!(:nc) { tc.nc }

    describe "find" do
      subject { -> { Database.find database_id } }

      context "For an existing database" do
        let(:database_id) { tc.database_id }
        it "receive id" do
          expect(subject.call.id).to eq nc.hex_id(tc.database_id)
        end

        describe "database_title" do
          it {
            expect(subject.call.database_title.full_text).to eq "Sample table"
          }
        end

        describe "dry_run" do
          let(:dry_run) { Database.find "database_id", dry_run: true }
          it_behaves_like :dry_run, :get, :database_path, id: "database_id"
        end
      end

      context "Wrong database" do
        context "wrong format id" do
          let(:database_id) { "AAA" }
          it "raise exception" do
            expect { subject.call }.to raise_error(StandardError)
          end
        end

        context "wrong id" do
          let(:database_id) { tc.unpermitted_database }
          it "Can't receive database" do
            expect { subject.call }.to raise_error(StandardError)
          end
        end
      end
    end

    describe "new and reload" do
      let(:database) { Database.new id: database_id }
      subject { -> { database.reload } }

      context "For an existing database" do
        let(:database_id) { tc.database_id }
        it "has not json before reload" do
          expect(database.json).to be_nil
        end

        it "receive id" do
          expect(subject.call.id).to eq nc.hex_id(tc.database_id)
        end

        it "has json after reloading" do
          expect(subject.call.json).not_to be_nil
        end
      end

      context "Wrong database" do
        context "wrong format id" do
          let(:database_id) { "AAA" }
          it "has not json before reload" do
            expect(database.json).to be_nil
          end

          it "raise exception" do
            expect { subject.call }.to raise_error(StandardError)
          end
        end

        context "wrong id" do
          let(:database_id) { tc.unpermitted_database_id }
          it "raise exception" do
            expect { subject.call }.to raise_error(StandardError)
          end
        end
      end
    end

    describe "properties" do
      let(:properties) { database.properties }

      context "loaded database" do
        let(:database) { Database.find tc.database_id }
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

      context "unloaded database" do
        let(:database) { Database.new id: tc.database_id }
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
          before { database.assign_property NumberProperty, "NumberTitle" }
          it "has NumberProperty without API access" do
            expect(properties["NumberTitle"]).to be_a NumberProperty
          end

          it "raise error when unassigned property is accessed" do
            expect { properties["Title"] }.to raise_error(StandardError)
          end
        end
      end

      context "unloaded database with assign" do
        let(:database) { Database.new id: tc.database_id, assign: [NumberProperty, "NumberTitle"] }
        it "has NumberProperty without API access" do
          expect(properties["NumberTitle"]).to be_a NumberProperty
        end

        it "raise error when unassigned property is accessed" do
          expect { properties["Title"] }.to raise_error(StandardError)
        end
      end
    end

    describe "create_child_page" do
      let(:db) { Database.find tc.parent_database_id }
      context "with assign" do
        let(:target) { db.create_child_page TitleProperty, "Name" }
        before { target.properties; target.properties["Name"] << "New Page Title" }
        context "properties.map(&:name)" do
          let(:ans) { "Name" }
          it { expect(target.properties.map(&:name).sort.join(":")).to eq ans }
        end

        describe "dry_run" do
          let(:dry_run) { target.save dry_run: true }
          it_behaves_like :dry_run, :post, :pages_path, json_method: :property_values_json
        end

        describe "save" do
          before { target.save }
          it { expect(target.id).to eq "40d6dc22988942f38540ba5b6ab8d858" }
        end
      end


      context "without assign (no block)" do
        let(:target) { db.create_child_page }
        before { target.properties; target.properties["Name"] << "New Page Title" }
        context "properties.map(&:name)" do
          let(:ans) { ["Name", "Related to Sample table (Column)", "Tags", "title2"] }
          it { expect(target.properties.map(&:name).sort).to eq ans }
        end

        describe "dry_run" do
          let(:dry_run) { target.save dry_run: true }
          it_behaves_like :dry_run, :post, :pages_path, json_method: :property_values_json
        end

        describe "save" do
          before { target.save }
          it { expect(target.id).to eq "40d6dc22988942f38540ba5b6ab8d858" }
        end
      end

      context "without assign (with block)" do
        let(:target) do
          db.create_child_page do |_, properties|
            properties["Name"] << "New Page Title"
          end
        end

        context "properties.map(&:name)" do
          let(:ans) { ["Name", "Related to Sample table (Column)", "Tags", "title2"] }
          it { expect(target.properties.map(&:name).sort).to eq ans }
        end

        describe "dry_run" do
          let(:dry_run) { target.save dry_run: true }
          it_behaves_like :dry_run, :post, :pages_path, json_method: :property_values_json
        end

        describe "save" do
          before { target.save }
          it { expect(target.id).to eq "40d6dc22988942f38540ba5b6ab8d858" }
        end
      end
    end

    describe "query" do
      let(:target) { Database.new id: tc.database_id, assign: [NumberProperty, "NumberTitle", UrlProperty, "UrlTitle"] }
      let(:np) { target.properties["NumberTitle"] }
      let(:up) { target.properties["UrlTitle"] }
      let(:query) { np.filter_greater_than(100).and(up.filter_starts_with("https")).ascending(np) }
      let(:dry_run) { target.query_database query, dry_run: true }
      it_behaves_like :dry_run, :post, :query_database_path, use_id: true, use_query: true
    end

    describe "created_time and last_edited_time" do
      let(:target) { Database.new id: tc.database_id }
      let(:ct) { target.created_time }
      let(:lt) { target.last_edited_time }
      let(:query) { ct.filter_past_week.and(lt.filter_after(Date.new(2022, 5, 10))) }
      let(:dry_run) { target.query_database query, dry_run: true }
      it_behaves_like :dry_run, :post, :query_database_path, use_id: true, use_query: true
    end

    describe "create_database" do
      let(:parent_page) { Page.new id: tc.top_page_id }
      let(:target) do
        parent_page.create_child_database "New database title",
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
                                          UrlProperty, "Url"
      end
      before do
        fp, msp, np, rp, rup, sp = target.properties.values_at "Formula", "MultiSelect", "Number", "Relation",
                                                               "Rollup", "Select"
        fp.formula_expression = "now()"
        msp.add_multi_select_options name: "MS1", color: "orange"
        msp.add_multi_select_options name: "MS2", color: "green"
        np.format = "yen"
        rp.replace_relation_database database_id: tc.database_id
        rup.relation_property_name = "Relation"
        rup.rollup_property_name = "NumberTitle"
        rup.function = "sum"
        sp.add_select_options name: "S1", color: "yellow"
        sp.add_select_options name: "S2", color: "default"
        target.set_icon emoji: "🎉"
      end

      describe "title.full_text" do
        it { expect(target.database_title.full_text).to eq "New database title" }
      end

      describe "property_schema_json" do
        let(:ans) do
          {
            "title" => [
              {
                "href" => nil,
                "plain_text" => "New database title",
                "text" => {
                  "content" => "New database title",
                  "link" => nil,
                },
                "type" => "text",
              },
            ],
            "icon" => {"emoji" => "🎉", "type" => "emoji"},
            "parent" => {
              "type" => "page_id",
              "page_id" => "c01166c613ae45cbb96818b4ef2f5a77",
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
              "Relation" => {"relation" => {"database_id" => "c37a2c66e3aa4a0da44773de3b80c253"}},
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
          it_behaves_like :dry_run, :post, :databases_path, json_method: :property_schema_json
        end

        describe "save" do
          before { target.save }
          describe "id" do
            it { expect(target.id).to eq "c7697137d49f49c2bbcdd6a665c4f921" }
          end
        end
      end
    end

    describe "update_database" do
      let(:target) { Database.find "c7697137d49f49c2bbcdd6a665c4f921" }
      before do
        tc.clear_object_hash
        fp, msp, np, rp, rup, sp = target.properties.values_at "Formula", "MultiSelect", "Number", "Relation",
                                                               "Rollup", "Select"
        fp.formula_expression = "pi"
        msp.add_multi_select_options name: "MS3", color: "blue"
        np.format = "percent"
        rp.replace_relation_database database_id: tc.database_id, synced_property_name: "Renamed table"
        rup.function = "average"
        sp.add_select_options name: "S3", color: "red"
        target.set_icon emoji: "🎉"
        target.database_title << "(Added)"
      end

      describe "title.full_text" do
        it { expect(target.database_title.full_text).to eq "New database title(Added)" }
      end

      describe "update_property_schema_json" do
        let(:ans) do
          {
            "title" => [
              {
                "href" => nil,
                "plain_text" => "New database title",
                "text" => {
                  "content" => "New database title",
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
              "Formula" => {"formula" => {"expression" => "pi"}},
              "MultiSelect" => {
                "multi_select" => {
                  "options" => [
                    {"color" => "orange", "id" => "98aaa1c0-4634-47e2-bfae-d739a8c5e564", "name" => "MS1"},
                    {"color" => "green", "id" => "71756a93-cfd8-4675-b508-facb1c31af2c", "name" => "MS2"},
                    {"color" => "blue", "name" => "MS3"},
                  ],
                },
              },
              "Number" => {"number" => {"format" => "percent"}},
              "Relation" => {
                "relation" => {
                  "database_id" => "c37a2c66e3aa4a0da44773de3b80c253",
                  "synced_property_id" => "mfBo",
                  "synced_property_name" => "Renamed table",
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
                    {"color" => "yellow", "id" => "56a526e1-0cec-4b85-b9db-fc68d00e50c6", "name" => "S1"},
                    {"color" => "default", "id" => "6ead7aee-d7f0-40ba-aa5e-59bccf6c50c8", "name" => "S2"},
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
          it_behaves_like :dry_run, :patch, :database_path, use_id: true, json_method: :update_property_schema_json
        end

        describe "save" do
          before { target.save }
          describe "id" do
            it { expect(target.id).to eq "c7697137d49f49c2bbcdd6a665c4f921" }
          end
        end
      end
    end

    describe "add_property" do
      let(:target) { Database.find "c7697137d49f49c2bbcdd6a665c4f921" }
      before do
        tc.clear_object_hash
        target.add_property NumberProperty, "added number property" do |np|
          np.format = "euro"
        end
        target.add_property UrlProperty, "added url property"
      end
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
      it { expect(target.update_property_schema_json).to eq ans }

      describe "dry_run" do
        let(:dry_run) { target.save dry_run: true }
        it_behaves_like :dry_run, :patch, :database_path, use_id: true, json_method: :update_property_schema_json
      end

      describe "save" do
        before { target.save }
        describe "id" do
          it { expect(target.properties["added url property"]).to be_an_instance_of UrlProperty }
        end
      end
    end

    describe "rename_property" do
      let(:target) { Database.find "c7697137d49f49c2bbcdd6a665c4f921" }
      before do
        tc.clear_object_hash
        target.add_property NumberProperty, "added number property" do |np|
          np.format = "euro"
        end
        target.add_property UrlProperty, "added url property"
        target.save
        properties = target.properties
        properties["added number property"].new_name = "renamed number property"
        properties["added url property"].new_name = "renamed url property"
      end
      let(:ans) do
        {
          "properties" => {
            "added number property" => {"name" => "renamed number property"},
            "added url property" => {"name" => "renamed url property"},
          },
        }
      end
      it { expect(target.update_property_schema_json).to eq ans }

      describe "dry_run" do
        let(:dry_run) { target.save dry_run: true }
        it_behaves_like :dry_run, :patch, :database_path, use_id: true, json_method: :update_property_schema_json
      end

      describe "save" do
        before { target.save }
        describe "id" do
          it { expect(target.properties["renamed number property"]).to be_an_instance_of NumberProperty }
        end
      end
    end

    describe "remove_properties" do
      let(:target) { Database.find "c7697137d49f49c2bbcdd6a665c4f921" }
      before do
        tc.clear_object_hash
        target.add_property NumberProperty, "added number property" do |np|
          np.format = "euro"
        end
        target.add_property UrlProperty, "added url property"
        target.save
        properties = target.properties
        properties["added number property"].new_name = "renamed number property"
        properties["added url property"].new_name = "renamed url property"
        target.save
        target.remove_properties "renamed number property", "renamed url property"
      end
      let(:ans) do
        {
          "properties" => {
            "renamed number property" => nil,
            "renamed url property" => nil,
          },
        }
      end
      it { expect(target.update_property_schema_json).to eq ans }

      describe "dry_run" do
        let(:dry_run) { target.save dry_run: true }
        it_behaves_like :dry_run, :patch, :database_path, use_id: true, json_method: :update_property_schema_json
      end

      describe "save" do
        before { target.save }
        describe "id" do
          it { expect { target.properties["renamed_number_property"] }.to raise_error(StandardError) }
        end
      end
    end
  end
end

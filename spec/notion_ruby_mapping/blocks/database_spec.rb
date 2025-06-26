# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe Database do
    let(:tc) { TestConnection.instance }
    let!(:nc) { tc.nc }

    describe "find" do
      subject { -> { Database.find database_id } }

      context "For an existing database" do
        let(:database_id) { TestConnection::DATABASE_ID }

        it "receive id" do
          expect(subject.call.id).to eq nc.hex_id(TestConnection::DATABASE_ID)
        end

        describe "database_title" do
          it {
            expect(subject.call.database_title.full_text).to eq "Sample table"
          }
        end

        describe "dry_run" do
          let(:dry_run) { Database.find "database_id", dry_run: true }

          it_behaves_like "dry run", :get, :database_path, id: "database_id"
        end
      end

      context "For an existing database (url)" do
        let(:database_id) { TestConnection::DATABASE_URL }

        it "receive id" do
          expect(subject.call.id).to eq nc.hex_id(TestConnection::DATABASE_ID)
        end

        describe "database_title" do
          it {
            expect(subject.call.database_title.full_text).to eq "Sample table"
          }
        end

        describe "dry_run" do
          let(:dry_run) { Database.find "database_id", dry_run: true }

          it_behaves_like "dry run", :get, :database_path, id: "database_id"
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
          let(:database_id) { TestConnection::UNPERMITTED_DATABASE_ID }

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
        let(:database_id) { TestConnection::DATABASE_ID }

        it "has not json before reload" do
          expect(database.json).to be_nil
        end

        it "receive id" do
          expect(subject.call.id).to eq nc.hex_id(TestConnection::DATABASE_ID)
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
          let(:database_id) { TestConnection::UNPERMITTED_DATABASE_ID }

          it "raise exception" do
            expect { subject.call }.to raise_error(StandardError)
          end
        end
      end
    end

    describe "properties" do
      let(:properties) { database.properties }

      context "loaded database" do
        let(:database) { Database.find TestConnection::DATABASE_ID }

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
        let(:database) { Database.new id: TestConnection::DATABASE_ID }

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
        let(:database) { Database.new id: TestConnection::DATABASE_ID, assign: [NumberProperty, "NumberTitle"] }

        it "has NumberProperty without API access" do
          expect(properties["NumberTitle"]).to be_a NumberProperty
        end

        it "raise error when unassigned property is accessed" do
          expect { properties["Title"] }.to raise_error(StandardError)
        end
      end
    end

    describe "build_child_page" do
      let(:db) { Database.find TestConnection::PARENT_DATABASE_ID }

      context "with assign" do
        let(:target) { db.build_child_page TitleProperty, "Name" }

        before { target.properties["Name"] << "New Page Title" }

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

          it { expect(target.id).to eq "b6e9af0269cd4999bce9e28593f65070" }
        end
      end

      context "without assign (no block)" do
        let(:target) { db.build_child_page }

        before { target.properties["Name"] << "New Page Title" }

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

          it { expect(target.id).to eq "b6e9af0269cd4999bce9e28593f65070" }
        end
      end

      context "without assign (with block)" do
        let(:target) do
          db.build_child_page do |_, properties|
            properties["Name"] << "New Page Title"
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

          it { expect(target.id).to eq "b6e9af0269cd4999bce9e28593f65070" }
        end
      end
    end

    describe "query" do
      let(:target) do
        Database.new id: TestConnection::DATABASE_ID, assign: [NumberProperty, "NumberTitle", UrlProperty, "UrlTitle"]
      end
      let(:np) { target.properties["NumberTitle"] }
      let(:up) { target.properties["UrlTitle"] }
      let(:query) { np.filter_greater_than(100).and(up.filter_starts_with("https")).ascending(np) }
      let(:dry_run) { target.query_database query, dry_run: true }

      it_behaves_like "dry run", :post, :query_database_path, use_id: true, use_query: true
    end

    describe "query with filter_properties" do
      let(:db) { Database.find TestConnection::DATABASE_ID }
      let(:np) { db.properties["NumberTitle"] }
      let(:ep) { db.properties["MailTitle"] }
      let(:query) { Query.new(filter_properties: [np, ep]) }
      let(:target) { db.query_database query }

      it { expect(target.count).to eq 5 }
    end

    describe "created_time and last_edited_time" do
      let(:target) { Database.new id: TestConnection::DATABASE_ID }
      let(:ct) { target.created_time }
      let(:lt) { target.last_edited_time }
      let(:query) { ct.filter_past_week.and(lt.filter_after(Date.new(2022, 5, 10))) }
      let(:dry_run) { target.query_database query, dry_run: true }

      it_behaves_like "dry run", :post, :query_database_path, use_id: true, use_query: true
    end

    describe "build_database" do
      let(:parent_page) { Page.new id: TestConnection::TOP_PAGE_ID }
      let(:target) do
        parent_page.build_child_database "New database title",
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
          rp.replace_relation_database database_id: TestConnection::DATABASE_ID
          rup.relation_property_name = "Relation"
          rup.rollup_property_name = "NumberTitle"
          rup.function = "sum"
          sp.add_select_option name: "S1", color: "yellow"
          sp.add_select_option name: "S2", color: "default"
          db.set_icon emoji: "🎉"
        end
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
              "Relation" => {
                "relation" => {
                  "database_id" => "c37a2c66e3aa4a0da44773de3b80c253",
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

          it_behaves_like "dry run", :post, :databases_path, json_method: :property_schema_json
        end

        describe "save" do
          before { target.save }

          describe "id" do
            it { expect(target.id).to eq "eeca3a41f903435da15875f9358cad5d" }
          end
        end
      end
    end

    describe "create_database" do
      let(:parent_page) { Page.new id: TestConnection::TOP_PAGE_ID }

      context "not dry_run" do
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
                                            UrlProperty, "Url" do |db, ps|
            fp, msp, np, rp, rup, sp = ps.values_at "Formula", "MultiSelect", "Number", "Relation", "Rollup", "Select"
            fp.formula_expression = "now()"
            msp.add_multi_select_option name: "MS1", color: "orange"
            msp.add_multi_select_option name: "MS2", color: "green"
            np.format = "yen"
            rp.replace_relation_database database_id: TestConnection::DATABASE_ID
            rup.relation_property_name = "Relation"
            rup.rollup_property_name = "NumberTitle"
            rup.function = "sum"
            sp.add_select_option name: "S1", color: "yellow"
            sp.add_select_option name: "S2", color: "default"
            db.set_icon emoji: "🎉"
          end
        end

        describe "id" do
          it { expect(target.id).to eq "eeca3a41f903435da15875f9358cad5d" }
        end
      end

      context "dry_run" do
        let(:target) do
          parent_page.build_child_database "New database title", NumberProperty, "Number" do |_, pc|
            pc["Number"].format = "percent"
          end
        end
        let(:dry_run) do
          parent_page.create_child_database "New database title", NumberProperty, "Number", dry_run: true do |_, pc|
            pc["Number"].format = "percent"
          end
        end

        it_behaves_like "dry run", :post, :databases_path, json_method: :property_schema_json
      end
    end

    describe "update_database" do
      let(:target) { Database.find "c7697137d49f49c2bbcdd6a665c4f921" }

      before do
        tc.clear_object_hash
        fp, msp, np, rp, rup, sp = target.properties.values_at "Formula", "MultiSelect", "Number", "Relation",
                                                               "Rollup", "Select"
        fp.formula_expression = "pi"
        msp.add_multi_select_option name: "MS3", color: "blue"
        np.format = "percent"
        rp.replace_relation_database database_id: TestConnection::DATABASE_ID
        rup.function = "average"
        sp.add_select_option name: "S3", color: "red"
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

          it_behaves_like "dry run", :patch, :database_path, use_id: true, json_method: :update_property_schema_json
        end

        describe "save" do
          before { target.save(dry_run: true) }

          describe "id" do
            it { expect(target.id).to eq "c7697137d49f49c2bbcdd6a665c4f921" }
          end
        end
      end
    end

    describe "add_property" do
      let(:target) { Database.find "c7697137d49f49c2bbcdd6a665c4f921" }
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

        it_behaves_like "dry run", :patch, :database_path, use_id: true, json_method: :update_property_schema_json
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

        it_behaves_like "dry run", :patch, :database_path, use_id: true, json_method: :update_property_schema_json
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

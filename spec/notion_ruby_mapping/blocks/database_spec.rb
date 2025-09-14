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

    describe "data_sources" do
      let(:db) { Database.find TestConnection::DATABASE_ID }
      let(:ds) { db.data_sources }

      it { expect(ds.size).to eq 1 }
      it { expect(ds.first.id).to eq "4f93db514e1d4015b07f876e34c3b0b1" }
    end

    describe "build_child_page" do
      let(:db) { Database.find TestConnection::PARENT_DATABASE_ID }

      context "with assign" do
        let(:target) { db.build_child_page TitleProperty, "Name" }

        before { target.properties["Name"] << "New Page by database_id" }

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

          it { expect(target.id).to eq "268d8e4e98ab81749583cdbec7ef851c" }
        end
      end

      context "without assign (no block)" do
        let(:target) { db.build_child_page }

        before { target.properties["Name"] << "New Page by database_id" }

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

          it { expect(target.id).to eq "268d8e4e98ab81749583cdbec7ef851c" }
        end
      end

      context "without assign (with block)" do
        let(:target) do
          db.build_child_page do |_, properties|
            properties["Name"] << "New Page by database_id"
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

          it { expect(target.id).to eq "268d8e4e98ab81749583cdbec7ef851c" }
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
            "initial_data_source" => {
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
                    "data_source_id" => TestConnection::DATA_SOURCE_ID,
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
            it { expect(target.id).to eq "d6215198c95644a8b76c307ec08be555" }
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
          it { expect(target.id).to eq "d6215198c95644a8b76c307ec08be555" }
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
  end
end

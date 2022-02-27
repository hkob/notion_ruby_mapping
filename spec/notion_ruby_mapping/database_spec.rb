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
            ["MailTitle", EmailProperty],
            ["TelTitle", PhoneNumberProperty],
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

    # describe "query" do
    #   let(:database) { Database.new id: tc.database_id }
    #   subject { database.query_database query }
    #   context "no filter, no sort" do
    #     before { tc.query_database :limit2 }
    #     let(:query) { Query.new page_size: 2 }
    #     it "count page count" do
    #       expect(subject.count).to eq 2
    #     end
    #   end

    #     context "text filter" do
    #       let(:query) { TitleProperty.new("Title").filter_starts_with("A") }
    #       it "count page count" do
    #         expect(subject.count).to eq 1
    #       end
    #     end
    #
    #     context "text filter and ascending sort" do
    #       let(:tp) { TitleProperty.new("Title") }
    #       let(:query) { tp.filter_starts_with("A").ascending tp }
    #       it "count page count" do
    #         expect(subject.count).to eq 1
    #       end
    #     end
    #   end
    #
    #   describe "update_icon" do
    #     let(:database) { Database.new id: config["database"] }
    #     before { database.set_icon(**params) }
    #     subject { database.icon }
    #
    #     context "for emoji icon" do
    #       let(:params) { {emoji: "😀"} }
    #       it "update icon (emoji)" do
    #         is_expected.to eq({"type" => "emoji", "emoji" => "😀"})
    #       end
    #     end
    #
    #     context "for link icon" do
    #       let(:url) { "https://cdn.profile-image.st-hatena.com/users/hkob/profile.png" }
    #       let(:params) { {url: url} }
    #       it "update icon (link)" do
    #         is_expected.to eq({"type" => "external", "external" => {"url" => url}})
    #       end
    #     end
    # end
  end
end

# frozen_string_literal: true

require_relative "../spec_helper"

module NotionRubyMapping
  RSpec.describe Page do
    let(:config) { YAML.load_file "env.yml" }
    let!(:nc) { NotionCache.instance.create_client config["notion_token"] }

    describe "find" do
      context "For an existing top page" do
        let(:top_page) { Page.find config["top_page"] }

        it "receive id" do
          expect(top_page.id).to eq nc.hex_id(config["top_page"])
        end
      end

      context "Wrong page" do
        context "wrong format id" do
          subject { Page.find "AAA" }
          it "Can't receive page" do
            expect(subject).to be_nil
          end
        end

        context "wrong id" do
          subject { Page.find config["unpermitted_page"] }
          it "Can't receive page" do
            is_expected.to be_nil
          end
        end
      end
    end

    describe "update_icon" do
      let(:top_page) { Page.new id: config["top_page"] }
      before { top_page.set_icon(**params) }
      subject { top_page.icon }

      context "for emoji icon" do
        let(:params) { {emoji: "😀"} }
        it "update icon (emoji)" do
          is_expected.to eq({"type" => "emoji", "emoji" => "😀"})
        end
      end

      context "for link icon" do
        let(:url) { "https://cdn.profile-image.st-hatena.com/users/hkob/profile.png" }
        let(:params) { {url: url } }
        it "update icon (link)" do
          is_expected.to eq({"type" => "external", "external" => {"url" => url}})
        end
      end
    end

    describe "update" do
       context "Unloaded page" do
         let(:page) { Page.new id: config["first_page"] }
         [
           [NumberProperty, "NumberTitle", {number: 3.14}, [[%w[number], 3.14]]],
           [SelectProperty, "SelectTitle", {select: "Select 1"}, [[%w[select name], "Select 1"]]],
           [MultiSelectProperty, "MultiSelectTitle", {multi_select: "Multi Select 1"},
            [
              [["multi_select", 0, "name"], "Multi Select 1"]
            ],
           ],
           [DateProperty, "DateTitle", {start_date: Date.new(2022, 2, 21), end_date: Date.new(2022, 2, 22)},
            [
              [%w[date start], "2022-02-21"],
              [%w[date end], "2022-02-22"],
            ]
           ],
         ].each do |(klass, title, constructor_hash, array)|
           it "update #{title} by add_property_for_update (willl deprecate)" do
             property = klass.new title, **constructor_hash
             page.add_property_for_update property
             page.update
             array.each do |(keys, answer)|
               value = keys.reduce(page.properties[title].create_json) { |hash, k| hash[k] }
               expect(value).to eq answer
             end
             page.clear_object
           end
         end

         [
           ["NumberTitle", :number=, 1.7320508, [[%w[number], 1.7320508]]],
           ["SelectTitle", :select=, "Select 2", [[%w[select name], "Select 2"]]],
           ["MultiSelectTitle", :multi_select=, ["Multi Select 2"],
            [
              [["multi_select", 0, "name"], "Multi Select 2"]
            ],
           ],
           ["DateTitle", :start_date=, Time.new(2022, 2, 24, 1, 23, 45, "+09:00"),
            [
              [%w[date start], "2022-02-24T01:23:00.000+09:00"],
              [%w[date end], nil],
            ],
           ]
         ].each do |(title, method, value, array)|
           it "update #{title} by substitution(autoload)" do
             property = page.properties[title]
             property.send method, value
             page.update
             array.each do |(keys, answer)|
               value = keys.reduce(page.properties[title].create_json) { |hash, k| hash[k] }
               expect(value).to eq answer
             end
             page.clear_object
           end
         end

         [
           [NumberProperty, "NumberTitle", :number=, 1.7320508, [[%w[number], 1.7320508]]],
           [SelectProperty, "SelectTitle", :select=, "Select 2", [[%w[select name], "Select 2"]]],
           [MultiSelectProperty, "MultiSelectTitle", :multi_select=, ["Multi Select 2"],
            [
              [["multi_select", 0, "name"], "Multi Select 2"]
            ],
           ],
           [DateProperty, "DateTitle", :start_date=, Time.new(2022, 2, 24, 1, 23, 45, "+09:00"),
            [
              [%w[date start], "2022-02-24T01:23:00.000+09:00"],
              [%w[date end], nil],
            ],
           ]
         ].each do |(klass, title, method, value, array)|
           it "update #{title} by assign_property" do
             property = page.assign_property klass, title
             property.send method, value
             page.update
             array.each do |(keys, answer)|
               value = keys.reduce(page.properties[title].create_json) { |hash, k| hash[k] }
               expect(value).to eq answer
             end
             page.clear_object
           end
         end
       end


       context "loaded page" do
         let(:page) { Page.find config["first_page"] }
         [
           ["NumberTitle", :number=, 1.41421356, [[%w[number], 1.41421356]]],
           ["SelectTitle", :select=, "Select 3", [[%w[select name], "Select 3"]]],
           ["MultiSelectTitle", :multi_select=, ["Multi Select 2", "Multi Select 1"],
            [
              [["multi_select", 0, "name"], "Multi Select 2"],
              [["multi_select", 1, "name"], "Multi Select 1"],
            ],
           ],
           ["DateTitle", :start_date=, DateTime.new(2022, 2, 25, 1, 23, 45, "+09:00"),
            [
              [%w[date start], "2022-02-25T01:23:00.000+09:00"],
              [%w[date end], nil],
            ],
           ]
         ].each do |(title, method, value, array)|
           it "update #{title}Property by substitution" do
             property = page.properties[title]
             property.send method, value
             page.update
             array.each do |(keys, answer)|
               value = keys.reduce(page.properties[title].create_json) { |hash, k| hash[k] }
               expect(value).to eq answer
             end
             page.clear_object
           end
         end
       end
    end
  end
end

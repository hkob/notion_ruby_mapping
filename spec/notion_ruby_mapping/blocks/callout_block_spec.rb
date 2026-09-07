# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe CalloutBlock do
    type = "callout"
    external_url = "https://img.icons8.com/ios-filled/250/000000/mac-os.png"

    it_behaves_like "retrieve block", described_class, TestConnection.block_id(type), true, {
      "object" => "block",
      "type" => "callout",
      "callout" => {
        "rich_text" => [
          {
            "type" => "text",
            "text" => {
              "content" => "Callout",
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
            "href" => nil,
            "plain_text" => "Callout",
          },
        ],
        "icon" => {
          "type" => "emoji",
          "emoji" => "✅",
        },
        "color" => "gray_background",
      },
    }

    describe "constructor" do
      context "when create from json" do
        {
          "emoji": ["callout", "✅", nil],
          "internal icon": ["callout_internal_file", nil, "https://prod-files-secure.s3.us-west-2.amazonaws.com/2b7b01f0-67a8-40f8-acd4-88dd2805f216/47582aed-8508-49ce-8a8f-7b8b7a8bf830/symbol.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=ASIAZI2LB466XSG5KJRP%2F20260831%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20260831T111511Z&X-Amz-Expires=3600&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEMv%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCXVzLXdlc3QtMiJHMEUCIQCnJ6XOjqVLhn93YK3w%2B6%2BzMJKlDc%2BdDOgAsIZnUo68JQIgRR4Sf3v3HDgjAfuf%2B3NcL5IztkhHco%2FMSSHsNlv%2B90cqiAQIlP%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FARAAGgw2Mzc0MjMxODM4MDUiDHnIdDE2Uib8yY%2BCbCrcA7N1mNiiRYb7Q2vpq84uizE4MqNhsgw9FGFcq%2BH4Gga8PttT7pArb%2BSwBRLLzYNuex01%2B5zNbWGJhuIOFRmp49NT7DWf%2BvLWPBUpyiRajNBdJFwDZU6qMZEgqmZFdqynPDEepLOikbkfX7fmgdm6VeAPJp3RL8LPztjfewvyEhs4f4jpFIxuLjxuhvfaPjFNT7McuUqMCTN%2FaPhdphfO1qBb6tRJOS7SAXZ%2F92GaqE4XcaemW0wgkmWUNwTpoSDJtAChMAnlywz65sNa99j%2FhJNqvSqgy5E8MKXIp4rRGa7GmVaFO%2Bg1dS1MZztT6DYacWxspUTH6wr4yn1LP%2BG6plJmps3FImPVMLCDxTGyGX%2BwdjNYh7u5QQGaQVl9ITxuIw26f7DRs%2FsSqlHDhgAtJiij%2BIk507bO5ajeG1nZEA9qxVVqG5V%2FN1WyhTFuD2nknszHj4DLdIqc%2FZOl0sQvQxEi%2BPiw%2FbkkS3C1f8Wdhgdfpic%2BE6c7JSQqZh%2BRhZEiqs4%2B65YNglaLXdIS2i2j1cMZGoWXiFIbozdCxxKToRQ6uQGE8rNJYc5MdfzPkLnIHRQ%2Fr7Dvufp3oPIhaxZBMwmwGdkUOMrjJfbGsVTPDnXrel%2BLB8iOfGiHNgSWMIW71dQGOqUB0t64YVgEXzl5TA%2BybSxxhY2AeAOkuc29afLiNhvzGUOa8bKds59V0T5QUzvF3r4zpuLcsHoGFOetkv%2FEUTX5b4XsEvFIKsBqhZ78wYqXTAYMzt9BzbZvlBEMm4PhS0FupJ%2FLrK761xw9TuTfE%2Bokn6qSI%2Fzh5dxANBPoDtH3Vo75Xnlq9uaDCBZ9mrdCnHqwxNPSOAAg3zeP2uOMsf1hC5jGfCpr&X-Amz-Signature=31106a0162040f3005532f2a544067d609e505a8eff8bea40957e62b9d40ff73&X-Amz-SignedHeaders=host&x-amz-checksum-mode=ENABLED&x-id=GetObject"],
          "external icon": ["callout_external_file", nil, external_url],
        }.each do |key, values|
          fname, emoji, file_url = values
          json = TestConnection.instance.read_json "retrieve_block_#{fname}"
          context "when #{key}" do
            subject { CalloutBlock.new key, json: json }
            it { expect(subject.emoji).to eq emoji }
            it { expect(subject.file_url).to eq file_url }
          end
        end
      end

      context "when create from parameter" do
        context "emoji" do
          subject { CalloutBlock.new "callout by emoji", emoji: "✅" }
          it { expect(subject.emoji).to eq "✅" }
          it { expect(subject.file_url).to be_nil }
        end

        context "file_url" do
          subject { CalloutBlock.new "callout by file_url", file_url: external_url }
          it { expect(subject.emoji).to be_nil }
          it { expect(subject.file_url).to eq external_url }
        end

        context "both" do
          subject { -> { CalloutBlock.new "callout by emoji & file_url", emoji: "✅", file_url: external_url } }

          it { expect { subject.call }.to raise_error(ArgumentError, "Specify either emoji or file_url, not both.") }
        end

        context "both unsettled" do
          subject { -> { CalloutBlock.new "callout by none" } }

          it { expect { subject.call }.to raise_error(ArgumentError, "Specify either emoji or file_url.") }
        end
      end
    end

    describe "create_child_block" do
      context "when callout_emoji" do
        let(:sub_block) { ParagraphBlock.new "with children" }
        let(:target) { described_class.new "Emoji callout", emoji: "✅", color: "blue", sub_blocks: sub_block }

        it_behaves_like "create child block", described_class,
                        "26cd8e4e98ab8140b7a1ca62044cd1c5", "26cd8e4e98ab810f9122f43ae1a17649"
      end

      context "callout url" do
        let(:sub_block) { ParagraphBlock.new "with children" }
        let(:target) do
          described_class.new "Url callout", file_url: "https://img.icons8.com/ios-filled/250/000000/mac-os.png",
                                             sub_blocks: sub_block
        end

        it_behaves_like "create child block", described_class,
                        "26cd8e4e98ab81fbbedddee3debd6120", "26cd8e4e98ab810881e3dda5d55aed3b"
      end
    end

    describe "save (update)" do
      let(:update_id) { TestConnection.update_block_id(type) }
      let(:target) { described_class.new "old text", id: update_id, emoji: "✅", color: "green_background" }

      it_behaves_like "update block rich text array", type, "new text"
      it_behaves_like "update block color", type, "orange_background"

      context "file_url" do
        let(:file_url) { "https://img.icons8.com/ios-filled/250/000000/mac-os.png" }
        let(:json) do
          {
            "callout" => {
              "icon" => {
                "type" => "external",
                "external" => {
                  "url" => file_url,
                },
              },
            },
          }
        end

        before { target.file_url = file_url }

        it { expect(target.update_block_json).to eq json }
        it { expect(target.emoji).to be_nil }
        it { expect(target.file_url).to eq file_url }

        context "when dry_run" do
          let(:dry_run) { target.save dry_run: true }

          it_behaves_like "dry run", :patch, :block_path, use_id: true, json_method: :update_block_json
        end

        context "when save" do
          it { expect(target.save.file_url).to eq file_url }
        end
      end

      context "emoji" do
        let(:emoji) { "💡" }
        let(:json) do
          {
            "callout" => {
              "icon" => {
                "type" => "emoji",
                "emoji" => "💡",
              },
            },
          }
        end

        before { target.emoji = emoji }

        it { expect(target.update_block_json).to eq json }
        it { expect(target.emoji).to eq "💡" }
        it { expect(target.file_url).to be_nil }

        context "when dry_run" do
          let(:dry_run) { target.save dry_run: true }

          it_behaves_like "dry run", :patch, :block_path, use_id: true, json_method: :update_block_json
        end

        context "when save" do
          it { expect(target.save.emoji).to eq emoji }
        end
      end
    end
  end
end

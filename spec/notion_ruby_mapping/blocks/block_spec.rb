# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe Block do
    tc = TestConnection.instance
    let!(:nc) { tc.nc }

    TestConnection::BLOCK_ID_HASH.each do |key, id|
      describe "For #{key} block" do
        let(:target) { Block.find id }

        it "receive id" do
          expect(target.id).to eq nc.hex_id(id)
        end

        can_have_children = %i[bulleted_list_item paragraph inline_contents numbered_list_item synced_block template
                               toggle toggle_heading_1 toggle_heading_2 toggle_heading_3 quote table to_do
                               synced_block_original callout column_list column append_after_parent
                               append_after_previous].include? key
        it "can #{key} have children? = #{can_have_children}" do
          expect(target.can_have_children).to eq can_have_children
        end
      end
    end

    describe "create child block" do
      page_id = TestConnection::BLOCK_CREATE_TEST_PAGE_ID
      block_id = TestConnection::BLOCK_CREATE_TEST_BLOCK_ID
      let(:org_page) { Page.new id: page_id }
      let(:org_block) { CalloutBlock.new "ABC", id: block_id, emoji: "💡" }
      let(:sub_block) { ParagraphBlock.new "with children" }

      %i[column file image_file link_preview_dropbox].each do |key|
        describe "#{key} block" do
          let(:target) { Block.find TestConnection::BLOCK_ID_HASH[key] }

          %i[page block].each do |pb|
            is_page = pb == :page
            context "when for #{pb}" do
              subject { -> { (is_page ? org_page : org_block).append_block_children target } }
              it { expect { subject.call }.to raise_error StandardError }
            end
          end
        end
      end
    end

    describe "append block children with after" do
      parent_id = TestConnection::APPEND_AFTER_PARENT_ID
      previous_id = TestConnection::APPEND_AFTER_PREVIOUS_ID
      append_block = NumberedListItemBlock.new "Middle block"
      let(:parent_block) { Block.find parent_id }
      let(:above_block) { Block.find previous_id }

      shared_examples "append_block_children_append_after" do
        context "dry_run" do
          it_behaves_like "dry run", :patch, :append_block_children_page_path, id: parent_id,
                                                                               json: {
                                                                                 children: [append_block.block_json],
                                                                                 after: previous_id,
                                                                               }
        end

        context "create" do
          it { expect(block.id).to eq TestConnection::APPEND_AFTER_ADDED_ID }
        end
      end

      context "after option" do
        let(:dry_run) { parent_block.append_block_children append_block, after: previous_id, dry_run: true }
        let(:block) { parent_block.append_block_children append_block, after: previous_id }

        it_behaves_like "append_block_children_append_after"
      end

      context "append_after method" do
        let(:dry_run) { above_block.append_after append_block, dry_run: true }
        let(:block) { above_block.append_after append_block }

        it_behaves_like "append_block_children_append_after"
      end
    end

    describe "destroy" do
      let(:id) { TestConnection::DESTROY_BLOCK_ID }
      let(:target) { Block.new(id: id) }

      context "dry_run" do
        let(:dry_run) { target.destroy dry_run: true }

        it_behaves_like "dry run", :delete, :block_path, use_id: true
      end

      context "delete" do
        let(:deleted_item) { target.destroy }

        it "receive id" do
          expect(deleted_item.id).to eq nc.hex_id(id)
        end

        it "is archived" do
          expect(deleted_item.get(:archived)).to be_truthy
        end
      end
    end

    describe "find" do
      let(:url) { TestConnection::H1_BLOCK_URL }
      let(:block) { Block.find url }

      it { expect(block.id).to eq "0250fb6d600142eca4c74efb8794fc6b" }
    end
  end
end

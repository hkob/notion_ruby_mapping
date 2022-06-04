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
                               synced_block_original callout column_list column].include? key
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
            context "for #{pb}" do
              subject { -> { (is_page ? org_page : org_block).append_block_children target } }
              it { expect { subject.call }.to raise_error StandardError }
            end
          end
        end
      end
    end

    describe "destroy" do
      let(:id) { TestConnection::DESTROY_BLOCK_ID }
      let(:target) { Block.new(id: id) }
      context "dry_run" do
        let(:dry_run) { target.destroy dry_run: true }
        it_behaves_like :dry_run, :delete, :block_path, use_id: true
      end

      context "delete" do
        let(:deleted_item) { target.destroy }
        it "receive id" do
          expect(deleted_item.id).to eq nc.hex_id(id)
        end

        it "should be archived" do
          expect(deleted_item.get("archived")).to be_truthy
        end
      end
    end
  end
end

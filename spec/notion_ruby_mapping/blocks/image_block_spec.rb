# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe ImageBlock do
    type = "image"

    it_behaves_like "retrieve block", described_class, TestConnection.block_id("image_external"), false, {
      "object" => "block",
      "type" => "image",
      "image" => {
        "caption" => [],
        "type" => "external",
        "external" => {
          "url" => "https://cdn.worldvectorlogo.com/logos/notion-logo-1.svg",
        },
      },
    }

    describe "create_child_block" do
      let(:target) do
        described_class.new "https://cdn.worldvectorlogo.com/logos/notion-logo-1.svg", caption: "Notion logo"
      end

      it_behaves_like "create child block", described_class,
                      "7b2f144fd2714ea690db8ffd5a84e8f0", "9a94b3131a1d4a0b814e60c8bf0345f1"
    end

    describe "save (update)" do
      let(:update_id) { TestConnection.update_block_id(type) }
      let(:target) do
        described_class.new "https://cdn.worldvectorlogo.com/logos/notion-logo-1.svg", caption: "Notion logo",
                                                                                       id: update_id
      end

      it_behaves_like "update block file", type, "https://img.icons8.com/ios-filled/250/000000/mac-os.png"

      it_behaves_like "update block caption", type, "macOS logo"
    end

    describe "update_block_image_file_upload" do
      let(:target) { described_class.new "abc", id: "20bd8e4e98ab802193bef79f70225b06" }
      let(:file_upload_object) do
        instance_double FileUploadObject, id: TestConnection::FILE_UPLOAD_IMAGE_ID, fname: "test.png"
      end

      before do
        allow(file_upload_object).to receive(:is_a?).with(FileUploadObject).and_return(true)
        target.file_upload_object = file_upload_object
      end

      it {
        expect(target.update_block_json).to eq(
          {
            type => {
              "file_upload" => {
                "id" => file_upload_object.id,
              },
            },
          },
        )
      }

      context "when dry_run" do
        let(:dry_run) { target.save dry_run: true }

        it_behaves_like "dry run", :patch, :block_path, use_id: true, json_method: :update_block_json
      end

      context "when save" do
        it {
          expect(target.save.url).to eq "https://prod-files-secure.s3.us-west-2.amazonaws.com/2b7b01f0-67a8-40f8-acd4-88dd2805f216/bf91dfb5-72e5-4c22-bab7-f4b9f343610f/ErSxuLeq.png-medium.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=ASIAZI2LB4666BB74DJX%2F20250608%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20250608T121924Z&X-Amz-Expires=3600&X-Amz-Security-Token=IQoJb3JpZ2luX2VjELH%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCXVzLXdlc3QtMiJHMEUCIQDw04ltTUdFVJWSiblxH7rY%2BVFpnszPidOu8RNsDTVZvAIgJn80Nw5fitnnIs371VIIXkiU6o7h55zGdw2szr5QGH4qiAQIiv%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FARAAGgw2Mzc0MjMxODM4MDUiDBKZCHN%2F%2B4yhqq1rBCrcAw%2BXsqQMLL60oKzNT4hcFm3flRRwM7WTXaq2AUn0CQ9i7CnQ4KfoRdrKoe3xfTB0FFztWj5UBGMozZrNLMDQcEpz3GaEU9Uiuhfytwthll%2FBYRtjIbjGCG6f3Z2kTCJhijLpTxK18zwdamPHt6XAQZwO4xxD8F7aYkUBOp%2F%2Bllgesjt7qd%2FirkacfhfFl6Oq%2FB6qB5r9A%2BeM%2BZqjjEIr2e2uK0PcDvTqMCC%2FAR1oOSa2h8iPbrt0blCfGEolTX8BrdZNc41fCkboySwCuzwgTQmPc6Uduhcg0IYchz08DXbz3Bt8fhX1jNvaPxktSsoKEkccBaKv8wqRM9rBpl0KwbSrGd40fSigc4YZHqiWapqxi2EgxHotov1ErjnKLLuq6JMa%2FuNvJsLNoSGsvWyz7d7%2FSQ4ON9YyGvaYJxAkPMH%2FL%2BdczySQbKHWorJQSv4Im83MLl%2BTYj6AFP2TaykOHEEKO1cNmuGBbzbgOpQb1pWDbsDQAYcQLMYUKOofs0mmpwmXSgJ9xwjSro4hLbkiZSoXj9O%2FCTA3F5IpN1fIa7TO8PIFRK4NLpgML4Nh8M66XVPwy2vW5JnaFKIaF7W8VZgHwGIc5ZCHfOsXqeT2IHtL9JBGFDaMZpxjkdgPMLGelcIGOqUBSyJgy6iedfnxv4h1kdY5rYXL0nFTY3oSWprn7%2FPC6S96K8iHDsMk62K5JXP59%2Bh65JdQfn6HmhkXDpFmqmKrogpVNAl%2Bu%2Br9cQvt1ZhltGK8K%2BMCPw4c0Bh%2BsanYay3Xc7ikTPF1yCREz1iI%2FlEZCPG5mU9%2BaQEDlvBE%2BfuqqW5z%2BHwGeHqdz%2BnUizPG0r6kw5IGyB08Pmfaor%2BbJv6ARPp983K7&X-Amz-Signature=da104a5969d427c9edeecad80a93fdf6a8fccd6a9d2791cb03667bb647e70ad6&X-Amz-SignedHeaders=host&x-id=GetObject"
        }
      end
    end
  end
end

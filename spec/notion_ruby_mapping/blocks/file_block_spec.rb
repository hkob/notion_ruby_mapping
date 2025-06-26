# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe FileBlock do
    type = "file"

    it_behaves_like "retrieve block", described_class, TestConnection.block_id(type), false, {
      "object" => "block",
      "type" => "file",
      "file" => {
        "type" => "file",
        "file" => {
          "url" => "https://s3.us-west-2.amazonaws.com/secure.notion-static.com/c55cf49f-fcb4-497e-9645-d484f03bf1d5/sample.txt?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAT73L2G45EIPT3X45%2F20220426%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20220426T132600Z&X-Amz-Expires=3600&X-Amz-Signature=0a6b8b6a0d6ae1ca7ec024d357b2c3eb52ed6f0ce14bcead00da1961ad03a6de&X-Amz-SignedHeaders=host&x-id=GetObject",
          "expiry_time" => "2022-04-26T14:26:00.536Z",
        },
        "caption" => [],
      },
    }

    describe "create_child_block" do
      let(:sub_block) { ParagraphBlock.new "with children" }
      let(:target) do
        described_class.new "https://img.icons8.com/ios-filled/250/000000/mac-os.png", caption: "macOS icon"
      end

      it_behaves_like "create child block", described_class,
                      "7d216c4e05784d3fade4be41d03f3aa2", "a3e050b85d654b3799c85abe24fa0da1"
    end

    describe "save (update)" do
      let(:update_id) { TestConnection.update_block_id(type) }
      let(:target) do
        described_class.new "https://img.icons8.com/ios-filled/250/000000/mac-os.png",
                            caption: "macOS icon", id: update_id
      end

      it_behaves_like "update block caption", type, "Notion logo"
      it_behaves_like "update block file", type, "https://cdn.worldvectorlogo.com/logos/notion-logo-1.svg"
    end

    describe "update_block_file_file_upload" do
      let(:target) { described_class.new "abc", id: "20bd8e4e-98ab-8081-ad29-dd62726e4525" }
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
          expect(target.save.url).to eq "https://prod-files-secure.s3.us-west-2.amazonaws.com/2b7b01f0-67a8-40f8-acd4-88dd2805f216/bf91dfb5-72e5-4c22-bab7-f4b9f343610f/ErSxuLeq.png-medium.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=ASIAZI2LB4666A5RECQ7%2F20250608%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20250608T115825Z&X-Amz-Expires=3600&X-Amz-Security-Token=IQoJb3JpZ2luX2VjELD%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCXVzLXdlc3QtMiJIMEYCIQD5ST8JlsjghfDkcWp3xihh%2B0byAjsIDkc2aW0IRkSS%2BAIhAMphaW6h2vfFunHO%2B1EGb6DlLiEJ4rreBcZiS47i4ZitKogECIn%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEQABoMNjM3NDIzMTgzODA1Igwk%2FzBEoNUbyockbjkq3ANZmgEJWqJ2HdqMUyNcpJtNI4gToQ%2BcAXYswsfyNcJvV1yDazhob0KYQ%2FpniSCQPa6iORJ53Wyheg5Fo0GPvXE60bUhtcY0VKGg8U1HXVEwpATztFO6R37eAhsN6t6eN4y5ndn6CRjxVwCi5hX%2Fvfs4i6pzUDIZXvmtlSJJLt4BXdadf%2BhXADgDfL2d2qLyzdnA%2BPR7R0a9RuCAhp7cnqFbBNVrVmtgk1XUNdobV81ij%2BY6%2B2Gwf1k8j9MhaWDO1LQiUzwDErCscM%2Bp0WjREbgnfu%2F1QiFrsoJ2%2FnBvVKmFY3fPkYfwwPWCqlyjPLUqBWVdlCbhTz9UqWun%2BpXUZ9qCvWI%2FPOz43FKBvBLnefqG5tkqbyDAVh5escZisLK%2FtmV5ptWm%2FZf2U2SUeCyh8cOGLvon3%2Bf2GSfRj0T2abrWtXRzOTFJYJiMRmtHrnwGZ%2BrJmiSjU%2F5NH27e6kny6IZSIZwgW%2Fppejlfclzp2Qp0C8KDSuNZaHtcm7D5bFxN1DNGASnyz6C9pYu8QVw4vKpQXgr6rEvVHV6YXZB3EOwWAHD4%2FuA6Fg6dWJxy6N02RUZ%2B1ofSWPAIP9K67hzOfB0IhHH65TkmQDzXNMQADpB140RqyFKGlzSzOsh7bjDggZXCBjqkARQOaKDzsXc5QS2OtVCc5oPeV%2BQ%2FIYfM2uLFQQRlb4MjSRalKjK2%2Flkyn5CMLRqnapi1KzGq5KllHIuKBP6OeO6EF0Xk%2B4Mjtt%2BiFm6tofYK4T7%2BcVSUdIAR5TOF6WPN7vhHAKbGm1tZu5gbzxyKuJk5SVrSVdeakBr1N2sQTzFoGOjOcCm%2B8mkWKD7PR0nCEGTL1QnHt%2BYAKBf9AFBEZ3kdiulS&X-Amz-Signature=a12e8df1da28ef5b129263f215ec13f839c89ac1bcf6e03ba4e707117a4cc66d&X-Amz-SignedHeaders=host&x-id=GetObject"
        }
      end
    end
  end
end

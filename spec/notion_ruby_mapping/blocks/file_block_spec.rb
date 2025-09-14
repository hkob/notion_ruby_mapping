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
          "url" => "https://prod-files-secure.s3.us-west-2.amazonaws.com/2b7b01f0-67a8-40f8-acd4-88dd2805f216/c55cf49f-fcb4-497e-9645-d484f03bf1d5/sample.txt?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=ASIAZI2LB466RSBCTPNM%2F20250913%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20250913T064752Z&X-Amz-Expires=3600&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEMb%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCXVzLXdlc3QtMiJGMEQCIDUYXZwPTsFLXxWDOsGAKIfx65c%2Ft5ztnYM3hcrrErKZAiAZbD0ixLKikc%2FCsC7vEX0lh5SzGwD550KU5M55F7G3%2Fir%2FAwg%2FEAAaDDYzNzQyMzE4MzgwNSIMiD2S9Aa941VfLCdeKtwDDwE8l2PpeRtZ2zph4d7b8hhevvt71vCJ9Ju3T70FPQ2ylE%2BQPLYfxd65AH5NepZjs5Tmg%2BAwnsIBOgu9oJ431mOttjIIvZ4LglBSrgEasVFouRHPALVcpnqDQxdVavdHmigyIhUqdktvSs19BfLqVfQlJMgGa7x4ykKJsE9IjOib%2BXSFnSqKe4ZZglePxsyPfsdRIod2xATDp3Pw4cG8iLtM5sxacwV3xXbMpczf3SMHb%2F2kEB9YRjPYOEmGTWy79gaKV4PAoZPB4yXcTf2DRmoXvJAi%2FM1v1blsaRw14XMFXJ3tXMwu1iP0XW2HepYb6UGNj%2Bgci0Y2GNGI2E7ZEGK%2FtcJooQ0J091JL4aGUjTP9f1K0ebqQtrj9LljVJEp9yRr2yIu%2B7oORHIJhbZsSpy0hvNS%2BVORrrj%2BmAkJ96j8Zqcth4arcbFQdu1GxngmapDmwqCTvl9slf8WR5SMAIQ7MjS%2FZnqYAala3HbaHjC9ZFnCLqIuwFq6MzIv9KqGEfUV5SrbETL4jnJWpQT3r0kEfmwdF%2BRY8U4%2FnkbJpO%2FL%2BokVXG2lEUuNDnumI5WifchPSY8lsPdFYRlxjShRT0t4dPf7GOEAi2W7q2zQ6fjX%2FPQQrtR%2FYgPEzsMwsJeUxgY6pgGW%2FqLiFuN1jCCdESPEbGJuRmtFMNfaAiPuikTAS3zE76QLyNyEemZzcQMGrHFv4zIm6UNWch5tyhFiKku%2FntJARNB4YsYDdRl4COWu5%2FFaiSyeOoF3akixPOl5kA3VKYJHkK49FfdQOUmnXIGhgh7hdtOYdaYHzBmaeHoln85P%2FKG8gwiZEd4cdrd%2FU0V9t4RKTb2Jg9b6mwrwwJ0dooX3l%2BJkQ2Pb&X-Amz-Signature=80cfc38f2703e2305b3bff01a45a600266d2ac33121d85564461e17e13424e03&X-Amz-SignedHeaders=host&x-amz-checksum-mode=ENABLED&x-id=GetObject",
          "expiry_time" => "2025-09-13T07:47:52.410Z",
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
                      "26dd8e4e98ab81f8ad4bf95cfbb4156c", "26dd8e4e98ab8180ac43ccff75418f5e"
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

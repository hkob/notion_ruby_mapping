# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe FileObject do
    tc = TestConnection.instance
    file_internal_json = tc.read_json "file_internal_object"
    file_external_json = tc.read_json "file_external_object"
    url = "https://example.com/external.jpg"
    let(:file_upload_object) { instance_double(FileUploadObject, id: TestConnection::FILE_UPLOAD_IMAGE_ID) }

    describe "constructor" do
      context "with url" do
        subject { FileObject.new url: url }

        it { expect(subject.url).to eq url }
        it { expect(subject.type).to eq "external" }
        it { expect(subject.will_update).to be_falsey }
      end

      context "with file_upload_object" do
        subject { FileObject.new file_upload_object: file_upload_object }

        it { expect(subject.file_upload_object).to eq file_upload_object }
        it { expect(subject.type).to eq "file_upload" }
        it { expect(subject.will_update).to be_falsey }
      end

      context "with json" do
        subject { FileObject.new json: file_internal_json }

        it { expect(subject.url).to eq file_internal_json["file"]["url"] }
        it { expect(subject.type).to eq "file" }
        it { expect(subject.will_update).to be_falsey }
      end

      context "without arguments" do
        subject { -> { FileObject.new } }

        it { expect { subject.call }.to raise_error(StandardError) }
      end
    end

    describe "self.file_object" do
      subject { FileObject.file_object fo }
      context "with url string" do
        let(:fo) { url }

        it { expect(subject).to be_is_a FileObject }
        it { expect(subject.url).to eq url }
      end

      context "with FileUploadObject" do
        let(:fo) { file_upload_object }

        before { allow(file_upload_object).to receive(:is_a?).with(FileUploadObject).and_return(true) }

        it { expect(subject).to be_is_a FileObject }
        it { expect(subject.file_upload_object).to eq file_upload_object }
      end

      context "with FileObject" do
        let(:fo) { FileObject.new url: url }

        it { expect(subject).to be_is_a FileObject }
        it { expect(subject.url).to eq url }
      end
    end

    describe "property_values_json" do
      context "when internal image" do
        let(:target) { FileObject.new json: file_internal_json }

        it_behaves_like "property values json", {
          "type" => "file",
          "file" => {
            "url" => "https://s3.us-west-2.amazonaws.com/secure.notion-static.com/f7b6864c-f809-498d-8725-03fc7e85a9ff/nr.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAT73L2G45EIPT3X45%2F20220309%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20220309T235624Z&X-Amz-Expires=3600&X-Amz-Signature=1e86183da3411466cead5f144b5a955ea5be1844ec06c6893689a3fb86c369e2&X-Amz-SignedHeaders=host&x-id=GetObject",
            "expiry_time" => "2022-03-10T00:56:24.105Z",
          },
        }
      end

      context "when external image" do
        let(:target) { FileObject.new json: file_external_json }

        it_behaves_like "property values json", {
          "type" => "external",
          "external" => {
            "url" => "https://img.icons8.com/ios-filled/250/000000/mac-os.png",
          },
        }
      end

      context "when file upload object" do
        let(:target) { FileObject.new file_upload_object: file_upload_object }

        it_behaves_like "property values json", {
          "type" => "file_upload",
          "file_upload" => {
            "id" => TestConnection::FILE_UPLOAD_IMAGE_ID,
          },
        }
      end
    end

    describe "create from json" do
      context "when internal image" do
        let(:target) { FileObject.new json: file_internal_json }

        it_behaves_like "property values json", {
          "type" => "file",
          "file" => {
            "url" => "https://s3.us-west-2.amazonaws.com/secure.notion-static.com/f7b6864c-f809-498d-8725-03fc7e85a9ff/nr.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAT73L2G45EIPT3X45%2F20220309%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20220309T235624Z&X-Amz-Expires=3600&X-Amz-Signature=1e86183da3411466cead5f144b5a955ea5be1844ec06c6893689a3fb86c369e2&X-Amz-SignedHeaders=host&x-id=GetObject",
            "expiry_time" => "2022-03-10T00:56:24.105Z",
          },
        }
      end

      context "when external image" do
        let(:target) { FileObject.new json: file_external_json }

        it_behaves_like "property values json", {
          "type" => "external",
          "external" => {
            "url" => "https://img.icons8.com/ios-filled/250/000000/mac-os.png",
          },
        }
        it { expect(target.url).to eq "https://img.icons8.com/ios-filled/250/000000/mac-os.png" }
      end
    end

    describe "url=" do
      context "when internal image" do
        let(:target) { FileObject.new json: file_internal_json }

        before { target.url = url }

        it_behaves_like "property values json", {
          "type" => "external",
          "external" => {
            "url" => url,
          },
        }
        it { expect(target.url).to eq url }
      end

      context "when external image" do
        let(:target) { FileObject.new json: file_external_json }

        before { target.url = url }

        it_behaves_like "property values json", {
          "type" => "external",
          "external" => {
            "url" => url,
          },
        }
        it { expect(target.url).to eq url }
      end
    end

    describe "file_upload_object=" do
      let(:target) { FileObject.new json: file_internal_json }

      before { target.file_upload_object = file_upload_object }

      it_behaves_like "property values json", {
        "type" => "file_upload",
        "file_upload" => {
          "id" => TestConnection::FILE_UPLOAD_IMAGE_ID,
        },
      }
      it { expect(target.file_upload_object).to eq file_upload_object }
    end
  end
end

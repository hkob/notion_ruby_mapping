# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe FileUploadObject do
    tc = TestConnection.instance

    describe "initialize" do
      context "with a small file" do
        let(:fname) { "spec/fixtures/ErSxuLeq.png-medium.png" }
        let(:id) { TestConnection::FILE_UPLOAD_IMAGE_ID }
        let(:response) { tc.read_json "upload_file_image" }

        before do
          allow(tc.nc.multipart_client).to receive(:send)
            .and_return(instance_double(Faraday::Response, {body: response}))
        end

        subject { described_class.new(fname: fname) }

        it { expect(subject.id).to eq id }
      end
    end
  end
end

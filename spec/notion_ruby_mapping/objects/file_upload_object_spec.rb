# frozen_string_literal: true

require "tempfile"

module NotionRubyMapping
  RSpec.describe FileUploadObject do
    tc = TestConnection.instance

    describe "initialize" do
      context "with a small file" do
        let(:fname) { "spec/fixtures/ErSxuLeq.png-medium.png" }
        let(:id) { TestConnection::FILE_UPLOAD_IMAGE_ID }
        let(:response) { tc.read_json "upload_file_image" }
        let(:fui) { tc.read_json "create_file_upload_image" }

        before do
          allow(tc.nc).to receive(:create_file_upload_request).and_return(fui)
          allow(tc.nc.multipart_client).to receive(:send)
            .and_return(instance_double(Faraday::Response, {body: response}))
          allow(File).to receive(:exist?).with(fname).and_return(true)
          allow(File).to receive(:size).with(fname).and_return(15_369)
          allow(Faraday::Multipart::FilePart).to receive(:new).and_return(instance_double(Faraday::Multipart::FilePart))
        end

        subject { described_class.new(fname: fname) }

        it { expect(subject.id).to eq id }
      end

      context "with a large file" do
        let(:fname) { "spec/fixtures/sample-15s.mp4" }
        let(:id) { TestConnection::FILE_UPLOAD_VIDEO_ID }
        let(:response1) { tc.read_json "upload_file_video1" }
        let(:response2) { tc.read_json "upload_file_video2" }

        let(:fuv) { tc.read_json "create_file_upload_video" }

        before do
          allow(tc.nc).to receive(:create_file_upload_request).and_return(fuv)
          allow(tc.nc.multipart_client).to receive(:send)
            .and_invoke(
              ->(_) { instance_double(Faraday::Response, {body: response1}) },
              ->(_) { instance_double(Faraday::Response, {body: response2}) },
            )
          allow(File).to receive(:exist?).with(fname).and_return(true)
          allow(File).to receive(:size).with(fname).and_return(11_916_526)
          allow(Faraday::Multipart::FilePart).to receive(:new).and_return(instance_double(Faraday::Multipart::FilePart))
          allow(FileUploadObject).to receive(:split_to_small_files).and_return(
            [
              instance_double(Tempfile,
                              path: "/var/folders/cw/9fjhttb17jbb3233xc3k9l3c0000gp/T/split20250622-98904-sy5cs0",
                              close: true, unlink: true),
              instance_double(Tempfile,
                              path: "/var/folders/cw/9fjhttb17jbb3233xc3k9l3c0000gp/T/split20250622-98904-xpxrhe",
                              close: true, unlink: true),
            ],
          )
        end

        subject { described_class.new(fname: fname) }

        it { expect(subject.id).to eq id }
      end
    end

    describe "split_to_small_files" do
      before do
        @org_file = Tempfile.new("org_file")
        @org_file.write "0" * 26
        @org_file.rewind
        @temp_files = described_class.split_to_small_files(@org_file.path, 20)
      end

      after do
        @temp_files.each { |f| f.close }
        @org_file.close
      end

      it "splits the file into smaller parts" do
        expect(@temp_files.size).to eq 2
        expect(File.size(@temp_files[0].path)).to eq 20
        expect(File.size(@temp_files[1].path)).to eq 6
      end
    end
  end
end

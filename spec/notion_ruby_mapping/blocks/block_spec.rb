# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe Page do
    tc = TestConnection.instance
    let!(:nc) { tc.nc }

    {
      bookmark: "aa1c25bc-b172-4a36-898d-3ce5e1f572b7",
      breadcrumb: "6d2ed6f3-8f74-4e83-8766-747b6d7995f6",
      bulleted_list_item: "8a0d35c5-145e-41fd-89ac-e46deb85d24f",
      callout: "715a6550-c737-444f-ac99-4be7822c88d3",
      child_database: "ea525a78-4669-470d-b425-8c4d7cb95667",
      code: "c9a46c89-109b-486a-8105-6ca82f4f6515",
      column_list: "93195eab-21f7-4419-bf44-0e4c07092573",
      divider: "e34f7164-4535-48fd-9c49-1d320f77bda2",
      embed_twitter: "e4c0811c-7154-4fed-9e8c-02d885c898ef",
      equation: "6a1f76eb-337e-4169-a77b-cb8b1d79a88e",
      file: "0da49a8b-963e-42e6-a9ee-0deb765d5b40",
      heading_1: "0a58761e-f3b4-429f-b86e-0ad9ff815fe1",
      heading_2: "d34096c9-62ba-4633-9294-db488ca7b8cc",
      heading_3: "fef62d73-8d83-4791-b2da-681816f56389",
      image_external: "ae7be035-7ad1-418a-bb8e-f0f2d039220c",
      image_file: "293ace37-42f5-45a6-b8ff-1352f4b3e7c6",
      inline_contents: "2515e2f2-a53f-40c3-a2ea-1b5d47afee09",
      link_preview_dropbox: "7b391df0-1dc5-430e-aae0-1bc0392cdcb5",
      link_to_page: "b921ff3c-b13c-43c2-b53a-d9d1ba19b8c1",
      numbered_list_item: "1860edbc-410d-408b-87f6-1e37e07352a2",
      paragraph: "79ddb5ed-15c7-4a40-9cf6-a018d23ceb19",
      quote: "8eba490b-cc83-4384-9cb0-9a739a4be91c",
      synced_block_copy: "ea7b5183-eea2-4d30-b019-010921e93b2c",
      synced_block_original: "4815032e-6f24-43e4-bc8c-9bdc6299b090",
      table: "ba612e8b-c858-4569-9822-ccca7ab4c709",
      table_of_contents: "0de608aa-c31b-4c5c-a84a-ae48d8ea05b8",
      template: "12fe0347-f8c4-4da0-ace9-9c8992b5827f",
      to_do: "676129de-8eac-42c9-9449-c15893775cae",
      toggle: "005923da-b39f-4af6-bbd1-1be98150d2b2",
      toggle_heading_1: "82daa282-435d-4f9f-8f3b-b8c0328a963f",
      toggle_heading_2: "e5f16356-8adc-49c5-9f17-228589d071ac",
      toggle_heading_3: "115fb937-ab6d-4a2e-9079-921b03e50756",
      video: "bed3abe0-2009-4aa9-9056-4844f981b07a",
    }.each do |key, id|
      describe "For #{key} block" do
        let(:target) { Block.find id }
        it "receive id" do
          expect(target.id).to eq nc.hex_id(id)
        end
      end
    end
  end
end

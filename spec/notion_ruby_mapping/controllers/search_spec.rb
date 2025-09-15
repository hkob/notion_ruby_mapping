module NotionRubyMapping
  RSpec.describe Search do
    describe "dry_run" do
      let(:dry_run) { search.exec dry_run: true }

      context "nothing" do
        let(:search) { Search.new }

        it_behaves_like "dry run", :post, :search_path, json: {}
      end

      context "ascending: true" do
        let(:search) { Search.new ascending: true }

        it_behaves_like "dry run", :post, :search_path, json:
          {
            "sort" => {
              "direction" => "ascending",
              "timestamp" => "last_edited_time",
            },
          }
      end

      context "database_only: true" do
        let(:search) { Search.new database_only: true }

        it_behaves_like "dry run", :post, :search_path, json:
          {
            "filter" => {
              "value" => "database",
              "property" => "object",
            },
          }
      end

      context "page_only: true" do
        let(:search) { Search.new page_only: true }

        it_behaves_like "dry run", :post, :search_path, json:
          {
            "filter" => {
              "value" => "page",
              "property" => "object",
            },
          }
      end

      context "query" do
        let(:search) { Search.new query: "ABC" }

        it_behaves_like "dry run", :post, :search_path, json:
          {
            "query" => "ABC",
          }
      end
    end

    describe "exec" do
      let(:exec) { Search.new(query: "Sample table", database_only: true).exec }

      it { expect(exec.first.data_source_title.full_text).to eq "Sample table" }
    end
  end
end

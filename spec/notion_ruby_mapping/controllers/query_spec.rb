# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe Query do
    let(:tc) { TestConnection.instance }
    let(:tp) { TitleProperty.new "tp" }
    let(:np) { NumberProperty.new "np" }
    let(:cp) { CheckboxProperty.new "cp" }
    let(:letp) { LastEditedTimeProperty.new "letp" }

    describe "filter" do
      subject { query.filter }

      context "one filter" do
        let(:query) { tp.filter_starts_with "start" }

        it "create a single filter" do
          expect(subject).to eq({"property" => "tp", "title" => {"starts_with" => "start"}})
        end
      end

      context "(A and B) filter" do
        let(:query) do
          tp.filter_starts_with("start")
            .and(np.filter_greater_than(100))
        end

        it "create and filter" do
          expect(subject).to eq({
                                  "and" => [
                                    {
                                      "property" => "tp",
                                      "title" => {"starts_with" => "start"},
                                    },
                                    {
                                      "property" => "np",
                                      "number" => {"greater_than" => 100},
                                    },
                                  ],
                                })
        end
      end

      context "(A and B and C) filter" do
        let(:query) do
          tp.filter_starts_with("start")
            .and(np.filter_greater_than(100))
            .and(cp.filter_equals(true))
        end

        it "create and filter" do
          expect(subject).to eq({
                                  "and" => [
                                    {
                                      "property" => "tp",
                                      "title" => {"starts_with" => "start"},
                                    },
                                    {
                                      "property" => "np",
                                      "number" => {"greater_than" => 100},
                                    },
                                    {
                                      "property" => "cp",
                                      "checkbox" => {"equals" => true},
                                    },
                                  ],
                                })
        end
      end

      context "(A or B) filter" do
        let(:query) do
          tp.filter_starts_with("start")
            .or(np.filter_greater_than(100))
        end

        it "create or filter" do
          expect(subject).to eq({
                                  "or" => [
                                    {
                                      "property" => "tp",
                                      "title" => {"starts_with" => "start"},
                                    },
                                    {
                                      "property" => "np",
                                      "number" => {"greater_than" => 100},
                                    },
                                  ],
                                })
        end
      end

      context "(A or B or C) filter" do
        let(:query) do
          tp.filter_starts_with("start")
            .or(np.filter_greater_than(100))
            .or(cp.filter_equals(true))
        end

        it "create or filter" do
          expect(subject).to eq({
                                  "or" => [
                                    {
                                      "property" => "tp",
                                      "title" => {"starts_with" => "start"},
                                    },
                                    {
                                      "property" => "np",
                                      "number" => {"greater_than" => 100},
                                    },
                                    {
                                      "property" => "cp",
                                      "checkbox" => {"equals" => true},
                                    },
                                  ],
                                })
        end
      end

      context "((A and B) or C) filter" do
        let(:query) do
          tp.filter_starts_with("start")
            .and(np.filter_greater_than(100))
            .or(cp.filter_equals(true))
        end

        it "create or filter" do
          expect(subject).to eq({
                                  "or" => [
                                    {
                                      "and" => [
                                        {
                                          "property" => "tp",
                                          "title" => {"starts_with" => "start"},
                                        },
                                        {
                                          "property" => "np",
                                          "number" => {"greater_than" => 100},
                                        },
                                      ],
                                    },
                                    {
                                      "property" => "cp",
                                      "checkbox" => {"equals" => true},
                                    },
                                  ],
                                })
        end
      end

      context "((A or B) and C) and filter" do
        let(:query) do
          tp.filter_starts_with("start")
            .or(np.filter_greater_than(100))
            .and(cp.filter_equals(true))
        end

        it "create or filter" do
          expect(subject).to eq({
                                  "and" => [
                                    {
                                      "or" => [
                                        {
                                          "property" => "tp",
                                          "title" => {"starts_with" => "start"},
                                        },
                                        {
                                          "property" => "np",
                                          "number" => {"greater_than" => 100},
                                        },
                                      ],
                                    },
                                    {
                                      "property" => "cp",
                                      "checkbox" => {"equals" => true},
                                    },
                                  ],
                                })
        end
      end

      context "((A and B) or (C and D)) filter" do
        let(:query) do
          np.filter_greater_than(100).and(np.filter_less_than(200))
            .or(np.filter_greater_than(300).and(np.filter_less_than(400)))
        end

        it "create or filter" do
          expect(subject).to eq({
                                  "or" => [
                                    {
                                      "and" => [
                                        {
                                          "property" => "np",
                                          "number" => {"greater_than" => 100},
                                        },
                                        {
                                          "property" => "np",
                                          "number" => {"less_than" => 200},
                                        },
                                      ],
                                    },
                                    {
                                      "and" => [
                                        {
                                          "property" => "np",
                                          "number" => {"greater_than" => 300},
                                        },
                                        {
                                          "property" => "np",
                                          "number" => {"less_than" => 400},
                                        },
                                      ],
                                    },
                                  ],
                                })
        end
      end
    end

    describe "sort" do
      subject { query.sort }

      context "ascending" do
        it "create ascending sort (property)" do
          expect(Query.new.ascending(tp).sort).to eq([{"property" => "tp", "direction" => "ascending"}])
        end

        it "create ascending sort (timestamp)" do
          expect(Query.new.ascending(letp).sort).to eq([{"timestamp" => "letp", "direction" => "ascending"}])
        end
      end

      context "descending" do
        it "create a descending sort" do
          expect(Query.new.descending(tp).sort).to eq([{"property" => "tp", "direction" => "descending"}])
        end

        it "create ascending sort (timestamp)" do
          expect(Query.new.descending(letp).sort).to eq([{"timestamp" => "letp", "direction" => "descending"}])
        end
      end
    end

    describe "database_query_string" do
      let(:ep) { Property.create_from_json "ep", tc.read_json("email_property_object"), "database" }

      it { expect(Query.new(filter_properties: ep).database_query_string).to eq("?filter_properties=p%7Ci%3F") }
    end
  end
end

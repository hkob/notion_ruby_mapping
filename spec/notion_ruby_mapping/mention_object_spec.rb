# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe MentionObject do
    tc = TestConnection.instance
    url = "https://www.google.com/"

    subject { target.property_values_json }
    describe "property_values_json" do
      context "mention to user" do
        context "normal" do
          let(:target) { MentionObject.new "user_id" => "ABC", "plain_text" => "@Anonymous" }
          it_behaves_like :property_values_json, {
            "type" => "mention",
            "mention" => {
              "type" => "user",
              "user" => {
                "object" => "user",
                "id" => "ABC",
              },
            },
            "plain_text" => "@Anonymous",
            "href" => nil,
          }
        end

        context "annotations" do
          %w[bold italic strikethrough underline code].each do |an|
            context "annotation #{an}" do
              let(:target) { MentionObject.new "user_id" => "DEF", an => true, "plain_text" => "#{an}_mention" }
              it_behaves_like :property_values_json, {
                "type" => "mention",
                "mention" => {
                  "type" => "user",
                  "user" => {
                    "object" => "user",
                    "id" => "DEF",
                  },
                },
                "annotations" => {
                  an => true,
                },
                "plain_text" => "#{an}_mention",
                "href" => nil,
              }
            end
          end
        end

        context "href" do
          let(:target) { MentionObject.new "user_id" => "GHI", "href" => url, "plain_text" => "href_mention" }
          it_behaves_like :property_values_json, {
            "type" => "mention",
            "mention" => {
              "type" => "user",
              "user" => {
                "object" => "user",
                "id" => "GHI",
              },
            },
            "plain_text" => "href_mention",
            "href" => url,
          }
        end
      end

      describe "create_from_json" do
        let(:target) { RichTextObject.create_from_json tc.read_json("mention_user_object") }
        it_behaves_like :property_values_json, {
          "type" => "mention",
          "mention" => {
            "type" => "user",
            "user" => {
              "object" => "user",
              "id" => "2200a911-6a96-44bb-bd38-6bfb1e01b9f6",
            },
          },
          "annotations" => {
            "bold" => false,
            "italic" => false,
            "strikethrough" => false,
            "underline" => false,
            "code" => false,
            "color" => "default",
          },
          "plain_text" => "@Hiroyuki KOBAYASHI",
          "href" => nil,
        }
      end
    end

    context "mention to page" do
      context "normal" do
        let(:target) { MentionObject.new "page_id" => "ABC", "plain_text" => "@Anonymous" }
        it_behaves_like :property_values_json, {
          "type" => "mention",
          "mention" => {
            "type" => "page",
            "page" => {
              "id" => "ABC",
            },
          },
          "plain_text" => "@Anonymous",
          "href" => nil,
        }
      end

      context "annotations" do
        %w[bold italic strikethrough underline code].each do |an|
          context "annotation #{an}" do
            let(:target) { MentionObject.new "page_id" => "DEF", an => true, "plain_text" => "#{an}_mention" }
            it_behaves_like :property_values_json, {
              "type" => "mention",
              "mention" => {
                "type" => "page",
                "page" => {
                  "id" => "DEF",
                },
              },
              "annotations" => {
                an => true,
              },
              "plain_text" => "#{an}_mention",
              "href" => nil,
            }
          end
        end
      end

      context "href" do
        let(:target) { MentionObject.new "page_id" => "GHI", "href" => url, "plain_text" => "href_mention" }
        it_behaves_like :property_values_json, {
          "type" => "mention",
          "mention" => {
            "type" => "page",
            "page" => {
              "id" => "GHI",
            },
          },
          "plain_text" => "href_mention",
          "href" => url,
        }
      end
    end

    describe "create_from_json" do
      let(:target) { RichTextObject.create_from_json tc.read_json("mention_page_object") }
      it_behaves_like :property_values_json, {
        "type" => "mention",
        "mention" => {
          "type" => "page",
          "page" => {
            "id" => "2200a911-6a96-44bb-bd38-6bfb1e01b9f6",
          },
        },
        "annotations" => {
          "bold" => false,
          "italic" => false,
          "strikethrough" => false,
          "underline" => false,
          "code" => false,
          "color" => "default",
        },
        "plain_text" => "@Anonymous",
        "href" => nil,
      }
    end

    context "mention to date" do
      context "normal" do
        let(:target) { MentionObject.new "database_id" => "ABC", "plain_text" => "@Anonymous" }
        it_behaves_like :property_values_json, {
          "type" => "mention",
          "mention" => {
            "type" => "database",
            "database" => {
              "id" => "ABC",
            },
          },
          "plain_text" => "@Anonymous",
          "href" => nil,
        }
      end

      context "annotations" do
        %w[bold italic strikethrough underline code].each do |an|
          context "annotation #{an}" do
            let(:target) do
              MentionObject.new "database_id" => "DEF", an => true, "plain_text" => "#{an}_mention"
            end
            it_behaves_like :property_values_json, {
              "type" => "mention",
              "mention" => {
                "type" => "database",
                "database" => {
                  "id" => "DEF",
                },
              },
              "annotations" => {
                an => true,
              },
              "plain_text" => "#{an}_mention",
              "href" => nil,
            }
          end
        end
      end

      context "href" do
        let(:target) { MentionObject.new "database_id" => "GHI", "href" => url, "plain_text" => "href_mention" }
        it_behaves_like :property_values_json, {
          "type" => "mention",
          "mention" => {
            "type" => "database",
            "database" => {
              "id" => "GHI",
            },
          },
          "plain_text" => "href_mention",
          "href" => url,
        }
      end
    end

    describe "create_from_json" do
      let(:target) { TextObject.create_from_json tc.read_json("mention_database_object") }
      it_behaves_like :property_values_json, {
        "type" => "mention",
        "mention" => {
          "type" => "database",
          "database" => {
            "id" => "2200a911-6a96-44bb-bd38-6bfb1e01b9f6",
          },
        },
        "annotations" => {
          "bold" => false,
          "italic" => false,
          "strikethrough" => false,
          "underline" => false,
          "code" => false,
          "color" => "default",
        },
        "plain_text" => "@Anonymous",
        "href" => nil,
      }
    end

    context "mention to date" do
      context "start only" do
        let(:target) { MentionObject.new "start" => "2022-02-21", "plain_text" => "2022-02-21 → " }
        it_behaves_like :property_values_json, {
          "type" => "mention",
          "mention" => {
            "type" => "date",
            "date" => {
              "start" => "2022-02-21",
            },
          },
          "plain_text" => "2022-02-21 → ",
          "href" => nil,
        }
      end

      context "start and end" do
        let(:target) do
          MentionObject.new "start" => "2022-02-21", "end" => "2022-02-22", "plain_text" => "2022-02-21 → "
        end
        it_behaves_like :property_values_json, {
          "type" => "mention",
          "mention" => {
            "type" => "date",
            "date" => {
              "start" => "2022-02-21",
              "end" => "2022-02-22",
            },
          },
          "plain_text" => "2022-02-21 → ",
          "href" => nil,
        }
      end

      context "start and time_zone" do
        let(:target) do
          MentionObject.new "start" => "2022-02-22T09:00", "time_zone" => "Asia/Tokyo", "plain_text" => "2022-02-22 → "
        end
        it_behaves_like :property_values_json, {
          "type" => "mention",
          "mention" => {
            "type" => "date",
            "date" => {
              "start" => "2022-02-22T09:00",
              "time_zone" => "Asia/Tokyo",
            },
          },
          "plain_text" => "2022-02-22 → ",
          "href" => nil,
        }
      end

      context "annotations" do
        %w[bold italic strikethrough underline code].each do |an|
          context "annotation #{an}" do
            let(:target) do
              MentionObject.new "start" => "2022-02-21", an => true, "plain_text" => "#{an}_mention"
            end
            it_behaves_like :property_values_json, {
              "type" => "mention",
              "mention" => {
                "type" => "date",
                "date" => {
                  "start" => "2022-02-21",
                },
              },
              "annotations" => {
                an => true,
              },
              "plain_text" => "#{an}_mention",
              "href" => nil,
            }
          end
        end
      end

      context "href" do
        let(:target) do
          MentionObject.new "start" => "2022-02-21", "href" => url, "plain_text" => "href_mention"
        end
        it_behaves_like :property_values_json, {
          "type" => "mention",
          "mention" => {
            "type" => "date",
            "date" => {
              "start" => "2022-02-21",
            },
          },
          "plain_text" => "href_mention",
          "href" => url,
        }
      end
    end

    describe "create_from_json" do
      let(:target) { MentionObject.create_from_json tc.read_json("mention_date_object") }
      it_behaves_like :property_values_json, {
        "type" => "mention",
        "mention" => {
          "type" => "date",
          "date" => {
            "start" => "2022-02-21",
            "end" => nil,
            "time_zone" => nil,
          },
        },
        "annotations" => {
          "bold" => false,
          "italic" => false,
          "strikethrough" => false,
          "underline" => false,
          "code" => false,
          "color" => "default",
        },
        "plain_text" => "2022-02-21 → ",
        "href" => nil,
      }
    end
  end
end

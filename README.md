# NotionRubyMapping

Notion Ruby mapping is currently under development.

Development note is here. → [Idea note of "notion_ruby_mapping"](https://www.notion.so/hkob/Idea-note-of-notion_ruby_mapping-3b0a3bb3c171438a830f9579d41df501)

## Table of Contents
- [NotionRubyMapping](#notionrubymapping)
  - [Installation](#installation)
  - [Example code](#example-code)
  - [Usage](#usage)
    - [Create a New Integration](#create-a-new-integration)
    - [Create client](#create-client)
    - [Classes](#classes)
      - [Base class](#base-class)
      - [Database class](#database-class)
      - [Query class](#query-class)
      - [Page class](#page-class)
      - [List class](#list-class)
      - [Block class](#block-class)
  - [ChangeLog](#changelog)
  - [Contributing](#contributing)
  - [License](#license)
  - [Code of Conduct](#code-of-conduct)
  - [Acknowledgements](#acknowledgements)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'notion_ruby_mapping'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install notion_ruby_mapping

## Example code

The following code sets a "💿" icon on all unset pages in the database.
```Ruby
require "notion_ruby_mapping"

include NotionRubyMapping

token = ENV["NOTION_API_TOKEN"]
database_id = ENV["DATABASE_ID"]

NotionCache.instance.create_client token

Database.query(database_id).each do |page|
  p page.set_icon(emoji: "💿").id unless page.icon
end
```

|Before execution|After execution|
|---|---|
|![Before execution](images/pre_set_icon.png)|![After execution](images/post_set_icon.png)|

The following code sets serial numbers to the pages whose title is not empty in ascending order of titles.
```Ruby
tp = RichTextProperty.new("TextTitle")
Database.query(database_id, tp.filter_is_not_empty.ascending(tp)).each.with_index(1) do |page, index|
  page.properties["NumberTitle"].number = index
  page.update
end
```
| After execution                               |
|-----------------------------------------------|
| ![After exuecution](images/serial_number.png) |

## Usage

### Create a New Integration

Please check [Notion documentation](https://developers.notion.com/docs#getting-started).

### Create client

```Ruby
NotionCache.instance.create_client ENV["NOTION_API_TOKEN"]
```
Please create a client (notion-ruby-client) before you use the following class.

### Classes

#### Base class (Abstract class for Database / Page / Block / List)

- Set icon (only Database / Page)

```Ruby
obj.set_icon emoji: "💿" # set emoji
obj.set_icon url: "https://cdn.profile-image.st-hatena.com/users/hkob/profile.png" # set external url
```

- Get values and properties

```Ruby
obj.icon # obtain icon json
obj["icon"] # same as obj.icon
obj.properties["NumberTitle"]
```

#### Database class

- Retrieve a database
```Ruby
db = Database.find("c37a2c66-e3aa-4a0d-a447-73de3b80c253")
```
- Query a database

Gets a List object of Page objects contained in the database.
You can obtain filtered and ordered pages using Query object.
```Ruby
Database.query("c37a2c66-e3aa-4a0d-a447-73de3b80c253") # retrieves all pages
Database.query("c37a2c66-e3aa-4a0d-a447-73de3b80c253", query) # retrieves using query
```

#### Query class and related *Property class

Query object can be generated from the following Property objects.
For example, in order to obtain the pages whose title starts with "A" and ordered by ascending,
the following code can be used.
```Ruby
tp = TitleProperty.new "Title"
query = tp.filter_starts_with("A").ascending(tp)
pages = Database.query database_id, query
```

The following methods for the Property objects generate a query object.
- TitleProperty, RichTextProperty, UrlProperty, EmailProperty, PhoneNumberProperty
  - filter_equals(value)
  - filter_does_not_equal(value)
  - filter_contains(value)
  - filter_does_not_contain(value)
  - filter_starts_with(value)
  - filter_ends_with(value)
  - filter_is_empty
  - filter_is_not_empty
- NumberProperty
  - filter_equals(value)
  - filter_does_not_equal(value)
  - filter_greater_than(value)
  - filter_less_than(value)
  - filter_greater_than_or_equal_to(value)
  - filter_less_than_or_equal_to(value)
  - filter_is_empty
  - filter_is_not_empty
- CheckboxProperty
  - filter_equals(value)
  - filter_does_not_equal(value)
- SelectProperty
  - filter_equals(value)
  - filter_does_not_equal(value)
  - filter_is_empty
  - filter_is_not_empty
- MultiSelectProperty, PeopleProperty, CreatedByProperty, LastEditedByProperty
  - filter_contains(value)
  - filter_does_not_contain(value)
  - filter_is_empty
  - filter_is_not_empty
- DateProperty, CreatedTimeProperty, LastEditedTimeProperty
  - filter_equals(value(Date / Time / DateTime / String))
  - filter_does_not_equal(value(Date / Time / DateTime / String))
  - filter_before(value(Date / Time / DateTime / String))
  - filter_after(value(Date / Time / DateTime / String))
  - filter_on_or_before(value(Date / Time / DateTime / String))
  - filter_on_or_after(value(Date / Time / DateTime / String))
  - filter_past_week
  - filter_past_month
  - filter_past_year
  - filter_next_week
  - filter_next_month
  - filter_next_year
- FilesProperty
  - filter_is_empty
  - filter_is_not_empty
- FormulaProperty
  - filter_equals(value(Date / Time / DateTime / String))
  - filter_does_not_equal(value(Date / Time / DateTime / String))
  - filter_before(value(Date / Time / DateTime / String))
  - filter_after(value(Date / Time / DateTime / String))
  - filter_on_or_before(value(Date / Time / DateTime / String))
  - filter_on_or_after(value(Date / Time / DateTime / String))
  - filter_past_week
  - filter_past_month
  - filter_past_year
  - filter_next_week
  - filter_next_month
  - filter_next_year
  - filter_contains(value)
  - filter_does_not_contain(value)
  - filter_starts_with(value)
  - filter_ends_with(value)
  - filter_greater_than(value)
  - filter_less_than(value)
  - filter_greater_than_or_equal_to(value)
  - filter_less_than_or_equal_to(value)
  - filter_is_empty
  - filter_is_not_empty

Complex filters can be generated `and` / `or` methods.
```Ruby
# Prepare sample properties
tp = TitleProperty.new "tp"
np = NumberProperty.new "np"
cp = CheckboxProperty.new "cp"
letp = LastEditedTimeProperty.new "letp"
```

- (A and B) filter
```Ruby
query1 = tp.filter_starts_with("start")
           .and(np.filter_greater_than(100))

# Result of query1.filter
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
}
```

- (A and B and C) filter
```Ruby
query2 = tp.filter_starts_with("start")
  .and(np.filter_greater_than(100))
  .and(cp.filter_equals(true))

# Result of query2.filter
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
    {
      "property" => "cp",
      "checkbox" => {"equals" => true},
    },
  ],
}
```

- (A or B) filter
```Ruby
query3 = tp.filter_starts_with("start")
  .or(np.filter_greater_than(100))

# Result of query3.filter
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
}
```

- (A or B or C) filter
```Ruby
query4 = tp.filter_starts_with("start")
      .or(np.filter_greater_than(100))
      .or(cp.filter_equals(true))

# Result of query4.filter
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
    {
      "property" => "cp",
      "checkbox" => {"equals" => true},
    },
  ],
}
```

- ((A and B) or C) filter
```Ruby
query5 = tp.filter_starts_with("start")
  .and(np.filter_greater_than(100))
  .or(cp.filter_equals(true))

# Result of query5.filter
{
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
}
```

- ((A or B) and C) filter
```Ruby
query6 = tp.filter_starts_with("start")
  .or(np.filter_greater_than(100))
  .and(cp.filter_equals(true))

# Result of query6.filter
{
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
}
```

- ((A and B) or (C and D)) filter
```Ruby
query7 = np.filter_greater_than(100).and(np.filter_less_than(200))
      .or(np.filter_greater_than(300).and(np.filter_less_than(400)))

# Result of query7.filter
{
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
}
```

- sort criteria
```Ruby
query8 = Query.new.ascending tp
query9 = Query.new.ascending letp
query10 = Query.new.descending tp
query11 = Query.new.descending letp
query12 = Query.new.ascending(tp).descending letp

# Result of query8.sort
[{"property" => "tp", "direction" => "ascending"}]

# Result of query9.sort
[{"timestamp" => "letp", "direction" => "ascending"}]

# Result of query10.sort
[{"property" => "tp", "direction" => "descending"}]

# Result of query11.sort
[{"timestamp" => "letp", "direction" => "descending"}]

# Result of query12.sort
[
  {"property" => "tp", "direction" => "ascending"},
  {"timestamp" => "letp", "direction" => "descending"},
]
```

- filter with sort
```Ruby
query13 = tp.filter_starts_with("A").ascending(tp)

# Result of query13.filter
{"property" => "tp", "title" => {"starts_with" => "start"}}

# Result of query13.sort
[{"property" => "tp", "direction" => "ascending"}]
```

#### Page class

- Retrieve a page
```Ruby
page = Page.find("c01166c6-13ae-45cb-b968-18b4ef2f5a77")
```

- Update values and properties

Page properties can update in the following three ways.

  1. update the property directory (fastest: one API call only)
```Ruby
page = Page.new id: page_id
np = NumberProperty.new "NumberTitle", number: 3.14
page.add_property_for_update np
page.update # update page API call
print page
```

  2. update the loaded page (easy but slow: two API call)
```Ruby
page = Page.find first_page_id # retrieve page API call
page.properties["NumberTitle"].number = 2022
page.update # update page API call
print page
```

  3. update the unloaded page using autoload (easy but slow: two API call)
```Ruby
page = Page.new id: first_page_id
page.properties["NumberTitle"].number = 12345 # retrieve page API call (autoload)
page.update # update page API call
print page
```

- Retrieve block children (List object)
```Ruby
children = page.children
```

#### List class

- access for each components
```Ruby
list.each do |obj| # obj's class is Page or Block
  # do something
end
```

#### Block class

Not implemented

#### NumberProperty class

- constructor
```Ruby
np = NumberProperty.new "np", number: 123
```

- set value
```Ruby
np.number = 456 # number <- 456 and will_update <- true
```

- create json
```Ruby
np.create_json # {"number" => 456}
```

#### SelectProperty class

- constructor
```Ruby
sp = SelectProperty.new "sp", select: "Select 1"
```

- set value
```Ruby
sp.select = "Select 2" # select <- "Select 2" and will_update <- true
```

- create json
```Ruby
sp.create_json # {"select" => {"name" => "Select 2"}}
```

#### MultiSelectProperty class

- constructor
```Ruby
msp1 = MultiSelectProperty.new "msp1", multi_select: "MS1" # Single value
msp2 = MultiSelectProperty.new "msp2", multi_select: %w[MS1 MS2] # Multi values
```

- set value
```Ruby
msp1.multi_select = %w[MS2 MS1] # multi_select <- ["MS1", "MS2"] and will_update <- true
msp2.select = "MS2" # multi_select <- "MS2" and will_update <- true
```

- create json
```Ruby
msp1.create_json # {"multi_select" => [{"name" => "MS2"}, {"name" => "MS1"}]}
msp2.create_json # {"multi_select" => [{"name" => "MS2"}]}
```

## ChangeLog

- 2022/2/20 add support for MultiSelectProperty
- 2022/2/19 add support for SelectProperty
- 2022/2/17 added Page#properties, Page#add_property_for_update, Page#update
- 2022/2/17 added Page#properties, Page#add_property_for_update, Page#update
- 2022/2/16 added PropertyCache and Payload class
- 2022/2/14 added Database#set_icon
- 2022/2/13 added Page#set_icon
- 2022/2/13 First commit

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hkob/notion_ruby_mapping. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/notion_ruby_mapping/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the NotionRubyMapping project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/notion_ruby_mapping/blob/main/CODE_OF_CONDUCT.md).

## Acknowledgements

The code depends on [notion-ruby-client](https://github.com/orbit-love/notion-ruby-client).
# NotionRubyMapping

Notion Ruby mapping is currently under development.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'notion_ruby_mapping'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install notion_ruby_mapping

## Usage

### Create a New Integration

Please check [Notion documentation](https://developers.notion.com/docs#getting-started).

### Create client

```Ruby
NotionCache.instance.create_client ENV["NOTION_API_TOKEN"]
```
Please create a client (notion-ruby-client) before you use the following class.

### Classes

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

#### Query class

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
  and: [
    {
      property: "tp",
      title: {starts_with: "start"},
    },
    {
      property: "np",
      number: {greater_than: 100},
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
  and: [
    {
      property: "tp",
      title: {starts_with: "start"},
    },
    {
      property: "np",
      number: {greater_than: 100},
    },
    {
      property: "cp",
      checkbox: {equals: true},
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
  or: [
    {
      property: "tp",
      title: {starts_with: "start"},
    },
    {
      property: "np",
      number: {greater_than: 100},
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
  or: [
    {
      property: "tp",
      title: {starts_with: "start"},
    },
    {
      property: "np",
      number: {greater_than: 100},
    },
    {
      property: "cp",
      checkbox: {equals: true},
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
  or: [
    {
      and: [
        {
          property: "tp",
          title: {starts_with: "start"},
        },
        {
          property: "np",
          number: {greater_than: 100},
        },
      ],
    },
    {
      property: "cp",
      checkbox: {equals: true},
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
  and: [
    {
      or: [
        {
          property: "tp",
          title: {starts_with: "start"},
        },
        {
          property: "np",
          number: {greater_than: 100},
        },
      ],
    },
    {
      property: "cp",
      checkbox: {equals: true},
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
  or: [
    {
      and: [
        {
          property: "np",
          number: {greater_than: 100},
        },
        {
          property: "np",
          number: {less_than: 200},
        },
      ],
    },
    {
      and: [
        {
          property: "np",
          number: {greater_than: 300},
        },
        {
          property: "np",
          number: {less_than: 400},
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
[{property: "tp", direction: "ascending"}]

# Result of query9.sort
[{timestamp: "letp", direction: "ascending"}]

# Result of query10.sort
[{property: "tp", direction: "descending"}]

# Result of query11.sort
[{timestamp: "letp", direction: "descending"}]

# Result of query12.sort
[
  {property: "tp", direction: "ascending"},
  {timestamp: "letp", direction: "descending"},
]
```

#### Page class

- Retrieve a page
```Ruby
page = Page.find("c01166c6-13ae-45cb-b968-18b4ef2f5a77")
```

- Retrieve block children (List object)
```Ruby
children = page.children
```

- Set icon

```Ruby
page.set_icon emoji: "💿"
page.set_icon url: "https://cdn.profile-image.st-hatena.com/users/hkob/profile.png"
```

#### List class

- access for each components
```Ruby
list.each do |obj| # obj's class is Page or Block
  # do something
end
```

### Block class

Not implemented

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/notion_ruby_mapping. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/notion_ruby_mapping/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the NotionRubyMapping project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/notion_ruby_mapping/blob/main/CODE_OF_CONDUCT.md).

## Acknowledgements

The code depends on [notion-ruby-client](https://github.com/orbit-love/notion-ruby-client).
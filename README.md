# notion_ruby_mapping

Notion Ruby mapping is currently under development.

Development note is here. → [Idea note of "notion_ruby_mapping"](https://www.notion.so/hkob/Idea-note-of-notion_ruby_mapping-3b0a3bb3c171438a830f9579d41df501)

## Table of Contents

- [notion_ruby_mapping](#notion_ruby_mapping)
  - [Table of Contents](#table-of-contents)
  - [1. Installation](#1-installation)
  - [2. Example code](#2-example-code)
  - [3. Preparation](#3-preparation)
    - [3.1 Create a New Integration](#31-create-a-new-integration)
    - [3.2 Create client](#32-create-client)
  - [4. Usage](#4-usage)
    - [4.1 Page](#41-page)
      - [4.1.1 Retrieve a page](#411-retrieve-a-page)
      - [4.1.2 Update page properties](#412-update-page-properties)
      - [4.1.3 Update other page information](#413-update-other-page-information)
      - [4.1.4 other methods](#414-other-methods)
    - [4.2 Database](#42-database)
      - [4.2.1 Retrieve a database](#421-retrieve-a-database)
      - [4.2.2 Query a database](#422-query-a-database)
        - [4.2.2.1 Complex conditions](#4221-complex-conditions)
        - [4.2.2.2 Sort criteria](#4222-sort-criteria)
        - [4.2.2.3 Dry run sample](#4223-dry-run-sample)
      - [4.2.3 Create child page](#423-create-child-page)
      - [4.2.4 Create database](#424-create-database)
      - [4.2.5 Update database properties](#425-update-database-properties)
      - [4.2.6 Add a database property](#426-add-a-database-property)
      - [4.2.7 Rename a database property](#427-rename-a-database-property)
      - [4.2.8 Remove database properties](#428-remove-database-properties)
      - [4.2.9 other methods](#429-other-methods)
    - [4.3 List class](#43-list-class)
    - [4.4 Block class](#44-block-class)
    - [4.5 Property classes](#45-property-classes)
      - [4.5.1 How to obtain Property object](#451-how-to-obtain-property-object)
      - [4.5.2 Query object generator of property objects](#452-query-object-generator-of-property-objects)
      - [4.5.3 create or update values for Page properties](#453-create-or-update-values-for-page-properties)
        - [4.5.3.1 NumberProperty](#4531-numberproperty)
        - [4.5.3.2 SelectProperty](#4532-selectproperty)
        - [4.5.3.3 MultiSelectProperty](#4533-multiselectproperty)
        - [4.5.3.4 DateProperty](#4534-dateproperty)
        - [4.5.3.4 UrlProperty](#4534-urlproperty)
        - [4.5.3.5 EmailProperty](#4535-emailproperty)
        - [4.5.3.6 PhoneNumberProperty](#4536-phonenumberproperty)
        - [4.5.3.7 PeopleProperty](#4537-peopleproperty)
        - [4.5.3.8 TitleProperty, RichTextProperty](#4538-titleproperty-richtextproperty)
        - [4.5.3.9 CheckboxProperty](#4539-checkboxproperty)
        - [4.5.3.10 FilesProperty](#45310-filesproperty)
        - [4.5.3.11 RelationProperty](#45311-relationproperty)
      - [4.5.4 create or update values for Database properties](#454-create-or-update-values-for-database-properties)
        - [4.5.4.1 NumberProperty](#4541-numberproperty)
        - [4.5.4.2 SelectProperty](#4542-selectproperty)
        - [4.5.4.3 MultiSelectProperty](#4543-multiselectproperty)
        - [4.5.4.4 DateProperty](#4544-dateproperty)
        - [4.5.4.4 UrlProperty](#4544-urlproperty)
        - [4.5.4.5 EmailProperty](#4545-emailproperty)
        - [4.5.4.6 PhoneNumberProperty](#4546-phonenumberproperty)
        - [4.5.4.7 PeopleProperty](#4547-peopleproperty)
        - [4.5.4.8 TitleProperty, RichTextProperty](#4548-titleproperty-richtextproperty)
        - [4.5.4.9 CheckboxProperty](#4549-checkboxproperty)
        - [4.5.4.10 FilesProperty](#45410-filesproperty)
        - [4.5.4.11 RelationProperty](#45411-relationproperty)
        - [4.5.4.12 RollupProperty](#45412-rollupproperty)
  - [5. XXXObjects and RichTextArray](#5-xxxobjects-and-richtextarray)
    - [5.1 RichTextObject](#51-richtextobject)
    - [5.2 TextObject](#52-textobject)
    - [5.3 MentionObject](#53-mentionobject)
    - [5.4 UserObject](#54-userobject)
    - [5.5 RichTextArray](#55-richtextarray)
      - [5.5.1 Constructor for RichTextArray](#551-constructor-for-richtextarray)
      - [5.5.2 Instance methods](#552-instance-methods)
  - [6. ChangeLog](#6-changelog)
  - [7. Contributing](#7-contributing)
  - [8. License](#8-license)
  - [9. Code of Conduct](#9-code-of-conduct)
  - [10. Acknowledgements](#10-acknowledgements)

## 1. Installation

Add this line to your application's Gemfile:

```ruby
gem 'notion_ruby_mapping'
```

And then execute:

```shell
bundle install
```

Or install it yourself as:

```shell
gem install notion_ruby_mapping
```

## 2. Example code

1. [Set icon to all icon unsettled pages](examples/set_icon_to_all_icon_unsettled_pages.md)
1. [Renumbering pages](examples/renumbering_pages.md)
1. [Change title](examples/change_title.md)

## 3. Preparation

### 3.1 Create a New Integration

Please check [Notion documentation](https://developers.notion.com/docs#getting-started).

### 3.2 Create client

Please create a client (notion-ruby-client) before you use the following class.

```Ruby
NotionCache.instance.create_client "Secret_XXXXXXXXXXXXXXXXXXXX" # write directly
NotionCache.instance.create_client ENV["NOTION_API_TOKEN"] # from environment
```

## 4. Usage

From v0.3.0, `find`, `save` and `query_database` methods can set `dry_run: true` option.  When this option is set, these methods create create a shell script for verification instead of calling the Notion API.  Some sample codes show the results of dry_run in order to make it easy to understand what the method runs.

### 4.1 Page

#### 4.1.1 Retrieve a page

`Page.find(id)` creates a Page object with `retrieving page API`.  The created object has page information generated from the JSON response.

```Ruby
page = Page.find "c01166c6-13ae-45cb-b968-18b4ef2f5a77" # Notion API call
```

- result of dry run

```bash
#!/bin/sh
curl  'https://api.notion.com/v1/pages/c01166c6-13ae-45cb-b968-18b4ef2f5a77' \
  -H 'Notion-Version: 2022-02-22' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json'
```

`Page.new(id)` creates a Page object without the Notion API.  Since Page.new does not acquire property information, so you need to assign yourself.

```Ruby
# Assign some properties for update manually
# The argument of assign keyword is Array with the multiple pairs of PropertyClass and Property name
page = Page.new id: "c01166c6-13ae-45cb-b968-18b4ef2f5a77",
                assign: [TitleProperty, "Title", NumberProperty, "NumberTitle"]
```

#### 4.1.2 Update page properties

Page properties with values can be obtained from the retrieved page using `find`.  On the other hand, Page properties without values can be obtained from the property assigned page.

```Ruby
tp = page.properties["Title"] # TitleProperty
np = page.properties["Number"] # NumberProperty
```

Each property object can change values using corresponded methods.  After changing value, `will_update` flag of the property object also set to true.  These methods are explained in the section of each property object class.

```Ruby
to = tp[1] # TitleProperty has Array of TextObject
to.text = "ABC" # TextObject can set text by ".text="
# or tp[1].text = "ABC"

np.number = 3.14159
```

After update some properties, `page.save` method sends `Notion API` and replace the page information using the response of API.

```Ruby
page.save # Notion API call
```

#### 4.1.3 Update other page information

`page.set_icon` can change the page icon using emoji or external url.

[Breaking change on v0.2.2]
`page.set_icon` has no longer calling the Notion API.  Please use `page.save` after `page.set_icon` if you want to update or create the page.

```Ruby
# both methods call Notion API
obj.set_icon emoji: "💿" # set emoji
obj.save

obj.set_icon url: "https://cdn.profile-image.st-hatena.com/users/hkob/profile.png" # set external url
obj.save
```

#### 4.1.4 other methods

- `Page.find id, dry_run: true` create shell script for verification.
- `page.save` call Notion API, and so on and replace object information.
- `page.save dry_run: true` create shell script for verification.
- `page.new_record?` returns true if the page was generated by `create_child_page`.
- `page.title` returns plain_text string of `Title`.
- `page.icon` returns JSON hash for the page icon.
- `page[key]` returns a hash or an array object except "properties".

### 4.2 Database

#### 4.2.1 Retrieve a database

`Database.find(id)` creates a Database object with `retrieving database API`.  The created object has database information generated from the JSON response.

```Ruby
db = Database.find "c37a2c66-e3aa-4a0d-a447-73de3b80c253" # Notion API call
```

```bash
# result of dry run
#!/bin/sh
curl  'https://api.notion.com/v1/databases/c37a2c66-e3aa-4a0d-a447-73de3b80c253'\
  -H 'Notion-Version: 2022-02-22'\
  -H 'Authorization: Bearer '"$NOTION_API_KEY"''\
  -H 'Content-Type: application/json'
```

`Database.new(id)` creates a Database object without the Notion API.  Since Database.new does not acquire property information, so you need to assign yourself.

```Ruby
# assign some properties for update manually
db = Database.new id: "c37a2c66-e3aa-4a0d-a447-73de3b80c253",
                assign: [TitleProperty, "Title", NumberProperty, "NumberTitle"]
```

#### 4.2.2 Query a database

`db.query_database` obtains a List object with Page objects contained in the database.  You can obtain filtered and ordered pages using Query object.

```Ruby
# query_database method calls Notion API
db.query_database # retrieves all pages (no filter, no sort)
db.query_database query # retrieves using query
```

The query object can be generated from the Property objects included in the database object.  The Property object can be obtained from the retrieved or assigned database object like as the Page object.

`filter_xxxx` methods of the property objects generates a query object.  These methods are explained in the section of each property object class.

```Ruby
tp = db.properties["Title"]
query = tp.filter_starts_with("A").ascending(tp)
pages = db.query_database query
```

##### 4.2.2.1 Complex conditions

Complex filters can be generated `and` / `or` methods of the Query object.  Here are some sample scripts and the json parameters created from them.

```Ruby
# Prepare some sample properties
db = Database.new id: "sample database id",
                  assign: [
                    TitleProperty, "tp",
                    NumberProperty, "np",
                    CheckboxProperty, "cp",
                    LastEditedTimeProperty, "letp",
                  ]
properties = db.properties # PropertyCache object
# PropertyCache object can receive [] or values_at methods.
# `values_at` method is useful when retrieving multiple properties at once.
(tp, np, cp, letp) = properties.values_at "tp", "np", "cp", "letp"
```

- query1: (A and B) filter

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

- query2: (A and B and C) filter

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

- query3: (A or B) filter

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

- query4: (A or B or C) filter

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

- query5: ((A and B) or C) filter

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

- query6: ((A or B) and C) filter

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

- query7: ((A and B) or (C and D)) filter

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

##### 4.2.2.2 Sort criteria

Sort criteria can be appended to an existing query object.  If you don't use the previous filters, you can generate by `Query.new`.

- sort criteria only

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

##### 4.2.2.3 Dry run sample

This is a sample script for query database.  If dry_run flag is set, you can see the verification shell script.

```Ruby
db = Database.new id: TestConnection::DATABASE_ID, assign: [NumberProperty, "NumberTitle", UrlProperty, "UrlTitle"]
np, up = target.properties.values_at "NumberTitle", "UrlTitle"
query = np.filter_greater_than(100).and(up.filter_starts_with("https")).ascending(np)
print db.query_database query, dry_run: true
# => Result
# #!/bin/sh
# curl -X POST 'https://api.notion.com/v1/databases/XXXXX/query'\
#   -H 'Notion-Version: 2022-02-22'\
#   -H 'Authorization: Bearer '"$NOTION_API_KEY"''\
#   -H 'Content-Type: application/json'\
#   --data '{"filter":{"and":[{"property":"NumberTitle","number":{"greater_than":100}},{"property":"UrlTitle","url":{"starts_with":"https"}}]},"sorts":[{"property":"NumberTitle","direction":"ascending"}],"page_size":100}'⏎


```

#### 4.2.3 Create child page

`create_child_page` creates a child page object of the database.  After setting some properties, please call `page.save` to send page information to Notion.  Properties of the created child page are automatically assigned using the parent database.  if a block is provided, the method will yield the new Page object and the properties (PropertyCache object) to that block for initialization.

```Ruby
page = db.create_child_page do |p, pp|
  # p is the new Page object
  # pp is the properties of the new Page object (PropertyCache Object)
  p.set_icon emoji: "🎉"
  pp["Name"] << "New Page"
end
page.save
```

- result of dry run

```bash
#!/bin/sh
curl -X POST 'https://api.notion.com/v1/pages'\
  -H 'Notion-Version: 2022-02-22'\
  -H 'Authorization: Bearer '"$NOTION_API_KEY"''\
  -H 'Content-Type: application/json'\
  --data '{"properties":{"Name":{"type":"title","title":[{"type":"text","text":{"content":"New Page","link":null},"plain_text":"New Page","href":null}]}},"parent":{"database_id":"c37a2c66e3aa4a0da44773de3b80c253"}}'⏎
```

#### 4.2.4 Create database

`create_child_database` method of an existing page creates a child database object.  Some properties of the database can be arrange the option.  Here is a sample script for creating a database that set all types of properties.

```Ruby
page = Page.find "a sample page id"
db = parent_page.create_child_database "New database title",
                                       CheckboxProperty, "Checkbox",
                                       CreatedByProperty, "CreatedBy",
                                       CreatedTimeProperty, "CreatedTime",
                                       DateProperty, "Date",
                                       EmailProperty, "Email",
                                       FilesProperty, "Files",
                                       FormulaProperty, "Formula",
                                       LastEditedByProperty, "LastEditedBy",
                                       LastEditedTimeProperty, "LastEditedTime",
                                       MultiSelectProperty, "MultiSelect",
                                       NumberProperty, "Number",
                                       PeopleProperty, "People",
                                       PhoneNumberProperty, "PhoneNumber",
                                       RelationProperty, "Relation",
                                       RollupProperty, "Rollup",
                                       RichTextProperty, "RichText",
                                       SelectProperty, "Select",
                                       TitleProperty, "Title",
                                       UrlProperty, "Url"
fp, msp, np, rp, rup, sp = db.properties.values_at "Formula", "MultiSelect", "Number", "Relation", "Rollup", "Select"
fp.formula_expression = "now()"
msp.add_multi_select_options name: "MS1", color: "orange"
msp.add_multi_select_options name: "MS2", color: "green"
np.format = "yen"
rp.replace_relation_database database_id: TestConnection::DATABASE_ID
rup.relation_property_name = "Relation"
rup.rollup_property_name = "NumberTitle"
rup.function = "sum"
sp.add_select_options name: "S1", color: "yellow"
sp.add_select_options name: "S2", color: "default"
db.set_icon emoji: "🎉"
db.save
```

#### 4.2.5 Update database properties

`save` method updates existing database properties.  The database needs to be retrieved using `find` to prevent existing settings from disappearing.

```Ruby
db = Database.find "c7697137d49f49c2bbcdd6a665c4f921"
fp, msp, np, rp, rup, sp = db.properties.values_at "Formula", "MultiSelect", "Number", "Relation", "Rollup", "Select"
fp.formula_expression = "pi"
msp.add_multi_select_options name: "MS3", color: "blue"
np.format = "percent"
rp.replace_relation_database database_id: TestConnection::DATABASE_ID, synced_property_name: "Renamed table"
rup.function = "average"
sp.add_select_options name: "S3", color: "red"
db.set_icon emoji: "🎉"
db.database_title << "(Added)"
db.save
```

#### 4.2.6 Add a database property

`add_property` can add a database property.

```Ruby
db = Database.find "c7697137d49f49c2bbcdd6a665c4f921"
db.add_property NumberProperty, "added number property" do |np|
  np.format = "euro" # arrange option
end
db.add_property UrlProperty, "added url property" # UrlProperty has no option
db.save
```

- result of dry run

```bash
#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/databases/c7697137d49f49c2bbcdd6a665c4f921'\
  -H 'Notion-Version: 2022-02-22'\
  -H 'Authorization: Bearer '"$NOTION_API_KEY"''\
  -H 'Content-Type: application/json'\
  --data '{"properties":{"added number property":{"number":{"format":"euro"}},"added url property":{"url":{}}}}'⏎
```

#### 4.2.7 Rename a database property

`rename_property` can rename a database property.

```Ruby
properties = db.properties
properties["added number property"].new_name = "renamed number property"
properties["added url property"].new_name = "renamed url property"
db.save
```

- result of dry run

```bash
#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/databases/c7697137d49f49c2bbcdd6a665c4f921'\
  -H 'Notion-Version: 2022-02-22'\
  -H 'Authorization: Bearer '"$NOTION_API_KEY"''\
  -H 'Content-Type: application/json'\
  --data '{"properties":{"added number property":{"name":"renamed number property"},"added url property":{"name":"renamed url property"}}}'
```

#### 4.2.8 Remove database properties

`remove_properties' can remove some database properties.

```Ruby
db.remove_property "renamed number property", "renamed url property"
```

- result of dry run

```bash
#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/databases/c7697137d49f49c2bbcdd6a665c4f921'\
  -H 'Notion-Version: 2022-02-22'\
  -H 'Authorization: Bearer '"$NOTION_API_KEY"''\
  -H 'Content-Type: application/json'\
  --data '{"properties":{"renamed number property":null,"renamed url property":null}}'
```

#### 4.2.9 other methods

- `Database.find id, dry_run: true` create shell script for verification.
- `db.save` call Notion API, and so on and replace object information.
- `db.save dry_run: true` create shell script for verification.
- `db.new_record?` returns true if the database was generated by `create_child_database`.
- `db.database_title` returns plain_text string of `Database`.
- `db.title` returns plain_text string of `TitleProperty`.
- `db.icon` returns JSON hash for the page icon.
- `db[key]` returns a hash or an array object except "properties".
- `db.created_time` returns CreatedTimeProperty for filter
- `db.last_edited_time` returns LastEditedTimeProperty for filter

### 4.3 List class

`db.query_database` and other API list results returns a List object.
The list object is an Enumerable object, so usually combines with `.each` method.

```Ruby
db.query_database(query).each do |page|
  # exec some methods for a page object
end
```

Notion API returns only the first page-size objects.
The default page-size of this library is 100.
Since the above `.each` method is supported for paging, it will automatically execute API call that obtain the following 100 objects when you used the first 100 objects.
Users do not have to worry about paging.

### 4.4 Block class

=== under construction ===

### 4.5 Property classes

#### 4.5.1 How to obtain Property object

There are the following 17 XXXProperty classes corresponding to Notion databases.

1. TitleProperty
2. RichTextProperty
3. UrlProperty
4. EmailProperty
5. PhoneNumberProperty
6. NumberProperty
7. CheckboxProperty
8. SelectProperty
9. MultiSelectProperty
10. PeopleProperty
11. CreatedByProperty
12. LastEditedByProperty
13. DateProperty
14. CreatedTimeProperty
15. LastEditedTimeProperty
16. FilesProperty
17. FormulaProperty

They are child classes of a `Property` class and generated from Page or Database objects.

```Ruby
page = Page.new page_id, assign: [XXXProperty, "property_name"]
# or
page = Page.find page_id

xp = page.properties["property_name"]
# or
xp, yp = page.properties.values_at "xp_name", "yp_name"
```

Page properties and database properties are objects of the same class, but there are methods for page properties and methods for database properties.

#### 4.5.2 Query object generator of property objects

The following methods for the Property objects generate a query object.  These methods can be used for page properties and database properties.

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

#### 4.5.3 create or update values for Page properties

Retrieving Page object with `find` method has page properties of XXXProperties with values.  On the other hand, Assigned Page object has also XXXProperties, but they don't have any information for pages.

XXXProperties can change property values by setter methods.  Since the setter method is different for each class, it will be explained separately.

##### 4.5.3.1 NumberProperty

NumberProperty can set a number by `.number=`.

```Ruby
np = page.properties["NumberTitle"]
np.number = 3.14
p np.property_values_json
# Result => => {"np"=>{"number"=>3.14, "type"=>"number"}}
```

##### 4.5.3.2 SelectProperty

SelectProperty can set a select name by `.select=`.

```Ruby
sp = page.properties["SelectTitle"]
sp.select = "Select 2"
p sp.property_values_json
# Result => {"sp"=>{"type"=>"select", "select"=>{"name"=>"Select 2"}}}
```

##### 4.5.3.3 MultiSelectProperty

MultiSelectProperty can set a select value or Array of select values by `.multi_select=`.

```Ruby
msp = page.properties["MultiSelectTitle"]
msp.multi_select = "MS2"
p msp.property_values_json
# Result => {"msp"=>{"type"=>"multi_select", "multi_select"=>[{"name"=>"MS2"}]}}

msp.multi_select = %w[MS2 MS1]
p msp.property_values_json
# Result => {"msp"=>{"type"=>"multi_select", "multi_select"=>[{"name"=>"MS2"}, {"name"=>"MS1"}]}}
```

##### 4.5.3.4 DateProperty

DateProperty can set a start_date or end_date by `.start_date=` or `end_date=`.
Date, Time, DateTime or String object can be used to the argument.

```Ruby
dp = page.properties["DateTitle"]
dp.start_date = Date.new(2022, 2, 22)
p dp.property_values_json
# Result => {"dp"=>{"type"=>"date", "date"=>{"start"=>"2022-02-22", "end"=>nil, "time_zone"=>nil}}}

dp.start_date = Time.new(2022, 2, 22, 1, 23, 45, "+09:00")
p dp.property_values_json
# Result =>{"dp"=>{"type"=>"date", "date"=>{"start"=>"2022-02-22T01:23:45+09:00", "end"=>nil, "time_zone"=>nil}}}

dp.start_date = DateTime.new(2022, 2, 23, 1, 23, 45, "+09:00")
p dp.property_values_json
# Result => {"dp"=>{"type"=>"date", "date"=>{"start"=>"2022-02-23T01:23:45+09:00", "end"=>nil, "time_zone"=>nil}}}

dp.start_date = Date.new(2022, 2, 20)
dp.end_date = Date.new(2022, 2, 22)
p dp.property_values_json
# Result => => {"dp"=>{"type"=>"date", "date"=>{"start"=>"2022-02-20", "end"=>"2022-02-22", "time_zone"=>nil}}}

dp.start_date = Time.new(2022, 2, 21, 1, 23, 45, "+09:00")
dp.end_date = Time.new(2022, 2, 22, 1, 23, 45, "+09:00")
p dp.property_values_json
# Result => {"start" => "2022-02-21T01:23:45+09:00", "end" => "2022-02-22T01:23:45+09:00"}

dp.start_date = DateTime.new(2022, 2, 21, 1, 23, 45, "+09:00")
dp.end_date = DateTime.new(2022, 2, 22, 1, 23, 45, "+09:00")
p dp.property_values_json
# result => {"dp"=>{"type"=>"date", "date"=>{"start"=>"2022-02-21T01:23:45+09:00", "end"=>nil, "time_zone"=>nil}}}
```

##### 4.5.3.4 UrlProperty

UrlProperty can set a url by `.url=`.

```Ruby
up = page.properties["UrlTitle"]
up.url = "https://www.google.com/"
p up.property_values_json
# result => {"up"=>{"url"=>"https://www.google.com/", "type"=>"url"}}
```

##### 4.5.3.5 EmailProperty

EmailProperty can set an email by `.email=`.

```Ruby
ep = page.properties["MailTitle"]
ep.email = "https://www.google.com/"
p ep.property_values_json
# result => {"ep"=>{"email"=>"hkobhkob@gmail.com", "type"=>"email"}}
```

##### 4.5.3.6 PhoneNumberProperty

PhoneNumberProperty can set an phone number by `.phone_number=`.

```Ruby
pp = page.properties["TelTitle"]
pp.phone_number = "xx-xxxx-xxxx"
p pp.property_values_json
# result => {"pp"=>{"phone_number"=>"xx-xxxx-xxxx", "type"=>"phone_number"}}
```

##### 4.5.3.7 PeopleProperty

PeopleProperty can set an people by `.people=`.
PeopleProperty can set a user_id/UserObject value or Array of user_id/UserObject values by `.people=`.

```Ruby
pp = page.properties["UserTitle"]
pp.people = "user_id1"
p pp.property_values_json
# result => {"pp"=>{"type"=>"people", "people"=>[{"object"=>"user", "id"=>"user_id1"}]}}

pp.people = UserObject.new json: user1_json
p pp.property_values_json
# result => {"pp"=>{"type"=>"people", "people"=>[{"object"=>"user", "id"=>"user_id1_from_json"}]}}
```

```Ruby
pp.people = %w[user_id2 user_id3]
p pp.property_values_json
# result => {"pp"=>{"type"=>"people", "people"=>[{"object"=>"user", "id"=>"user_id2"}, {"object"=>"user", "id"=>"user_id3"}]}}

u2 = UserObject.new(json: user2_json)
u3 = UserObject.new(json: user3_json)
pp.people = [u2, u3]
p pp.property_values_json
# result => {"pp"=>{"type"=>"people", "people"=>[{"object"=>"user", "id"=>"user_id2_from_json"}, {"object"=>"user", "id"=>"user_id3_from_json"}]}}
```

##### 4.5.3.8 TitleProperty, RichTextProperty

TextProperty's subclasses (TitleProperty, RichTextProperty) have an array of TextObject objects.
`[]` method returns an existing TextObject.
The obtained TextObject can be set text by `.text=`.

```Ruby
pp = page.properties["Title"]
tp[0].text = "ABC\n"
p tp.property_values_json
# result => {"tp"=>{"type"=>"title", "title"=>[{"type"=>"text", "text"=>{"content"=>"ABC\n", "link"=>nil}, "plain_text"=>"ABC\n", "href"=>nil}]}}
```

`<<` method appends a new TextObject or a String.

```Ruby
to = TextObject.new "DEF"
to.bold = true
to.italic = true
to.strikethrough = true
to.underline = true
to.code = true
to.color = "default"
tp << to
p tp.property_values_json
# result => {"tp"=>{"type"=>"title","title"=>[{"type"=>"text","text"=>{"content"=>"ABC\n","link"=>nil},"plain_text"=>"ABC\n","href"=>nil},{"type"=>"text","text"=>{"content"=>"DEF","link"=>nil},"plain_text"=>"DEF","href"=>nil,"annotations"=>{"bold"=>true,"italic"=>true,"strikethrough"=>true,"underline"=>true,"code"=>true,"color"=>"default"}}]}}
```

`delete_at(index)` method remove a TextObject at index.

```Ruby
tp.delete_at 1
tp << "GHI"
p tp.property_values_json
# result => {"tp"=>{"type"=>"title", "title"=>[{"type"=>"text", "text"=>{"content"=>"ABC\n", "link"=>nil}, "plain_text"=>"ABC\n", "href"=>nil}, {"type"=>"text", "text"=>{"content"=>"DEF", "link"=>nil}, "plain_text"=>"DEF", "href"=>nil, "annotations"=>{"bold"=>true, "italic"=>true, "strikethrough"=>true, "underline"=>true, "code"=>true, "color"=>"default"}}, {"type"=>"text", "text"=>{"content"=>"GHI", "link"=>nil}, "plain_text"=>"GHI", "href"=>nil}]}}
```

##### 4.5.3.9 CheckboxProperty

CheckboxProperty can set a boolean value by `.checkbox=`.

```Ruby
cp = page.properties["CheckboxTitle"]
cp.checkbox = true
p cp.property_values_json
# result => {"cp"=>{"checkbox"=>true, "type"=>"checkbox"}}
```

##### 4.5.3.10 FilesProperty

FilesProperty can set an external url or Array of external urls by `.files=`.

```Ruby
fp = page.properties["FilesTitle"]
fp.files = "F1"
p fp.property_values_json
# Result => {"fp"=>{"files"=>[{"name"=>"F1", "type"=>"external", "external"=>{"url"=>"F1"}}], "type"=>"files"}}

fp.files = %w[F2 F3]
p fp.property_values_json
# Result => {"fp"=>{"files"=>[{"name"=>"F2", "type"=>"external", "external"=>{"url"=>"F2"}}, {"name"=>"F3", "type"=>"external", "external"=>{"url"=>"F3"}}], "type"=>"files"}}
```

##### 4.5.3.11 RelationProperty

RelationProperty can set an relation's page_id or Array of relation's page_ids by `.relation=`.

```Ruby
rp = page.properties["RelationTitle"]
rp.relation = "R1"
p rp.property_values_json
# Result => {"rp"=>{"type"=>"relation", "relation"=>[{"id"=>"R1"}]}}

rp.relation = %w[R2 R3]
p rp.property_values_json
# Result => {"rp"=>{"type"=>"relation", "relation"=>[{"id"=>"R2"}, {"id"=>"R3"}]}}
```

#### 4.5.4 create or update values for Database properties

Retrieving Database object with `find` method has database properties of XXXProperties with values.  On the other hand, Assigned Database object has also XXXProperties, but they don't have any information for databases.

XXXProperties can change property values by setter methods.  Since the setter method is different for each class, it will be explained separately.

##### 4.5.4.1 NumberProperty

NumberProperty can set a format by `.format=`.

```Ruby
np = db.properties["NumberTitle"]
np.format = "percent"
print np.property_schema_json
# Result => {"NumberTitle"=>{"number"=>{"format"=>"percent"}}}
```

##### 4.5.4.2 SelectProperty

SelectProperty can add a new option by `.add_select_options`.

```Ruby
sp = db.properties["SelectTitle"]
sp.add_select_options name: "S3", color: "red"
print sp.property_schema_json
# Result => {"Select"=>{"select"=>{"options"=>[{"id"=>"56a526e1-0cec-4b85-b9db-fc68d00e50c6", "name"=>"S1", "color"=>"yellow"}, {"id"=>"6ead7aee-d7f0-40ba-aa5e-59bccf6c50c8", "name"=>"S2", "color"=>"default"}, {"name"=>"S3", "color"=>"red"}]}}}
```

If you want to edit existing values, you should access `edit_select_options` array.  It sets `will_update` flag to true.

```Ruby
sp.edit_select_options[0]["name"] = "new S1"
p sp.property_values_json
# Result => {"Select"=>{"select"=>{"options"=>[{"id"=>"56a526e1-0cec-4b85-b9db-fc68d00e50c6", "name"=>"new S1", "color"=>"yellow"}, {"id"=>"6ead7aee-d7f0-40ba-aa5e-59bccf6c50c8", "name"=>"S2", "color"=>"default"}]}}}⏎
```

##### 4.5.4.3 MultiSelectProperty

MultiSelectProperty can add a new option by `.add_multi_select_options`.

```Ruby
msp = db.properties["MultiSelectTitle"]
msp.add_multi_select_options name: "MS3", color: "blue"
print msp.property_schema_json
# Result => {"MultiSelectTitle"=>{"multi_select"=>{"options"=>[{"id"=>"98aaa1c0-4634-47e2-bfae-d739a8c5e564", "name"=>"MS1", "color"=>"orange"}, {"id"=>"71756a93-cfd8-4675-b508-facb1c31af2c", "name"=>"MS2", "color"=>"green"}, {"name"=>"MS3", "color"=>"blue"}]}}}
```

If you want to edit existing values, you should access `edit_multi_select_options` array.  It sets `will_update` flag to true.

```Ruby
msp.edit_multi_select_options[0]["name"] = "new MS1"
p msp.property_values_json
# Result => {"MultiSelectTitle"=>{"multi_select"=>{"options"=>[{"id"=>"98aaa1c0-4634-47e2-bfae-d739a8c5e564", "name"=>"new MS1", "color"=>"orange"}, {"id"=>"71756a93-cfd8-4675-b508-facb1c31af2c", "name"=>"MS2", "color"=>"green"}]}}}⏎
```

##### 4.5.4.4 DateProperty

DateProperty has no option.

```Ruby
dp = db.properties["DateTitle"]
print dp.property_schema_json
# Result => {"DateTitle"=>{"date"=>{}}}
```

##### 4.5.4.4 UrlProperty

UrlProperty has no option.

```Ruby
up = db.properties["UrlTitle"]
print up.property_schema_json
# Result => {"UrlTitle"=>{"url"=>{}}}
```

##### 4.5.4.5 EmailProperty

EmailProperty has no option.

```Ruby
ep = db.properties["MailTitle"]
print ep.property_schema_json
# Result => {"MailTitle"=>{"email"=>{}}}
```

##### 4.5.4.6 PhoneNumberProperty

PhoneNumberProperty has no option.

```Ruby
pp = db.properties["TelTitle"]
print ep.property_schema_json
# Result => {"TelTitle"=>{"phone_number"=>{}}}
```

##### 4.5.4.7 PeopleProperty

PeopleProperty has no option.

```Ruby
usp = db.properties["UserTitle"]
print usp.property_schema_json
# Result => {"UserTitle"=>{"people"=>{}}}
```

##### 4.5.4.8 TitleProperty, RichTextProperty

TitleProperty and RichTextProperty have no option.

```Ruby
tp, rtp = db.properties.values_at "Title", "TextTitle"
print tp.property_schema_json
# Result => {"Title"=>{"title"=>{}}}
print rtp.property_schema_json
# Result => {"TextTitle"=>{"rich_text"=>{}}}
```

##### 4.5.4.9 CheckboxProperty

CheckboxProperty has no option.

```Ruby
cp = db.properties["CheckboxTitle"]
print cp.property_schema_json
# Result => {"CheckboxTitle"=>{"checkbox"=>{}}}
```

##### 4.5.4.10 FilesProperty

FilesProperty has no option.

```Ruby
fp = db.properties["FilesTitle"]
print fp.property_schema_json
# Result => {"FilesTitle"=>{"files"=>{}}}
```

##### 4.5.4.11 RelationProperty

RelationProperty can set an relation's database_id by `.replace_relation_database`.

```Ruby
rp = db.properties["RelationTitle"]
rp.replace_relation_database database_id: "new database id"
p rp.property_values_json
# Result => {"Relation"=>{"relation"=>{"database_id"=>"new database id"}}}
```

##### 4.5.4.12 RollupProperty

RollupProperty can set rollup property name, relation property name and function by `.rollup_property_name=`, `relation_property_name=` and `function=`, respectively.

```Ruby
rup = db.properties["RollupTitle"]
rup.relation_property_name = "new relation property name"
rup.rollup_property_name = "new rollup property name"
rup.function = "average"
# Result => {"Rollup"=>{"rollup"=>{"function"=>"average", "relation_property_name"=>"new relation property name", "rollup_property_name"=>"new rollup property name"}}}
```

## 5. XXXObjects and RichTextArray

### 5.1 RichTextObject

RichTextObject is an abstract class for TextObject and MentionObject.
It can store a link and some annotations.

There are common instance methods for its subclass objects.

- plain_text=(value)
- bold=(flag)
- italic=(flag)
- strikethrough=(flag)
- underline=(flag)
- code=(flag)
- color=(color)

### 5.2 TextObject

TextObject is a class for texts.
`TextObject.new(text)` creates a TextObject.
After creating or retrieving TextObject, `to.text=` replaces including text.

```Ruby
to = TextObject.new "first text"
to.text = "replaced text"
```

### 5.3 MentionObject

MentionObject is a class for mentions for user, page, database, date and template_mention.

```Ruby
mention_user = MentionObject.new user_id: "user_id", plain_text: "m_user"
mention_page = MentionObject.new page_id: "page_id", plain_text: "m_page"
mention_db = MentionObject.new database_id: "database_id", plain_text: "m_db"
mention_date = MentionObject.new start: "2022-03-17", plain_text: "m_date"
mention_today = MentionObject.new mention_template: "today"
mention_now = MentionObject.new mention_template: "now"
mention_user = MentionObject.new mention_template: "user"
```

### 5.4 UserObject

UserObject is a class for users.

```Ruby
u = User.new id: "user_id"
```

### 5.5 RichTextArray

Some properties and Database title have an array of RichTextObject.  `RichTextArray` is the delegate class for the array of RichTextObject.
Moreover, some methods of TitleProperty, RichTextProperty and Database.title delegate to the included RichTextArray.

#### 5.5.1 Constructor for RichTextArray

RichTextArray can be created by a String, some Strings, a RichTextObject and some RichTextObjects.  String values will convert to simple TextObjects.

```Ruby
nullString = RichTextArray.new "title"
aString = RichTextArray.new "title", text_objects: "A string"
twoStrings = RichTextArray.new "title", text_objects: %W[ABC\n DEF]
aTextObject = RichTextArray.new "title", text_objects: TextObject.new "A TextObject"
textMentionObjects = RichTextArray.new "title", [TextObject.new("A TextObject"), MentionObject.new(user_id: "ABC")]
```

#### 5.5.2 Instance methods

- `rto << text_or_text_object`: append a text or RichTextObject
- `rto[0]`: obtain the object specified by the index
- `delete_at 0`: obtain the object specified by the index and delete from the array
- `full_text`: obtain joined plain text

## 6. ChangeLog

- 2022/3/27 create_child_page can receive a block for initialization.
- 2022/3/27 properties of a created child page are automatically assigned using the parent database.
- 2022/3/25 added create_child_database, update_database, add_property, rename_property and remove_property
- 2022/3/17 added template_mention objects, tools/an command
- 2022/3/16 added database.create_child_page and base.save instead of base.update/create
- 2022/3/15 Fixed not to reload from API when all contents are loaded
- 2022/3/14 Exclude notion-ruby-client, update Property values, update for Notion-Version 2022-02-22
- 2022/2/25 add_property_for_update -> assign_property, update README.md
- 2022/2/20 add support for MultiSelectProperty
- 2022/2/19 add support for SelectProperty
- 2022/2/17 added Page#properties, Page#add_property_for_update, Page#update
- 2022/2/17 added Page#properties, Page#add_property_for_update, Page#update
- 2022/2/16 added PropertyCache and Payload class
- 2022/2/14 added Database#set_icon
- 2022/2/13 added Page#set_icon
- 2022/2/13 First commit

## 7. Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/hkob/notion_ruby_mapping>. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/notion_ruby_mapping/blob/main/CODE_OF_CONDUCT.md).

## 8. License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## 9. Code of Conduct

Everyone interacting in the NotionRubyMapping project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/notion_ruby_mapping/blob/main/CODE_OF_CONDUCT.md).

## 10. Acknowledgements

The code depends on [notion-ruby-client](https://github.com/orbit-love/notion-ruby-client).

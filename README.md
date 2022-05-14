# notion_ruby_mapping

Notion Ruby mapping is currently under development.

Development note is here. → [Idea note of "notion_ruby_mapping"](https://www.notion.so/hkob/Idea-note-of-notion_ruby_mapping-3b0a3bb3c171438a830f9579d41df501)

## Table of Contents

- [notion_ruby_mapping](#notion_ruby_mapping)
  - [Table of Contents](#table-of-contents)
  - [1. Installation](#1-installation)
  - [2. How to use](#2-how-to-use)
    - [2.1 Create a New Integration](#21-create-a-new-integration)
    - [2.2 Create client](#22-create-client)
    - [2.3 Sample codes](#23-sample-codes)
    - [2.4. Another example code (Use case)](#24-another-example-code-use-case)
    - [2.5 API reference](#25-api-reference)
  - [3. ChangeLog](#3-changelog)
  - [4. Contributing](#4-contributing)
  - [5. License](#5-license)
  - [6. Code of Conduct](#6-code-of-conduct)
  - [7. Acknowledgements](#7-acknowledgements)

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

## 2. How to use

### 2.1 Create a New Integration

Please check [Notion documentation](https://developers.notion.com/docs#getting-started).

### 2.2 Create client

Please create a client (notion-ruby-client) before you use the following class.

```Ruby
NotionCache.instance.create_client "secret_XXXXXXXXXXXXXXXXXXXX" # write directly
NotionCache.instance.create_client ENV["NOTION_API_TOKEN"] # from environment
```

### 2.3 Sample codes

1. [Database and page access sample](https://www.notion.so/hkob/Database-and-page-access-sample-d30033e707194faf995741167eb2b6f8)
1. [Append block children sample](https://www.notion.so/hkob/Append-block-children-sample-3867910a437340be931cf7f2c06443c6)

### 2.4. Another example code (Use case)

1. [Set icon to all icon unsettled pages](examples/set_icon_to_all_icon_unsettled_pages.md)
1. [Renumbering pages](examples/renumbering_pages.md)
1. [Change title](examples/change_title.md)

### 2.5 API reference

1. [Notion Ruby Mapping Public API reference](https://www.notion.so/hkob/Notion-Ruby-Mapping-Public-API-reference-4091aca15b664299b63e6253b7601fec)

## 3. ChangeLog

- added append_block_children
- added retrieve_block spec
- 2022/4/29 Change directory structure, TEST_IDs are moved from env.yml to TestConnection's constants
- 2022/4/27 added Base#children
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

## 4. Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/hkob/notion_ruby_mapping>. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/notion_ruby_mapping/blob/main/CODE_OF_CONDUCT.md).

## 5. License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## 6. Code of Conduct

Everyone interacting in the NotionRubyMapping project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/notion_ruby_mapping/blob/main/CODE_OF_CONDUCT.md).

## 7. Acknowledgements

The code depends on [notion-ruby-client](https://github.com/orbit-love/notion-ruby-client).

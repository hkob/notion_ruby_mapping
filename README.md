# notion_ruby_mapping

Notion Ruby Mapping is a library that makes it easy to access data on Notion using Ruby.  It is currently under development.

Notion Ruby Mapping は Ruby で Notion 上のデータを簡単にアクセスできるようにするライブラリです。現在開発中です。

Development note is here.

開発ノートは以下の URL にあります。

→ [Idea note of "notion_ruby_mapping"](https://www.notion.so/hkob/Idea-note-of-notion_ruby_mapping-3b0a3bb3c171438a830f9579d41df501)

## Table of Contents

- [notion\_ruby\_mapping](#notion_ruby_mapping)
  - [Table of Contents](#table-of-contents)
  - [0. History of Major Changes / 主な変更履歴](#0-history-of-major-changes--主な変更履歴)
    - [0.1 Changes in v0.7.0](#01-changes-in-v070)
    - [0.2 Changes in v0.6.0](#02-changes-in-v060)
    - [0.3 Changes in v0.5.0](#03-changes-in-v050)
  - [1. Installation / インストール方法](#1-installation--インストール方法)
  - [2. How to use / 利用方法](#2-how-to-use--利用方法)
    - [2.1 Create a New Integration / インテグレーションの作成](#21-create-a-new-integration--インテグレーションの作成)
    - [2.2 Set your integration token / インテグレーショントークンの設定](#22-set-your-integration-token--インテグレーショントークンの設定)
    - [2.3 Sample codes / サンプルコード](#23-sample-codes--サンプルコード)
    - [2.4. Another example code (Use case) / その他の使用例 (ユースケース)](#24-another-example-code-use-case--その他の使用例-ユースケース)
    - [2.5 API reference / API リファレンス](#25-api-reference--api-リファレンス)
  - [3. ChangeLog](#3-changelog)
  - [4. Contributing / 貢献](#4-contributing--貢献)
  - [5. License / ライセンス](#5-license--ライセンス)
  - [6. Code of Conduct / 行動規範](#6-code-of-conduct--行動規範)

## 0. History of Major Changes / 主な変更履歴

### 0.1 Changes in v0.7.0

Since the number of Japanese users has increased, we decided to include Japanese as well.  In addition, we have simplified the method of setting up integration tokens.

日本のユーザが増えたので、日本語も併記することにしました。また、インテグレーショントークンの設定方法を簡単にしました。

### 0.2 Changes in v0.6.0

NotionRubyMapping v0.6.0 now supports Notion-Version 2022-06-28.
~~In 2022-06-28, property values are no longer returned when retrieving pages.  NotionRubyMapping temporarily creates a Property Object and calls the retrieve a property item API when a value is needed.  Therefore, users do not need to be aware of any differences, and existing scripts should work as they are.~~

NotionRubyMapping v0.6.0 は、Notion-Version 2022-06-28 に対応しました。
~~ 2022-06-28 では、ページを取得する際にプロパティ値を返さなくなりました。NotionRubyMapping は、一時的に Property Object を作成し、値が必要なときにプロパティ項目を取得する API を呼び出します。そのため、ユーザーはこの違いを意識する必要はなく、既存のスクリプトはそのまま動作するはずです。~~

### 0.3 Changes in v0.5.0

NotionRubyMapping v0.5.0 now supports block updates.
For efficiency, subclasses are provided under Block class. As a result, they are no longer compatible with the scripts used in v0.4.0.

NotionRubyMapping v0.5.0 では、ブロック更新をサポートするようになりました。
効率化のため、Blockクラスの下にサブクラスが提供されています。そのため、v0.4.0で使用していたスクリプトとは互換性がなくなりました。

## 1. Installation / インストール方法

Add this line to your application's Gemfile:

アプリケーションのGemfileに次の行を追加します。:

```ruby
gem 'notion_ruby_mapping'
```

And then execute:

そして以下を実行してください:

```shell
bundle install
```

Or install it yourself as:

または、自分でインストールすることもできます。:

```shell
gem install notion_ruby_mapping
```

## 2. How to use / 利用方法

### 2.1 Create a New Integration / インテグレーションの作成

Please check [Notion documentation](https://developers.notion.com/docs#getting-started).

[Notion documentation](https://developers.notion.com/docs#getting-started) を読んでください。

### 2.2 Set your integration token / インテグレーショントークンの設定

From v0.7.0, it can be set with `NotionRubymapping.configuration`.

v0.7.0 から `NotionRubyMapping.configuration` で設定できるようになりました。

```ruby
NotionRubyMapping.configuration do |config|
    config.notion_token = "secret_XXXXXXXXXXXXXXXXXXXX" # write directly
    config.wait = 0
end
```

```ruby
NotionRubyMapping.configuration { |c| c.notion_token = ENV["NOTION_API_TOKEN"] } # from environment
```

### 2.3 Sample codes / サンプルコード

1. [Database and page access sample / データベースとページのアクセスサンプル](https://www.notion.so/hkob/Database-and-page-access-sample-d30033e707194faf995741167eb2b6f8)
2. [Append block children sample / 子ブロック要素の追加サンプル](https://www.notion.so/hkob/Append-block-children-sample-3867910a437340be931cf7f2c06443c6)
3. [Update block sample / ブロック要素の更新サンプル](https://www.notion.so/hkob/update-block-sample-5568c1c36fe84f12b83edfe2dda83028)

### 2.4. Another example code (Use case) / その他の使用例 (ユースケース)

1. [Set icon to all icon unsettled pages / 全てのページのアイコンを同一に設定](examples/set_icon_to_all_icon_unsettled_pages.md)
2. [Renumbering pages / ページのナンバリング](examples/renumbering_pages.md)
3. [Change title / タイトルの変更](examples/change_title.md)
4. [Create ER Diagram from Notion database / Notion データベースの ER 図を作成](https://www.notion.so/hkob/notionErDiagram-Sample-1720c2199c534ca08138cde38f31f710)
5. [Create Sitemap from Notion pages / Notion page からサイトマップを作成](https://www.notion.so/hkob/NotionSitemap-sample-14e195c83d024c5382aab09210916c87)

### 2.5 API reference / API リファレンス

1. [Notion Ruby Mapping Public API reference](https://www.notion.so/hkob/Notion-Ruby-Mapping-Public-API-reference-4091aca15b664299b63e6253b7601fec)

## 3. ChangeLog

- 2023/1/25 [v0.7.2] bug fix for creating relation property / add erdToNotionRb.rb script
- 2022/12/16 [v0.7.1] bug fix for query rollup property
- 2022/11/28 [v0.7.0] add this_week filter and NotionRubyMapping.configure
- 2022/11/13 [v0.6.8] remove error checking for start and end dates, add Users.all, and change Rollup and Formula query specification
- 2022/9/2 [v0.6.7] add support for Status property, is_toggleable for headings block, and page property values
- 2022/8/10 [v0.6.6] Bug fix(notionSitemap.rb): Skip if child page is empty.
- 2022/8/10 [v0.6.5] add notionSitemap.rb, rename createErDiagram to notionErDiagram, and move them to exe directory
- 2022/8/9 [v0.6.4] url can be entered instead of page_id, block_id and database_id
- 2022/8/9 [v0.6.3] update createErDiagram.rb (Fixed a bug with non-ASCII database titles)
- 2022/8/7 [v0.6.2] add comment_object support
- 2022/7/28 [v0.6.1] added createErDiagram.rb
- 2022/7/22 [v0.6.0] updates for Notion-Version 2022-06-28 (lazy retrieve property values, retrieve page/database/block parent, single_property/dual_property for RelationProperty)
- 2022/6/24 [v0.5.5] add file_names= to FileProperty
- 2022/6/23 [v0.5.4] add update 'is_inline' and 'description' for database object
- 2022/6/14 [v0.5.3] add time zone for query database by Date (before, after, on_or_before, on_or_after)
- 2022/6/8 [v0.5.2] Change query database filter for date with time zone
- 2022/6/5 [v0.5.1] bug fix for append_block_children.  added synced_block_original to SyncedBlock
- 2022/6/4 [v0.5.0]  added subclasses of the block class and update_block API support
- 2022/5/19 [v0.4.1] added delete_block
- 2022/4/29 [v0.4.0] Change directory structure, TEST_IDs are moved from env.yml to TestConnection's constants, added retrieve_block spec, added append_block_children
- 2022/4/27 added Base#children
- 2022/3/27 [v0.3.3] create_child_page can receive a block for initialization.
- 2022/3/27 [v0.3.2] properties of a created child page are automatically assigned using the parent database.
- 2022/3/25 [v0.3.0] added create_child_database, update_database, add_property, rename_property and remove_property
- 2022/3/17 [v0.2.3] added template_mention objects, tools/an command
- 2022/3/16 [v0.2.2] added database.create_child_page and base.save instead of base.update/create
- 2022/3/15 Fixed not to reload from API when all contents are loaded
- 2022/3/14 [v0.2.0] Exclude notion-ruby-client, update Property values, update for Notion-Version 2022-02-22
- 2022/2/25 add_property_for_update -> assign_property, update README.md
- 2022/2/20 add support for MultiSelectProperty
- 2022/2/19 add support for SelectProperty
- 2022/2/17 added Page#properties, Page#add_property_for_update, Page#update
- 2022/2/17 added Page#properties, Page#add_property_for_update, Page#update
- 2022/2/16 added PropertyCache and Payload class
- 2022/2/14 added Database#set_icon
- 2022/2/13 added Page#set_icon
- 2022/2/13 First commit

## 4. Contributing / 貢献

Bug reports and pull requests are welcome on GitHub at <https://github.com/hkob/notion_ruby_mapping>. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/hkob/notion_ruby_mapping/blob/main/CODE_OF_CONDUCT.md).

バグレポートとプルリクエストは、<https://github.com/hkob/notion_ruby_mapping>のGithubで大歓迎です。このプロジェクトは、コラボレーションのための安全で居心地の良いスペースであることを目的としており、貢献者は[行動規範](https://github.com/hkob/notion_ruby_mapping/blob/main/code_of_conduct.md)を遵守することが期待されています。

## 5. License / ライセンス

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

GEMは、[MITライセンス](https://opensource.org/licenses/mit)の条件の下でオープンソースとして入手できます。

## 6. Code of Conduct / 行動規範

Everyone interacting in the NotionRubyMapping project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/hkob/notion_ruby_mapping/blob/main/CODE_OF_CONDUCT.md).

NotionRubyMappingプロジェクトのコードベース、問題トラッカー、チャットルーム、メーリングリストで対話する全員が[行動規範](https://github.com/hkob/notion_ruby_mapping/blob/main/code_of_conduct.md)に従うことが期待されています。

## [Unreleased]

## [4.1.0] - 2026-08-23

### Removed

- `Property#contents?`
- `Property#assert_database_property`
- `def_delegators :retrieve_page_property` and `extend Forwardable` in `Property`
  (a workaround for the 2022-06-28 API version, made unnecessary by the 2022-08-31 update)

### Changed

- `Property.create_from_json` now raises a `StandardError` when the given JSON has no `type` key
- Unsupported property types now raise a unified message:
  `Unsupported property type: <type> (<name>). Please update notion_ruby_mapping.`
- `Property#update_from_json` now assigns the value whenever the key exists,
  so `false` and empty values are reflected correctly
- `List#initialize` normalizes `query` to `Query.new` when `nil` is given
- `assert_*` methods use positive conditions and a consistent
  `Database or DataSource property` wording

## [0.1.0] - 2022-02-07

- Initial release
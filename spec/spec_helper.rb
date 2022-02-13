# frozen_string_literal: true

require "notion_ruby_mapping"
require "json"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def prepare_cache(config, _key)
  nc = NotionRubyMapping::NotionCache.instance
  nc.create_client config["notion_token"]
end

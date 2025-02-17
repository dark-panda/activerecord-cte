# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

ENV["RAILS_ENV"] = "test"

require "active_record"
require "active_record/fixtures"
require "active_support/test_case"

require "activerecord/cte"

require "active_support/testing/autorun"

adapter = ENV.fetch("DATABASE_ADAPTER") { "sqlite3" }

db_config = YAML.load_file("test/database.yml")[adapter]

ActiveRecord::Base.configurations = { "test" => db_config } # Key must be string for older AR versions
ActiveRecord::Tasks::DatabaseTasks.create(db_config) if %w[postgresql mysql].include?(adapter)
ActiveRecord::Base.establish_connection(:test)

ActiveSupport.on_load(:active_support_test_case) do
  include ActiveRecord::TestFixtures
  self.fixture_path = "test/fixtures/"

  ActiveSupport::TestCase.test_order = :random
end

ActiveRecord::Schema.define do
  create_table :posts, force: true do |t|
    t.boolean :archived, default: false
    t.integer :views_count
    t.string :language, default: :en
    t.timestamps
  end
end

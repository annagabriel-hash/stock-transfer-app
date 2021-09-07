# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'shoulda/matchers'
require 'factory_bot_rails'
require 'vcr'


Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    DatabaseRewinder.clean_all
  end

  config.after(:each) do
    DatabaseRewinder.clean
  end
  # Include test helpers
  config.include Helpers::Authentication, type: :system
  config.include Helpers::Stock, type: :system
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::IntegrationHelpers, type: :system
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

VCR.configure do |c|
  c.cassette_library_dir = Rails.root.join('spec/vcr')
  c.hook_into :faraday
  c.ignore_localhost = true
  c.configure_rspec_metadata!
  c.default_cassette_options = {
    match_requests_on: %i[method uri body]
  }
  c.allow_http_connections_when_no_cassette = true
  c.filter_sensitive_data('test-iex-api-publishable-token') { ENV['IEX_PUBLISHABLE_TOKEN'] }
  c.filter_sensitive_data('test-iex-api-secret-token') { ENV['IEX_SECRET_TOKEN'] }
end

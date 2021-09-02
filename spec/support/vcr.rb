require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = Rails.root.join('spec/vcr')
  c.hook_into :webmock
  c.ignore_localhost = true
  c.configure_rspec_metadata!
  c.default_cassette_options = {
    match_requests_on: %i[method uri body]
  }
  c.allow_http_connections_when_no_cassette = true
  c.filter_sensitive_data('test-iex-api-publishable-token') { ENV['IEX_PUBLISHABLE_TOKEN'] }
  c.filter_sensitive_data('test-iex-api-secret-token') { ENV['IEX_SECRET_TOKEN'] }
end

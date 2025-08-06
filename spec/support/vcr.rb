# frozen_string_literal: true

VCR.configure do |config|
  config.cassette_library_dir = "spec/cassettes"
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.default_cassette_options = {
    match_requests_on: %i[method uri]
  }

  # Uncomment to enable VCR debugging
  config.debug_logger = File.open(Rails.root.join("log/vcr.log"), "w")
end

# frozen_string_literal: true

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

# Run Coverage report
require 'solidus_dev_support/rspec/coverage'

# Create the dummy app if it's still missing.
dummy_app_environment = File.expand_path('dummy/config/environment.rb', __dir__).tap do |file|
  system 'bin/rake extension:test_app' unless File.exist? file
end

require dummy_app_environment

# Requires factories and other useful helpers defined in spree_core.
require 'solidus_dev_support/rspec/feature_helper'
require 'spree/testing_support/order_walkthrough'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }

# Requires factories defined in lib/solidus_paypal_commerce_platform/factories.rb
require 'solidus_paypal_commerce_platform/factories'

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = false
end

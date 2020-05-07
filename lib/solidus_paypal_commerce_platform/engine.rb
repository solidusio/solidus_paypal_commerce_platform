# frozen_string_literal: true

require 'spree/core'
require 'solidus_paypal_commerce_platform'

module SolidusPaypalCommercePlatform
  class Engine < Rails::Engine
    include SolidusSupport::EngineExtensions

    isolate_namespace ::Spree

    engine_name 'solidus_paypal_commerce_platform'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end
  end
end

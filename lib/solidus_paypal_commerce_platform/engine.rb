# frozen_string_literal: true

require 'spree/core'
require 'solidus_paypal_commerce_platform'

module SolidusPaypalCommercePlatform
  class Engine < Rails::Engine
    include SolidusSupport::EngineExtensions

    isolate_namespace ::Spree

    engine_name 'solidus_paypal_commerce_platform'

    initializer "register_solidus_paypal_commerce_platform_gateway", after: "spree.register.payment_methods" do |app|
      app.config.spree.payment_methods << SolidusPaypalCommercePlatform::Gateway
    end

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end
  end
end

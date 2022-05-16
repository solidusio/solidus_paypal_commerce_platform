# frozen_string_literal: true

require 'deface'
require 'solidus_core'
require 'solidus_paypal_commerce_platform'
require 'solidus_webhooks'
require 'solidus_support'

module SolidusPaypalCommercePlatform
  class Engine < Rails::Engine
    include SolidusSupport::EngineExtensions

    isolate_namespace SolidusPaypalCommercePlatform

    engine_name 'solidus_paypal_commerce_platform'

    initializer "solidus_paypal_commerce_platform.add_payment_method", after: "spree.register.payment_methods" do |app|
      app.config.to_prepare do
        app.config.spree.payment_methods << SolidusPaypalCommercePlatform::PaymentMethod
        SolidusPaypalCommercePlatform::PaymentMethod.allowed_admin_form_preference_types << :paypal_select
        ::Spree::PermittedAttributes.source_attributes.concat [:paypal_order_id, :authorization_id,
                                                             :paypal_email, :paypal_funding_source]
      end
    end

    initializer "solidus_paypal_commerce_platform.add_wizard", after: "spree.register.payment_methods" do |app|
      # Adding the class set below - if this is ported to core, we can remove this line.
      Spree::Core::Environment.add_class_set("payment_setup_wizards")
      app.config.spree.payment_setup_wizards << "SolidusPaypalCommercePlatform::Wizard"
    end

    initializer "solidus_paypal_commerce_platform.set_pricing_options_class" do
      def (Spree::Config).pricing_options_class
        SolidusPaypalCommercePlatform::PricingOptions
      end
    end

    initializer "solidus_paypal_commerce_platform.webhooks" do
      SolidusWebhooks.config.register_webhook_handler :solidus_paypal_commerce_platform, ->(payload) {
        SolidusPaypalCommercePlatform::WebhooksJob.perform_now(payload)
      }
    end

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end
  end
end

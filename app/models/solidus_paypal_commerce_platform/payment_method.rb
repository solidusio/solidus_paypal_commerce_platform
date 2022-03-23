# frozen_string_literal: true

module SolidusPaypalCommercePlatform
  class PaymentMethod < SolidusSupport.payment_method_parent_class
    include SolidusPaypalCommercePlatform::ButtonOptionsHelper
    preference :client_id, :string
    preference :client_secret, :string
    preference :paypal_button_color, :paypal_select, default: "gold"
    preference :paypal_button_size, :paypal_select, default: "responsive"
    preference :paypal_button_shape, :paypal_select, default: "rect"
    preference :paypal_button_layout, :paypal_select, default: "vertical"
    preference :display_on_cart, :boolean, default: true
    preference :display_on_product_page, :boolean, default: true
    preference :display_credit_messaging, :boolean, default: true
    preference :venmo_standalone, :paypal_select, default: 'disabled'
    preference :force_buyer_country, :string

    validates :preferred_paypal_button_color, exclusion: {
      in: %w[gold],
      message: I18n.t("solidus_paypal_commerce_platform.payment_method.gold_button_message")
    }, if: :venmo_standalone_enabled?

    def venmo_standalone_enabled?
      options[:venmo_standalone] != 'disabled'
    end

    def render_only_venmo_standalone?
      options[:venmo_standalone] == 'render only standalone'
    end

    def partial_name
      "paypal_commerce_platform"
    end

    def display_on_cart
      options[:display_on_cart] || false
    end

    def cart_partial_name
      "paypal_commerce_platform"
    end

    def display_on_product_page
      options[:display_on_product_page] || false
    end

    def product_page_partial_name
      "paypal_commerce_platform"
    end

    def client_id
      options[:client_id]
    end

    def client_secret
      options[:client_secret]
    end

    def payment_source_class
      PaymentSource
    end

    def gateway_class
      Gateway
    end

    def button_style
      {
        color: options[:paypal_button_color] || "gold",
        size: options[:paypal_button_size] || "responsive",
        shape: options[:paypal_button_shape] || "rect",
        layout: options[:paypal_button_layout] || "vertical"
      }
    end

    def javascript_sdk_url(order: nil, currency: nil)
      # Both instance and class respond to checkout_steps.
      step_names = order ? order.checkout_steps : ::Spree::Order.checkout_steps.keys

      commit_immediately = step_names.include? "confirm"

      parameters = {
        'client-id': client_id,
        intent: auto_capture ? "capture" : "authorize",
        commit: commit_immediately ? "false" : "true",
        components: options[:display_credit_messaging] ? "buttons,messages" : "buttons",
        currency: currency
      }

      parameters[:shipping_preference] = 'NO_SHIPPING' if step_names.exclude? 'delivery'
      parameters['enable-funding'] = 'venmo' if venmo_standalone_enabled?

      if !Rails.env.production? && options[:force_buyer_country].present?
        parameters['buyer-country'] = options[:force_buyer_country]
      end

      "https://www.paypal.com/sdk/js?#{parameters.to_query}"
    end
  end
end

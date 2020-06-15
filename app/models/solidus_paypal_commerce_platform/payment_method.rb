module SolidusPaypalCommercePlatform
  class PaymentMethod < SolidusSupport.payment_method_parent_class
    include SolidusPaypalCommercePlatform::ButtonOptionsHelper
    preference :client_id, :string
    preference :client_secret, :string
    preference :paypal_button_color, :paypal_select, default: "gold"
    preference :paypal_button_size, :paypal_select, default: "responsive"
    preference :paypal_button_shape, :paypal_select, default: "rect"
    preference :paypal_button_layout, :paypal_select, default: "vertical"

    def partial_name
      "paypal_commerce_platform"
    end

    def client_id
      preferences[:client_id]
    end

    def client_secret
      preferences[:client_secret]
    end

    def payment_source_class
      Source
    end

    def gateway_class
      Gateway
    end

    def button_style
      {
        color: preferences[:paypal_button_color],
        size: preferences[:paypal_button_size],
        shape: preferences[:paypal_button_shape],
        layout: preferences[:paypal_button_layout]
      }
    end

    def sdk_url
      parameters = {
        'client-id': client_id,
        intent: auto_capture ? "capture" : "authorize"
      }

      URI("https://www.paypal.com/sdk/js?"+parameters.to_query)
    end

  end
end

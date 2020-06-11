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
      self
    end

    def purchase(money, source, options)
      result = request.capture_order(source.paypal_order_id)
      source.update(capture_id: result.id)
      result
    end

    def authorize(money, source, options)
      response = request.authorize_order(source.paypal_order_id)
      source.update(authorization_id: response.authorization_id)
      response
    end

    def capture(money, response_code, options)
      result = request.capture_authorized_order(options[:originator].source.authorization_id)
      options[:originator].source.update(capture_id: result.id)
      result
    end

    def credit(money_cents, transaction_id, options)
      request.refund_order(options[:originator])
    end

    def void(response_code, options)
      request.void_authorization(options[:originator].source.authorization_id)
    end

    def request
      @request ||= SolidusPaypalCommercePlatform::Gateway.new(paypal_env)
    end

    def paypal_env
      @paypal_env ||= begin
        paypal_env_class = preferred_test_mode ? PayPal::SandboxEnvironment : PayPal::LiveEnvironment
        paypal_env_class.new(client_id, client_secret)
      end
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

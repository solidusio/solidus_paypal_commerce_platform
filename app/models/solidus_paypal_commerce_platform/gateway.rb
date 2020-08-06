# frozen_string_literal: true

require 'paypal-checkout-sdk'

module SolidusPaypalCommercePlatform
  class Gateway
    include PayPalCheckoutSdk::Orders
    include PayPalCheckoutSdk::Payments

    def initialize(options)
      # Cannot use kwargs because of how the Gateway is initialize by Solidus.
      @client = Client.new(
        test_mode: options.fetch(:test_mode, nil),
        client_id: options.fetch(:client_id),
        client_secret: options.fetch(:client_secret),
      )
      @options = options
    end

    def purchase(money, source, options)
      request = OrdersCaptureRequest.new(source.paypal_order_id)
      request.request_body(amount: { currency_code: options[:currency], value: Money.new(money).dollars })

      response = @client.execute_with_response(request)
      if response.success?
        capture_id = response.params["result"].purchase_units[0].payments.captures[0].id
        source.update(capture_id: capture_id)
      end
      response
    end

    def authorize(_money, source, _options)
      request = OrdersAuthorizeRequest.new(source.paypal_order_id)

      response = @client.execute_with_response(request)
      if response.success?
        authorization_id = response.params["result"].purchase_units[0].payments.authorizations[0].id
        source.update(authorization_id: authorization_id)
      end
      response
    end

    def capture(money, _response_code, options)
      source = options[:originator].source
      request = AuthorizationsCaptureRequest.new(source.authorization_id)
      request.request_body(amount: { currency_code: options[:currency], value: Money.new(money).dollars })

      response = @client.execute_with_response(request)
      if response.success?
        source.update(capture_id: response.params["result"].id)
      end
      response
    end

    def credit(_money_cents, _transaction_id, options)
      refund = options[:originator]
      source = refund.payment.source
      capture_id = source.capture_id
      request = CapturesRefundRequest.new(capture_id)
      request.request_body(amount: { currency_code: refund.currency, value: refund.amount })
      message = I18n.t('success', scope: @client.i18n_scope_for(request), amount: refund.amount)

      response = @client.execute_with_response(request, success_message: message)
      source.update(refund_id: response.params["result"].id) if response.success?
      response
    end

    def void(_response_code, options)
      authorization_id = options[:originator].source.authorization_id
      request = AuthorizationsVoidRequest.new(authorization_id)

      @client.execute_with_response(request)
    end

    def create_order(order, auto_capture)
      intent = auto_capture ? "CAPTURE" : "AUTHORIZE"
      request = OrdersCreateRequest.new
      paypal_order = SolidusPaypalCommercePlatform::PaypalOrder.new(order)
      request.request_body paypal_order.to_json(intent)

      @client.execute(request).result
    end

    def get_order(order_id)
      @client.execute(OrdersGetRequest.new(order_id)).result
    end
  end
end

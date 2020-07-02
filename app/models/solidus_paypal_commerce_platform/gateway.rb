# frozen_string_literal: true

require 'paypal-checkout-sdk'
require 'solidus_paypal_commerce_platform/access_token_authorization_request'
require 'solidus_paypal_commerce_platform/fetch_merchant_credentials_request'

module SolidusPaypalCommercePlatform
  class Gateway
    include PayPalCheckoutSdk::Orders
    include PayPalCheckoutSdk::Payments

    def initialize(options)
      # Cannot use kwargs because of how the Gateway is initialize by Solidus.
      @client = Client.new(
        test_mode: options.fetch(:test_mode, nil),
        client_id: options.fetch(:client_id),
        client_secret: options.fetch(:client_secret, ""),
      )
      @options = options
    end

    def purchase(money, source, options)
      request = OrdersCaptureRequest.new(source.paypal_order_id)
      request.request_body(amount: { currency_code: options[:currency], value: Money.new(money).dollars })
      response = @client.execute_with_response(request)
      capture_id = response.params["result"].purchase_units[0].payments.captures[0].id
      source.update(capture_id: capture_id) if response.success?
      response
    end

    def authorize(_money, source, _options)
      response = @client.execute_with_response(OrdersAuthorizeRequest.new(source.paypal_order_id))
      authorization_id = response.params["result"].purchase_units.first.payments.authorizations.first.id
      source.update(authorization_id: authorization_id) if response.success?
      response
    end

    def capture(money, _response_code, options)
      authorization_id = options[:originator].source.authorization_id
      request = AuthorizationsCaptureRequest.new(authorization_id)
      request.request_body(amount: { currency_code: options[:currency], value: Money.new(money).dollars })
      response = @client.execute_with_response(request)
      if response.success?
        capture_id = response.params["result"].id
        options[:originator].source.update(capture_id: capture_id)
      end
      response
    end

    def credit(_money_cents, _transaction_id, options)
      refund = options[:originator]
      capture_id = refund.payment.source.capture_id
      request = CapturesRefundRequest.new(capture_id)
      request.request_body(amount: { currency_code: refund.currency, value: refund.amount })
      message = I18n.t('success', scope: @client.i18n_scope_for(request), amount: refund.amount)

      @client.execute_with_response(request, success_message: message)
    end

    def void(_response_code, options)
      authorization_id = options[:originator].source.authorization_id

      @client.execute_with_response(AuthorizationsVoidRequest.new(authorization_id))
    end

    def trade_tokens(auth_code:, nonce:)
      access_token = @client.execute(AccessTokenAuthorizationRequest.new(
        environment: @client.environment,
        auth_code: auth_code,
        nonce: nonce,
      )).result.access_token

      @client.execute(FetchMerchantCredentialsRequest.new(
        access_token: access_token,
        partner_merchant_id: SolidusPaypalCommercePlatform.config.partner_id,
      )).result
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

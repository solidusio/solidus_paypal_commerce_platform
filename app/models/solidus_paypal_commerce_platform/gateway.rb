# frozen_string_literal: true

require 'paypal-checkout-sdk'
require 'solidus_paypal_commerce_platform/access_token_authorization_request'
require 'solidus_paypal_commerce_platform/fetch_merchant_credentials_request'

module SolidusPaypalCommercePlatform
  class Gateway
    class Request
      attr_accessor :path, :body, :headers, :verb

      def initialize(options)
        @path = options[:path]
        @body = options[:body] if options[:body]
        @headers = options[:headers]
        @verb = options[:verb]
      end
    end

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
      response = capture_order(source.paypal_order_id)
      capture_id = response.params["result"].purchase_units[0].payments.captures[0].id
      source.update(capture_id: capture_id) if response.success?
      response
    end

    def authorize(money, source, options)
      response = authorize_order(source.paypal_order_id)
      authorization_id = response.params["result"].purchase_units.first.payments.authorizations.first.id
      source.update(authorization_id: authorization_id) if response.success?
      response
    end

    def capture(money, response_code, options)
      response = capture_authorized_order(options[:originator].source.authorization_id)
      capture_id = response.params["result"].id
      options[:originator].source.update(capture_id: capture_id) if response.success?
      response
    end

    def credit(money_cents, transaction_id, options)
      refund_order(options[:originator])
    end

    def void(response_code, options)
      void_authorization(options[:originator].source.authorization_id)
    end

    def trade_tokens(auth_code:, nonce:)
      access_token = @client.execute(OAuthTokenRequest.new(
        environment: @client.environment,
        auth_code: auth_code,
        nonce: nonce,
      )).result.access_token

      @client.execute(FetchMerchantCredentialsRequest.new(
        access_token: access_token,
        partner_merchant_id: SolidusPaypalCommercePlatform.partner_id,
      )).result
    end

    def create_order(order, auto_capture)
      intent = auto_capture ? "CAPTURE" : "AUTHORIZE"
      post_order(order, intent).result
    end

    def capture_order(order_number)
      @client.wrap_response(post_capture(order_number), success_message: "Payment captured")
    end

    def authorize_order(order_number)
      @client.wrap_response(post_authorize(order_number), success_message: "Payment authorized")
    end

    def capture_authorized_order(authorization_id)
      @client.wrap_response(post_capture_authorized(authorization_id), success_message: "Authorization captured")
    end

    def get_order(order_id)
      get_order_details(order_id).result
    end

    def refund_order(refund)
      @client.wrap_response(post_order_refund(refund.payment.source.capture_id,refund), success_message: "Payment refunded for #{Spree::Money.new(refund.amount)}")
    end

    def void_authorization(authorization_id)
      @client.wrap_response(post_void_authorization(authorization_id), success_message: "Payment voided")
    end

    private

    def post_void_authorization(authorization_id)
      @client.execute(
        Request.new({
          path: "/v2/payments/authorizations/#{authorization_id}/void",
          headers: {
            "Content-Type" => "application/json",
          },
          verb: "POST"
        })
      )
    end

    def post_order_refund(capture_id,refund)
      @client.execute(
        Request.new({
          path: "/v2/payments/captures/#{capture_id}/refund",
          body: {
            "amount": {
              "currency_code": refund.currency,
              "value": refund.amount
            }
          },
          headers: {
            "Content-Type" => "application/json",
          },
          verb: "POST"
        })
      )
    end

    def get_order_details(order_number)
      @client.execute(
        Request.new({
          path: "/v2/checkout/orders/#{order_number}",
          headers: {
            "Content-Type" => "application/json",
          },
          verb: "GET"
        })
      )
    end

    def post_authorize(order_number)
      @client.execute(
        Request.new({
          path: "/v2/checkout/orders/#{order_number}/authorize",
          headers: {
            "Content-Type" => "application/json",
          },
          verb: "POST"
        })
      )
    end

    def post_capture_authorized(authorization_id)
      @client.execute(
        Request.new({
          path: "/v2/payments/authorizations/#{authorization_id}/capture",
          headers: {
            "Content-Type" => "application/json",
          },
          verb: "POST"
        })
      )
    end

    def post_capture(order_number)
      @client.execute(
        Request.new({
          path: "/v2/checkout/orders/#{order_number}/capture",
          headers: {
            "Content-Type" => "application/json",
          },
          verb: "POST"
        })
      )
    end

    def post_order(order, intent)
      @client.execute(
        Request.new({
          path: "/v2/checkout/orders",
          body: SolidusPaypalCommercePlatform::PaypalOrder.new(order).to_json(intent),
          headers: {
            "Content-Type" => "application/json",
          },
          verb: "POST"
        })
      )
    end
  end
end

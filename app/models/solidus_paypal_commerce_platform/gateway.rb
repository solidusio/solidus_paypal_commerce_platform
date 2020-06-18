# frozen_string_literal: true

require 'paypal-checkout-sdk'

module SolidusPaypalCommercePlatform
  class Gateway

    PARTNER_ATTRIBUTION_INJECTOR = ->(request) {
      request.headers["PayPal-Partner-Attribution-Id"] = "Solidus_PCP_SP"
    }

    class Request
      attr_accessor :path, :body, :headers, :verb

      def initialize(options)
        @path = options[:path]
        @body = options[:body] if options[:body]
        @headers = options[:headers]
        @verb = options[:verb]
      end
    end

    class Client < PayPal::PayPalHttpClient
      def execute(request)
        super
      rescue PayPalHttp::HttpError
        OpenStruct.new(status_code: nil)
      end
    end

    def initialize(options)
      test_mode = options.fetch(:test_mode, nil)
      client_id = options.fetch(:client_id)
      client_secret = options.fetch(:client_secret, "")

      test_mode = SolidusPaypalCommercePlatform.env.sandbox? if test_mode.nil?
      env_class = test_mode ? PayPal::SandboxEnvironment : PayPal::LiveEnvironment
      paypal_env = env_class.new(client_id, client_secret)

      @auth_string = paypal_env.authorizationString
      @client = Client.new(paypal_env)
      @client.add_injector(&PARTNER_ATTRIBUTION_INJECTOR)
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

    def trade_tokens(credentials)
      access_token = get_access_token(
        auth_code: credentials.fetch(:authCode),
        nonce: credentials.fetch(:nonce),
      ).result.access_token

      get_api_credentials(
        access_token: access_token,
        partner_merchant_id: SolidusPaypalCommercePlatform.partner_id,
      ).result
    end

    def create_order(order, auto_capture)
      intent = auto_capture ? "CAPTURE" : "AUTHORIZE"
      post_order(order, intent).result
    end

    def capture_order(order_number)
      Response.new(post_capture(order_number), "Payment captured")
    end

    def authorize_order(order_number)
      Response.new(post_authorize(order_number), "Payment authorized")
    end

    def capture_authorized_order(authorization_id)
      Response.new(post_capture_authorized(authorization_id), "Authorization captured")
    end

    def get_order(order_id)
      get_order_details(order_id).result
    end

    def refund_order(refund)
      Response.new(post_order_refund(refund.payment.source.capture_id,refund),"Payment refunded for #{Spree::Money.new(refund.amount)}")
    end

    def void_authorization(authorization_id)
      Response.new(post_void_authorization(authorization_id), "Payment voided")
    end

    private

    def post_void_authorization(authorization_id)
      @client.execute(
        Request.new({
          path: "/v2/payments/authorizations/#{authorization_id}/void",
          headers: {
            "Content-Type" => "application/json",
            "Authorization" => @auth_string
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
            "Authorization" => @auth_string
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
            "Authorization" => @auth_string
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
            "Authorization" => @auth_string,
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
            "Authorization" => @auth_string,
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
            "Authorization" => @auth_string,
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
            "Authorization" => @auth_string,
          },
          verb: "POST"
        })
      )
    end

    def get_access_token(auth_code:, nonce:)
      @client.execute(
        Request.new({
          path: "/v1/oauth2/token",
          body: {
            grant_type: "authorization_code",
            code: auth_code,
            code_verifier: nonce,
          },
          headers: {
            "Content-Type" => "application/x-www-form-urlencoded",
            "Authorization" => @auth_string,
          },
          verb: "POST"
        })
      )
    end

    def get_api_credentials(access_token:, partner_merchant_id:)
      @client.execute(
        Request.new({
          path: "/v1/customer/partners/#{partner_merchant_id}/merchant-integrations/credentials",
          headers: {
            "Content-Type" => "application/json",
            "Authorization" => "Bearer #{access_token}"
          },
          verb: "GET"
        })
      )
    end
  end
end

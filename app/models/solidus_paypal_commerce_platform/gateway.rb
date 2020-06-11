require 'paypal-checkout-sdk'

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
      test_mode = options.fetch(:test_mode, nil)
      client_id = options.fetch(:client_id)
      client_secret = options.fetch(:client_secret, "")

      test_mode = SolidusPaypalCommercePlatform.env.sandbox? if test_mode.nil?
      env_class = test_mode ? PayPal::SandboxEnvironment : PayPal::LiveEnvironment
      paypal_env = env_class.new(client_id, client_secret)

      @auth_string = paypal_env.authorizationString
      @client = PayPal::PayPalHttpClient.new(paypal_env)
      @options = options
    end

    def purchase(money, source, options)
      result = capture_order(source.paypal_order_id)
      source.update(capture_id: result.id)
      result
    end

    def authorize(money, source, options)
      response = authorize_order(source.paypal_order_id)
      source.update(authorization_id: response.authorization_id)
      response
    end

    def capture(money, response_code, options)
      result = capture_authorized_order(options[:originator].source.authorization_id)
      options[:originator].source.update(capture_id: result.id)
      result
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

      get_api_credentials(accessToken: access_token).result
    end

    def create_order(order, auto_capture)
      intent = auto_capture ? "CAPTURE" : "AUTHORIZE"
      post_order(order, intent).result
    end

    def capture_order(order_number)
      request = post_capture(order_number)
      if request.status_code == 201
        return OpenStruct.new(
          success?: true,
          id: request.result.purchase_units[0].payments.captures[0].id
        )
      end
    end

    def authorize_order(order_number)
      response = post_authorize(order_number)
      if response.status_code == 201
        return OpenStruct.new(
          success?: true,
          authorization_id: response.result.purchase_units.first.payments.authorizations.first.id
        )
      end
    end

    def capture_authorized_order(authorization_id)
      request = post_capture_authorized(authorization_id)
      if request.status_code == 201
        return OpenStruct.new(
          success?: true,
          id: request.result.id
        )
      end
    end

    def get_order(order_id)
      get_order_details(order_id).result
    end

    def refund_order(refund)
      if post_order_refund(refund.payment.source.capture_id,refund).status_code == 201
        return OpenStruct.new(success?:true)
      end
    end

    def void_authorization(authorization_id)
      if post_void_authorization(authorization_id).status_code == 204
        return OpenStruct.new(success?: true)
      end
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
            "Authoriation" => @auth_string
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
            "PayPal-Partner-Attribution-Id" => "Solidus_PCP_SP",
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
            "PayPal-Partner-Attribution-Id" => "Solidus_PCP_SP",
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
            "PayPal-Partner-Attribution-Id" => "Solidus_PCP_SP",
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
            "PayPal-Partner-Attribution-Id" => "Solidus_PCP_SP",
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

    def get_api_credentials(credentials)
      @client.execute(
        Request.new({
          path: "/v1/customer/partners/5LQZV7RJDGKG2/merchant-integrations/credentials",
          headers: {
            "Content-Type" => "application/json",
            "Authorization" => "Bearer #{credentials[:accessToken]}"
          },
          verb: "GET"
        })
      )
    end
  end
end

module SolidusPaypalCommercePlatform
  class Requests
    require 'paypal-checkout-sdk'

    class Request
      attr_accessor :path, :body, :headers, :verb

      def initialize(options)
        @path = options[:path]
        @body = options[:body] if options[:body]
        @headers = options[:headers]
        @verb = options[:verb]
      end
    end

    def initialize(client_id, client_secret = "")
      @env = PayPal::SandboxEnvironment.new(client_id, client_secret)
      @client = PayPal::PayPalHttpClient.new(@env)
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
      if post_capture(order_number).status_code == 201
        return OpenStruct.new(success?:true)
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
      if post_capture_authorized(authorization_id).status_code == 201
        return OpenStruct.new(success?:true)
      end
    end

    private

    def post_authorize(order_number)
      @client.execute(
        Request.new({
          path: "/v2/checkout/orders/#{order_number}/authorize",
          headers: {
            "Content-Type" => "application/json",
            "Authorization" => @env.authorizationString(),
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
            "Authorization" => @env.authorizationString(),
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
            "Authorization" => @env.authorizationString(),
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
            "Authorization" => @env.authorizationString(),
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
            "Authorization" => @env.authorizationString(),
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

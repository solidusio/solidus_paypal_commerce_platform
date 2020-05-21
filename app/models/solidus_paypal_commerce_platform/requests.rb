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
      access_token = get_access_token(credentials).result.access_token
      get_api_credentials({accessToken:access_token}).result
    end

    private

    def get_access_token(credentials)
      @client.execute(
        Request.new({
          path: "/v1/oauth2/token",
          body: {
            grant_type: "authorization_code",
            code: credentials[:authCode],
            code_verifier: credentials[:nonce]
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

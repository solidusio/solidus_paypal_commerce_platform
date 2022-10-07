# frozen_string_literal: false

require 'paypalhttp'
require 'openssl'

module PayPal
  class PayPalHttpClient < PayPalHttp::HttpClient
    attr_accessor :refresh_token

    def initialize(environment, refresh_token = nil)
      super(environment)
      @refresh_token = refresh_token

      add_injector(&:_sign_request)
      add_injector(&:_add_headers)
    end

    def user_agent
      library_details ||= "ruby #{RUBY_VERSION}p#{RUBY_PATCHLEVEL}-#{RUBY_PLATFORM}"
      begin
        library_details << ";#{OpenSSL::OPENSSL_LIBRARY_VERSION}"
      rescue NameError
        library_details << ";OpenSSL #{OpenSSL::OPENSSL_VERSION}"
      end

      "PayPalSDK-FORK/rest-sdk-ruby (#{library_details})"
    end

    def _sign_request(request)
      return if !_has_auth_header(request) && !_is_auth_request(request)

      if !@access_token || @access_token.expired?
        access_token_request = PayPal.access_token_request.new(@environment, @refresh_token)
        token_response = execute(access_token_request)
        @access_token = PayPal::AccessToken.new(token_response.result)
      end
      request.headers["Authorization"] = @access_token.authorization_string
    end

    def _add_headers(request)
      request.headers["Accept-Encoding"] = "gzip"
      request.headers["sdk_name"] = "Checkout SDK"
      request.headers["sdk_tech_stack"] = "Ruby#{RUBY_VERSION}"
      request.headers["api_integration_type"] = "PAYPALSDK"
    end

    def _is_auth_request(request)
      request.path == '/v1/oauth2/token' ||
        request.path == '/v1/identity/openidconnect/tokenservice'
    end

    def _has_auth_header(request)
      request.headers.key?("Authorization")
    end
  end
end

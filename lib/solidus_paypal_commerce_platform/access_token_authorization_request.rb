# frozen_string_literal: true

module SolidusPaypalCommercePlatform
  class AccessTokenAuthorizationRequest
    attr_accessor :verb, :path, :headers, :body

    def initialize(environment:, auth_code:, nonce:)
      @verb = "POST"
      @path = "/v1/oauth2/token"
      @headers = {
        "Content-Type" => "application/x-www-form-urlencoded",
        "Authorization" => environment.authorization_string,
      }
      @body = {
        grant_type: "authorization_code",
        code: auth_code,
        code_verifier: nonce,
      }
    end
  end
end

# frozen_string_literal: true

module SolidusPaypalCommercePlatform
  # https://developer.paypal.com/docs/api/partner-referrals/v1/#merchant-integration_credentials
  class FetchMerchantCredentialsRequest
    attr_accessor :verb, :path, :headers, :body

    def initialize(partner_merchant_id:, access_token:)
      @verb = "GET"
      @path = "/v1/customer/partners/#{partner_merchant_id}/merchant-integrations/credentials"
      @headers = {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{access_token}"
      }
    end
  end
end

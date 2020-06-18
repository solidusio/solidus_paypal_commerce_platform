require 'paypal-checkout-sdk'

module SolidusPaypalCommercePlatform
  class Client
    SUCCESS_STATUS_CODES = [201, 204]

    PARTNER_ATTRIBUTION_INJECTOR = ->(request) {
      request.headers["PayPal-Partner-Attribution-Id"] = "Solidus_PCP_SP"
    }

    attr_reader :environment

    def initialize(test_mode: nil, client_id:, client_secret: "")
      test_mode = SolidusPaypalCommercePlatform.env.sandbox? if test_mode.nil?
      env_class = test_mode ? PayPal::SandboxEnvironment : PayPal::LiveEnvironment

      @environment = env_class.new(client_id, client_secret)
      @paypal_client = PayPal::PayPalHttpClient.new(@environment)

      @paypal_client.add_injector(&PARTNER_ATTRIBUTION_INJECTOR)
    end

    def execute(request)
      @paypal_client.execute(request)
    rescue PayPalHttp::HttpError
      OpenStruct.new(status_code: nil)
    end

    def wrap_response(response, success_message: nil, failure_message: nil)
      if SUCCESS_STATUS_CODES.include? response.status_code
        success_message ||= "Success."
        ActiveMerchant::Billing::Response.new(true, success_message, result: response.result)
      else
        failure_message ||= "A problem has occurred with this payment, please try again."
        ActiveMerchant::Billing::Response.new(false, failure_message)
      end
    end
  end
end

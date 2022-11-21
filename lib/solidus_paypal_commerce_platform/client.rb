# frozen_string_literal: true

require 'solidus_paypal_commerce_platform/access_token_authorization_request'
require 'solidus_paypal_commerce_platform/fetch_merchant_credentials_request'

require 'paypalhttp'

module SolidusPaypalCommercePlatform
  class Client
    SUCCESS_STATUS_CODES = [201, 204].freeze

    PARTNER_ATTRIBUTION_INJECTOR = ->(request) {
      request.headers["PayPal-Partner-Attribution-Id"] = SolidusPaypalCommercePlatform.config.partner_code
    }.freeze

    Response = Struct.new(:status_code, :error, keyword_init: true)

    attr_reader :environment

    def initialize(client_id:, client_secret: "", test_mode: nil)
      test_mode = SolidusPaypalCommercePlatform.config.env.sandbox? if test_mode.nil?
      env_class = test_mode ? PayPal::SandboxEnvironment : PayPal::LiveEnvironment

      @environment = env_class.new(client_id, client_secret)
      @paypal_client = PayPal::PayPalHttpClient.new(@environment)

      @paypal_client.add_injector(&PARTNER_ATTRIBUTION_INJECTOR)
    end

    def execute(request)
      @paypal_client.execute(request)
    rescue PayPalHttp::HttpError => e
      Rails.logger.error e.result
      Response.new(status_code: 422, error: e.result)
    end

    def execute_with_response(request, success_message: nil, failure_message: nil)
      i18n_scope = i18n_scope_for(request)
      wrap_response(
        execute(request),
        success_message: success_message || I18n.t("#{i18n_scope}.success", default: nil),
        failure_message: failure_message || I18n.t("#{i18n_scope}.failure", default: nil)
      )
    end

    def i18n_scope_for(request)
      "solidus_paypal_commerce_platform.responses.#{request.class.name.underscore}"
    end

    def self.fetch_api_credentials(auth_code:, client_id:, nonce:)
      client = new(client_id: client_id)

      access_token = client.execute(AccessTokenAuthorizationRequest.new(
        environment: client.environment,
        auth_code: auth_code,
        nonce: nonce,
      )).result.access_token

      client.execute(FetchMerchantCredentialsRequest.new(
        access_token: access_token,
        partner_merchant_id: SolidusPaypalCommercePlatform.config.partner_id,
      )).result
    end

    def wrap_response(response, success_message: nil, failure_message: nil)
      if SUCCESS_STATUS_CODES.include? response.status_code
        success_message ||= "Success."

        ActiveMerchant::Billing::Response.new(
          true,
          success_message,
          result: response.result,
          paypal_debug_id: response.headers["paypal-debug-id"]
        )
      else
        failure_message ||= "A problem has occurred with this payment, please try again."

        ActiveMerchant::Billing::Response.new(
          false,
          failure_message
        )
      end
    end
  end
end

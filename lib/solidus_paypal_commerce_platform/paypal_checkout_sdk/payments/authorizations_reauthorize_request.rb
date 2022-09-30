# frozen_string_literal: true

# frozen_string_literal :true

# This module was automatically generated from paypal_checkout_sdk 1.0.1
require 'cgi'

module SolidusPaypalCommercePlatform
  module PayPalCheckoutSdk
    module Payments
      #
      # Reauthorizes an authorized PayPal account payment, by ID. To ensure
      # that funds are still available, reauthorize a payment after its
      # initial three-day honor period expires. You can reauthorize a payment
      # only once from days four to 29.<br/><br/>If 30 days have transpired since
      # the date of the original authorization, you must create an authorized
      # payment instead of reauthorizing the original authorized payment.<br/><br/>
      # A reauthorized payment itself has a new honor period of three days.
      # <br/><br/>You can reauthorize an authorized payment once for up to 115%
      # of the original authorized amount, not to exceed an increase of
      # $75 USD.<br/><br/>Supports only the `amount` request parameter.
      #
      class AuthorizationsReauthorizeRequest
        attr_accessor :path, :body, :headers, :verb

        def initialize(authorization_id)
          @headers = {}
          @body = nil
          @verb = "POST"
          @path = "/v2/payments/authorizations/{authorization_id}/reauthorize?"

          @path = @path.gsub("{authorization_id}", CGI.escape(authorization_id.to_s))
          @headers["Content-Type"] = "application/json"
        end

        def pay_pal_request_id(pay_pal_request_id)
          @headers["PayPal-Request-Id"] = pay_pal_request_id
        end

        def prefer(prefer)
          @headers["Prefer"] = prefer
        end

        def request_body(reauthorize_request)
          @body = reauthorize_request
        end
      end
    end
  end
end

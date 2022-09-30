# frozen_string_literal: false

# This class was generated on Mon, 27 Aug 2018 13:52:18 PDT by version 0.1.0-dev+904328-dirty of Braintree SDK Generator

require 'cgi'

module PayPalCheckoutSdk
  module Payments
    #
    # Captures an authorized payment, by ID.
    #
    class AuthorizationsCaptureRequest
      attr_accessor :path, :body, :headers, :verb

      def initialize(authorization_id)
        @headers = {}
        @body = nil
        @verb = "POST"
        @path = "/v2/payments/authorizations/{authorization_id}/capture?"

        @path = @path.gsub("{authorization_id}", CGI.escape(authorization_id.to_s))
        @headers["Content-Type"] = "application/json"
      end

      def pay_pal_request_id(pay_pal_request_id)
        @headers["PayPal-Request-Id"] = pay_pal_request_id
      end

      def prefer(prefer)
        @headers["Prefer"] = prefer
      end

      def request_body(capture)
        @body = capture
      end
    end
  end
end

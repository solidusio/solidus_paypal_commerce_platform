# frozen_string_literal: false

# This class was generated on Mon, 27 Aug 2018 13:52:18 PDT by version 0.1.0-dev+904328-dirty of Braintree SDK Generator

require 'cgi'

module PayPalCheckoutSdk
  module Payments
    #
    # Shows details for an authorized payment, by ID.
    #
    class AuthorizationsGetRequest
      attr_accessor :path, :body, :headers, :verb

      def initialize(authorization_id)
        @headers = {}
        @body = nil
        @verb = "GET"
        @path = "/v2/payments/authorizations/{authorization_id}?"

        @path = @path.gsub("{authorization_id}", CGI.escape(authorization_id.to_s))
        @headers["Content-Type"] = "application/json"
      end
    end
  end
end

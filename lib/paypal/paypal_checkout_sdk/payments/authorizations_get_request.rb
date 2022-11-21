# frozen_string_literal: false

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

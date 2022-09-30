# frozen_string_literal: false

# This class was generated on Mon, 27 Aug 2018 13:52:18 PDT by version 0.1.0-dev+904328-dirty of Braintree SDK Generator

require 'cgi'

module PayPalCheckoutSdk
  module Payments
    #
    # Shows details for a refund, by ID.
    #
    class RefundsGetRequest
      attr_accessor :path, :body, :headers, :verb

      def initialize(refund_id)
        @headers = {}
        @body = nil
        @verb = "GET"
        @path = "/v2/payments/refunds/{refund_id}?"

        @path = @path.gsub("{refund_id}", CGI.escape(refund_id.to_s))
        @headers["Content-Type"] = "application/json"
      end
    end
  end
end

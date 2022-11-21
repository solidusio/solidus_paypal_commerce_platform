# frozen_string_literal: false

require 'cgi'

module PayPalCheckoutSdk
  module Payments
    #
    # Shows details for a captured payment, by ID.
    #
    class CapturesGetRequest
      attr_accessor :path, :body, :headers, :verb

      def initialize(capture_id)
        @headers = {}
        @body = nil
        @verb = "GET"
        @path = "/v2/payments/captures/{capture_id}?"

        @path = @path.gsub("{capture_id}", CGI.escape(capture_id.to_s))
        @headers["Content-Type"] = "application/json"
      end
    end
  end
end

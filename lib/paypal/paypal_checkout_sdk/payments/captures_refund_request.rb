# frozen_string_literal: false

require 'cgi'

module PayPalCheckoutSdk
  module Payments
    #
    # Refunds a captured payment, by ID. For a full refund, include
    # an empty payload in the JSON request body. For a partial refund,
    # include an <code>amount</code> object in the JSON request body.
    #
    class CapturesRefundRequest
      attr_accessor :path, :body, :headers, :verb

      def initialize(capture_id)
        @headers = {}
        @body = nil
        @verb = "POST"
        @path = "/v2/payments/captures/{capture_id}/refund?"

        @path = @path.gsub("{capture_id}", CGI.escape(capture_id.to_s))
        @headers["Content-Type"] = "application/json"
      end

      def pay_pal_request_id(pay_pal_request_id)
        @headers["PayPal-Request-Id"] = pay_pal_request_id
      end

      def prefer(prefer)
        @headers["Prefer"] = prefer
      end

      def request_body(refund_request)
        @body = refund_request
      end
    end
  end
end

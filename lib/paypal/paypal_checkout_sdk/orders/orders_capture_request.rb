# frozen_string_literal: false

# This class was generated on Mon, 27 Aug 2018 13:51:59 PDT by version 0.1.0-dev+904328-dirty of Braintree SDK Generator

require 'cgi'

module PayPalCheckoutSdk
  module Orders
    #
    # Captures a payment for an order.
    #
    class OrdersCaptureRequest
      attr_accessor :path, :body, :headers, :verb

      def initialize(order_id)
        @headers = {}
        @body = nil
        @verb = "POST"
        @path = "/v2/checkout/orders/{order_id}/capture?"

        @path = @path.gsub("{order_id}", CGI.escape(order_id.to_s))
        @headers["Content-Type"] = "application/json"
      end

      def pay_pal_client_metadata_id(pay_pal_client_metadata_id)
        @headers["PayPal-Client-Metadata-Id"] = pay_pal_client_metadata_id
      end

      def pay_pal_request_id(pay_pal_request_id)
        @headers["PayPal-Request-Id"] = pay_pal_request_id
      end

      def prefer(prefer)
        @headers["Prefer"] = prefer
      end

      def request_body(order_action_request)
        @body = order_action_request
      end
    end
  end
end

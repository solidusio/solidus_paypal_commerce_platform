# frozen_string_literal: false

require 'cgi'

module PayPalCheckoutSdk
  module Orders
    class OrdersPatchRequest
      attr_accessor :path, :body, :headers, :verb

      def initialize(order_id)
        @headers = {}
        @body = nil
        @verb = "PATCH"
        @path = "/v2/checkout/orders/{order_id}?"

        @path = @path.gsub("{order_id}", CGI.escape(order_id.to_s))
        @headers["Content-Type"] = "application/json"
      end

      def request_body(patch_request)
        @body = patch_request
      end
    end
  end
end

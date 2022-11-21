# frozen_string_literal: false

require 'cgi'

module PayPalCheckoutSdk
  module Orders
    #
    # Shows details for an order, by ID.
    #
    class OrdersGetRequest
      attr_accessor :path, :body, :headers, :verb

      def initialize(order_id)
        @headers = {}
        @body = nil
        @verb = "GET"
        @path = "/v2/checkout/orders/{order_id}?"

        @path = @path.gsub("{order_id}", CGI.escape(order_id.to_s))
        @headers["Content-Type"] = "application/json"
      end
    end
  end
end

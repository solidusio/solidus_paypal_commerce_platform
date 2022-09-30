# frozen_string_literal: false

# This class was generated on Mon, 27 Aug 2018 13:51:59 PDT by version 0.1.0-dev+904328-dirty of Braintree SDK Generator

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

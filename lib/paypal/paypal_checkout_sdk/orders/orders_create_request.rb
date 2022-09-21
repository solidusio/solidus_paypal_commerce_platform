# frozen_string_literal: false

# This class was generated on Mon, 27 Aug 2018 13:51:59 PDT by version 0.1.0-dev+904328-dirty of Braintree SDK Generator

require 'cgi'

module PayPalCheckoutSdk
  module Orders
    #
    # Creates an order. Supports only orders with one purchase unit.
    #
    class OrdersCreateRequest
      attr_accessor :path, :body, :headers, :verb

      def initialize
        @headers = {}
        @body = nil
        @verb = "POST"
        @path = "/v2/checkout/orders?"
        @headers["Content-Type"] = "application/json"
      end

      def pay_pal_partner_attribution_id(pay_pal_partner_attribution_id)
        @headers["PayPal-Partner-Attribution-Id"] = pay_pal_partner_attribution_id
      end

      def prefer(prefer)
        @headers["Prefer"] = prefer
      end

      def request_body(order)
        @body = order
      end
    end
  end
end

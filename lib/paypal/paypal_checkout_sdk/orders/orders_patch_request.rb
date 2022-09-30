# frozen_string_literal: false

# This class was generated on Mon, 27 Aug 2018 13:51:59 PDT by version 0.1.0-dev+904328-dirty of Braintree SDK Generator

require 'cgi'

module PayPalCheckoutSdk
  module Orders
    #
    # Updates an order that has the `CREATED` or `APPROVED` status. You cannot update an order with `COMPLETED` status.
    # You can patch these attributes and objects:
    # <table>
    #   <thead>
    #     <tr>
    #       <th align="left">Attribute or object</th>
    #       <th align="left">Operations</th>
    #     </tr>
    #   </thead>
    #   <tbody>
    #     <tr>
    #       <td><code>intent</code></td>
    #       <td align="left">Replace</td>
    #     </tr>
    #     <tr>
    #       <td><code>purchase_units</code></td>
    #       <td align="left">Replace, add</td>
    #     </tr>
    #     <tr>
    #       <td><code>purchase_units[].custom_id</code></td>
    #       <td align="left">Replace, add, remove</td>
    #     </tr>
    #     <tr>
    #      <td><code>purchase_units[].description</code></td>
    #      <td align="left">Replace, add, remove</td>
    #     </tr>
    #     <tr>
    #       <td><code>purchase_units[].payee.email</code></td>
    #       <td align="left">Replace, add</td>
    #     </tr>
    #     <tr>
    #       <td><code>purchase_units[].shipping</code></td>
    #       <td align="left">Replace, add, remove</td>
    #     </tr>
    #     <tr>
    #       <td><code>purchase_units[].soft_descriptor</code></td>
    #       <td align="left">Replace, add, remove</td>
    #     </tr>
    #     <tr>
    #       <td><code>purchase_units[].amount</code></td>
    #       <td align="left">Replace</td>
    #     </tr>
    #     <tr>
    #       <td><code>purchase_units[].invoice_id</code></td>
    #       <td align="left">Replace, add, remove</td>
    #     </tr>
    #   </tbody>
    # </table>
    #
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

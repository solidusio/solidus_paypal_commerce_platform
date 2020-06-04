module SolidusPaypalCommercePlatform
  class PaypalOrder

    def initialize(order)
      @order = order
    end

    def to_json(intent)
      return {
        intent: intent,
        purchase_units: purchase_units,
        payer: payer
      }
    end

    private

    def get_address(address)
      {
        address_line_1: address.address1,
        address_line_2: address.address2,
        admin_area_1: address.state_text,
        admin_area_2: address.city,
        postal_code: address.zipcode,
        country_code: address.country.iso,
      }
    end

    def payer
      {
        name: name(@order.bill_address),
        email_address: @order.email,
        address: get_address(@order.bill_address)
      }
    end

    def name(address)
      {
        given_name: address.firstname,
        surname: address.lastname
      }
    end

    def purchase_units
      [
        {
          amount: amount,
          items: line_items,
          shipping: shipping_info
        }
      ]
    end

    def shipping_info
      {
        name: {
          full_name: @order.ship_address.full_name
        },
        email_address: @order.email,
        address: get_address(@order.ship_address)
      }
    end

    def line_items
      @order.line_items.map{ |line_item|
        {
          name: line_item.product.name,
          unit_amount: price(line_item.price),
          tax: price(line_item.included_tax_total / line_item.quantity),
          quantity: line_item.quantity
        }
      }
    end

    def amount
      {
        currency_code: @order.currency,
        value: @order.total,
        breakdown: breakdown
      }
    end

    def breakdown
      {
        item_total: price(@order.item_total),
        shipping: price(@order.shipment_total),
        tax_total: price(@order.tax_total),
        discount: price(@order.adjustments.sum(&:amount))
      }
    end

    def price(amount)
      {
        currency_code: @order.currency,
        value: amount
      }
    end

  end
end

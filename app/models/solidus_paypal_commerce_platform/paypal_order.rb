# frozen_string_literal: true

module SolidusPaypalCommercePlatform
  class PaypalOrder
    def initialize(order)
      @order = order
    end

    def to_json(intent)
      {
        intent: intent,
        purchase_units: purchase_units,
        payer: (payer if @order.bill_address),
        application_context: application_context
      }
    end

    def to_replace_json
      {
        op: 'replace',
        path: '/purchase_units/@reference_id==\'default\'',
        value: purchase_units(include_shipping_address: false)[0]
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
      name = ::Spree::Address::Name.new address.name

      {
        given_name: name.first_name,
        surname: name.last_name
      }
    end

    def purchase_units(include_shipping_address: true)
      [
        {
          amount: amount,
          items: line_items,
          shipping: (shipping_info if @order.ship_address && include_shipping_address)
        }
      ]
    end

    def shipping_info
      {
        name: {
          full_name: full_name,
        },
        email_address: @order.email,
        address: get_address(@order.ship_address)
      }
    end

    def full_name
      @order.ship_address.name
    end

    def line_items
      @order.line_items.map{ |line_item|
        {
          name: line_item.product.name.truncate(127),
          unit_amount: price(line_item.price),
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
        tax_total: price(@order.additional_tax_total),
        discount: price(@order.all_adjustments.promotion.sum(&:amount).abs)
      }
    end

    def price(amount)
      {
        currency_code: @order.currency,
        value: amount
      }
    end

    def application_context
      {
        shipping_preference: require_shipping? ? 'SET_PROVIDED_ADDRESS' : 'NO_SHIPPING'
      }
    end

    def require_shipping?
      step_names.include? :delivery
    end

    def step_names
      @order ? @order.checkout_steps.map(&:to_sym) : ::Spree::Order.checkout_steps.keys
    end
  end
end

# frozen_string_literal: true

module SolidusPaypalCommercePlatform
  class PaypalAddress
    attr_accessor :errors

    def initialize(order)
      @order = order
      @errors
    end

    def update(paypal_address)
      formatted_address = format_address(paypal_address)
      new_address = @order.ship_address.dup
      new_address.assign_attributes(formatted_address)

      if new_address.save
        @order.update(ship_address_id: new_address.id)
      else
        @errors = new_address.errors
      end

      new_address
    end

    private

    def format_address(address)
      country = ::Spree::Country.find_by(iso: address[:country_code])
      {
        address1: address[:address_line_1],
        address2: address[:address_line_2],
        state: country.states.find_by(abbr: address[:admin_area_1]) || country.states.find_by(name: address[:admin_area_1]),
        state_name: address[:admin_area_1],
        city: address[:admin_area_2],
        country: country,
        zipcode: address[:postal_code]
      }
    end
  end
end

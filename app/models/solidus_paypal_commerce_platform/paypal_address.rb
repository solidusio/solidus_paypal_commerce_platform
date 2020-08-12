# frozen_string_literal: true

module SolidusPaypalCommercePlatform
  class PaypalAddress
    attr_reader :errors

    def initialize(order)
      @order = order
    end

    def simulate_update(paypal_address)
      @order.update(ship_address: format_simulated_address(paypal_address))

      return unless @order.ship_address.valid?

      @order.ensure_updated_shipments
      @order.email = "info@solidus.io" unless @order.email
      @order.contents.advance
    end

    def update(paypal_address)
      formatted_address = format_address(paypal_address)
      new_address = @order.ship_address.dup || ::Spree::Address.new
      new_address.assign_attributes(formatted_address)

      add_email_to_order(paypal_address[:recipient]) unless @order.email

      if new_address.save
        @order.update(ship_address_id: new_address.id)
        # Also setting billing address if it doesn't already exist
        @order.update(bill_address_id: new_address.id) unless @order.bill_address
      else
        @errors = new_address.errors
      end

      new_address
    end

    private

    def add_email_to_order(recipient)
      @order.update(email: recipient[:email_address])
    end

    def find_state(state_name, country)
      if state = country.states.find_by(abbr: state_name) || country.states.find_by(name: state_name)
        state
      else
        SolidusPaypalCommercePlatform.config.state_guesser_class.new(state_name, country).guess
      end
    end

    def format_simulated_address(paypal_address)
      country = ::Spree::Country.find_by(iso: paypal_address[:country_code])
      # Also adds fake information for a few fields, so validations can run
      ::Spree::Address.new(
        city: paypal_address[:city],
        state: find_state(paypal_address[:state], country),
        state_name: paypal_address[:state],
        zipcode: paypal_address[:postal_code],
        country: country,
        address1: "123 Fake St.",
        phone: "123456789",
        firstname: "Fake"
      )
    end

    def format_address(paypal_address)
      address = paypal_address[:updated_address]
      recipient = paypal_address[:recipient]
      country = ::Spree::Country.find_by(iso: address[:country_code])

      {
        address1: address[:address_line_1],
        address2: address[:address_line_2],
        state: find_state(address[:admin_area_1], country),
        state_name: address[:admin_area_1],
        city: address[:admin_area_2],
        country: country,
        zipcode: address[:postal_code],
        firstname: recipient[:name][:given_name],
        lastname: recipient[:name][:surname]
      }
    end
  end
end

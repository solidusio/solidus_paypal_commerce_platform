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
      formatted_address = address_attributes(paypal_address[:updated_address], paypal_address[:recipient])
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

    def find_country(state_name, country_code)
      country = ::Spree::Country.find_by(iso: country_code)
      return country if country.present?

      state = ::Spree::State.find_by("lower(name) LIKE '%#{state_name.downcase}%'")
      state.country
    end

    def find_state(state_name, country)
      return nil if country.blank?

      state = country.states.find_by(abbr: state_name) ||
                country.states.find_by(name: state_name)
      return state if state.present?

      state = SolidusPaypalCommercePlatform.config.state_guesser_class.new(
        state_name,
        country
      )
      state.guess
    end

    def format_simulated_address(paypal_address)
      # Adds fake information for a few fields, so validations can run
      paypal_address[:address_line_1] = "123 Fake St."

      ::Spree::Address.new(
        address_attributes(paypal_address, { name: { given_name: "Fake" } })
      )
    end

    def address_attributes(address, recipient)
      state_name = address[:admin_area_1] ||
                     address[:admin_area_2] ||
                     address[:state]
      country_code = address[:country_code]

      country = find_country(state_name, country_code)
      state = find_state(state_name, country)

      attributes = {
        address1: address[:address_line_1],
        address2: address[:address_line_2],
        state_id: state.try(:id),
        state_name: state.try(:name),
        city: address[:admin_area_2] || address[:city],
        country: country,
        zipcode: address[:postal_code],
      }

      if SolidusSupport.combined_first_and_last_name_in_address?
        attributes[:name] = "#{recipient[:name][:given_name]} #{recipient[:name][:surname]}"
      else
        attributes[:firstname] = recipient[:name][:given_name]
        attributes[:lastname] = recipient[:name][:surname]
      end

      attributes
    end
  end
end

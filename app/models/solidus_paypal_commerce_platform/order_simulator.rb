module SolidusPaypalCommercePlatform
  class OrderSimulator

    def initialize(order)
      @original_order = order
      @simulated_order = order.dup
    end

    def simulate_with_address(address)
      @simulated_order.ship_address = build_address(address)
      add_line_items
      create_shipments
      add_taxes
      update_totals

      @simulated_order
    end

    private

    def update_totals
      @simulated_order.total = @simulated_order.item_total + 
      @simulated_order.shipment_total + 
      @simulated_order.adjustments.sum(&:amount) +
      @simulated_order.additional_tax_total
    end

    def add_taxes
      taxes = Spree::Config.tax_calculator_class.new(@simulated_order).calculate
      line_item_taxes = taxes.line_item_taxes.select{|t| !t.included_in_price}.sum(&:amount)
      shipment_taxes = taxes.shipment_taxes.select{|t| !t.included_in_price}.sum(&:amount)

      @simulated_order.additional_tax_total = line_item_taxes + shipment_taxes
    end

    def create_shipments
      @simulated_order.create_proposed_shipments
      @simulated_order.shipments.each do |shipment|
        shipment.cost = shipment.selected_shipping_rate.cost
      end

      @simulated_order.shipment_total = @simulated_order.shipments.sum(&:amount)
    end

    def add_line_items
      @original_order.line_items.each do |line_item|
        @simulated_order.line_items << line_item.dup
      end
    end

    def build_address(address)
      country = Spree::Country.find_by(iso: address[:country_code])
      # Also adds fake information for a few fields, so validations can run
      Spree::Address.new(
        city: address[:city],
        state: country.states.find_by(abbr: address[:state]),
        state_name: address[:state],
        zipcode: address[:postal_code],
        country: country,
        address1: "123 Fake St.",
        phone: "123456789",
        firstname: "Fake"
      )
    end

  end
end

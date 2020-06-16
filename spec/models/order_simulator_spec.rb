require 'spec_helper'

RSpec.describe SolidusPaypalCommercePlatform::OrderSimulator, type: :model do
  let(:new_country) { create(:country, iso: "IT") }
  let(:new_state) { create(:state, country: new_country) }
  let(:new_address) { create(:address, country: new_country, state: new_state) }
  let(:order) { Spree::TestingSupport::OrderWalkthrough.up_to(:payment) }
  let(:shipping_rate) { create(:shipping_rate, shipping_method: shipping_method) }
  let(:shipping_method) { create(:shipping_method) }
  let(:new_tax_rate) { create(:tax_rate, amount: 100, zone: zone) }
  let(:zone) { create(:zone, name: "Whatever") }
  let(:paypal_address) {
    {
      country_code: new_country.iso,
      city: new_address.city,
      state: new_state.abbr,
      postal_code: new_address.zipcode
    }
  }

  describe "#simulate_with_address" do
    subject{ described_class.new(order).simulate_with_address(paypal_address) }

    before do
      new_tax_rate
      new_state
      zone.countries << new_country
      zone.shipping_methods = [shipping_method]
    end

    it "should duplicate the original order" do
      expect(subject.number).to eq order.number
      expect(subject.id).to eq nil
    end

    it "should duplicate original orders line_items" do
      expected_line_item_array = order.line_items.map{|li| [li.quantity, li.variant_id, li.amount]}
      expect(subject.line_items.map{ |li| [li.quantity, li.variant_id, li.amount] }).to eq expected_line_item_array
    end

    it "should replace the shipping address in the duplicated order" do
      expect(subject.ship_address.state_id).to eq new_state.id
      expect(subject.ship_address.country_id).to eq new_country.id
    end

    it "should create a new shipment" do
      expect(subject.shipments.map(&:number)).to_not eq order.shipments.map(&:number)
    end

    it "should have the correct shipping method for the new address" do
      expect(subject.shipments.first.shipping_method).to eq shipping_method
    end

    it "should create taxes based on the new address" do
      expected_tax = subject.line_items.sum{|li| li.amount * new_tax_rate.amount}
      expect(subject.additional_tax_total).to eq expected_tax
      expect(subject.additional_tax_total).not_to eq order.additional_tax_total
    end

    it "should display the correct total based on new shipping and taxes" do
      expect(subject.total).not_to eq order.total
    end
  end
end

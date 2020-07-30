require 'spec_helper'

RSpec.describe SolidusPaypalCommercePlatform::ShippingRatesController, type: :request do
  stub_authorization!
  let(:new_country) { create(:country, iso: "IT") }
  let(:new_state) { create(:state, country: new_country) }
  let(:new_address) { create(:address, country: new_country, state: new_state) }
  let(:order) { Spree::TestingSupport::OrderWalkthrough.up_to(:payment) }
  let(:paypal_address) {
    {
      country_code: new_country.iso,
      city: new_address.city,
      state: new_state.abbr,
      postal_code: new_address.zipcode
    }
  }

  describe "GET /simulate_shipping_rates" do
    before do
      get solidus_paypal_commerce_platform.shipping_rates_path, params: {
        order_id: order.number,
        address: paypal_address
      }
    end

    it "returns a paypal_order with the new address" do
      expect(response.body).to include new_address.state.abbr
      expect(response.body).not_to include order.ship_address.state.abbr
    end

    it "does not modify original address" do
      expect(order.ship_address).not_to eq new_address
    end
  end
end

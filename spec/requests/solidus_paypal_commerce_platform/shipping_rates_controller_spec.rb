require 'spec_helper'

RSpec.describe SolidusPaypalCommercePlatform::ShippingRatesController, type: :request do
  stub_authorization!
  let(:new_country) { create(:country, iso: "IT", states_required: true) }
  let(:new_state) { create(:state, country: new_country) }
  let(:new_address) { build(:address, country: new_country, state: new_state) }
  let(:order) { Spree::TestingSupport::OrderWalkthrough.up_to(:payment) }
  let(:paypal_address) {
    {
      country_code: new_country.iso,
      city: new_address.city,
      state: new_state&.abbr,
      postal_code: new_address.zipcode
    }
  }

  describe "GET /simulate_shipping_rates" do
    before do
      get solidus_paypal_commerce_platform.shipping_rates_path, params: {
        order_id: order.number,
        address: paypal_address
      }, headers: basic_auth_header
    end

    it "returns a paypal_order without the simulated address" do
      expect(response.body).not_to include "admin_area_1\":\"#{new_address.state.abbr}\""
      expect(response.body).not_to include "admin_area_1\":\"#{order.ship_address.state.abbr}\""
    end

    it "does not modify original address" do
      expect(order.ship_address).not_to eq new_address
    end

    context "with an invalid address" do
      let(:new_state) { nil }

      it "returns a list of errors" do
        expect(response.status).to be(422) # unprocessable_entity
        expect(response.body).to include "State can't be blank"
      end
    end
  end
end

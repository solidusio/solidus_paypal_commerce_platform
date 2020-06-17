require 'spec_helper'

RSpec.describe SolidusPaypalCommercePlatform::PaypalAddress, type: :model do
  let(:order) { create(:order_with_line_items, ship_address: original_address) }
  let(:original_address) { create(:address) }
  let(:address) { create(:address) }

  describe "#update_address" do
    it "should format PayPal addresses correctly" do
      paypal_address = {
        admin_area_1: address.state.abbr,
        admin_area_2: address.city,
        address_line_1: address.address1,
        address_line_2: address.address2,
        postal_code: address.zipcode, 
        country_code: address.country.iso
      }

      SolidusPaypalCommercePlatform::PaypalAddress.new(order).update_address(paypal_address)

      expect(order.reload.ship_address.state).to eq address.state
      expect(order.reload.ship_address.city).to eq address.city
      expect(order.reload.ship_address.address1).to eq address.address1
      expect(order.reload.ship_address.address2).to eq address.address2
      expect(order.reload.ship_address.zipcode).to eq address.zipcode
      expect(order.reload.ship_address.country).to eq address.country
    end
  end
end

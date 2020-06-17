require 'spec_helper'

RSpec.describe SolidusPaypalCommercePlatform::PaypalAddress, type: :model do
  let(:order) { create(:order_with_line_items, ship_address: original_address) }
  let(:original_address) { create(:address) }
  let(:address) { create(:address) }

  describe "#update_address" do
    subject{ order.ship_address }

    it "should format PayPal addresses correctly" do
      paypal_address = {
        admin_area_1: address.state.abbr,
        admin_area_2: address.city,
        address_line_1: address.address1,
        address_line_2: address.address2,
        postal_code: address.zipcode, 
        country_code: address.country.iso
      }

      SolidusPaypalCommercePlatform::PaypalAddress.new(order).update(paypal_address)

      expect(subject.state).to eq address.state
      expect(subject.city).to eq address.city
      expect(subject.address1).to eq address.address1
      expect(subject.address2).to eq address.address2
      expect(subject.zipcode).to eq address.zipcode
      expect(subject.country).to eq address.country
    end
  end
end

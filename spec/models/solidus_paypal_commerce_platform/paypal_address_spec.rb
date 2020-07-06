require 'spec_helper'

RSpec.describe SolidusPaypalCommercePlatform::PaypalAddress, type: :model do
  let(:order) { create(:order) }
  let(:original_address) { create(:address) }
  let(:address) { create(:address) }
  let(:params) {
    {
      updated_address: {
        admin_area_1: address.state.abbr,
        admin_area_2: address.city,
        address_line_1: address.address1,
        address_line_2: address.address2,
        postal_code: address.zipcode,
        country_code: address.country.iso
      },
      recipient: {
        name: {
          given_name: address.firstname,
          surname: address.lastname
        }
      }
    }
  }

  describe "#update_address" do
    subject{ order.ship_address }

    it "formats PayPal addresses correctly" do
      order.ship_address = original_address

      described_class.new(order).update(params)

      expect(subject.state).to eq address.state
      expect(subject.city).to eq address.city
      expect(subject.address1).to eq address.address1
      expect(subject.address2).to eq address.address2
      expect(subject.zipcode).to eq address.zipcode
      expect(subject.country).to eq address.country
      expect(subject.firstname).to eq address.firstname
      expect(subject.lastname).to eq address.lastname
      expect(subject.phone).to eq original_address.phone
    end

    context "when no address exists" do
      it "produce a valid address" do
        order.ship_address = nil

        described_class.new(order).update(params)

        expect(subject).to be_present
      end
    end
  end
end

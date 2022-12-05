require 'solidus_paypal_commerce_platform_spec_helper'

RSpec.describe SolidusPaypalCommercePlatform::PaypalAddress, type: :model do
  let(:order) { create(:order) }
  let(:original_address) { create(:address) }
  let(:address) { create(:address, name_attributes) }
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
          given_name: "Alexander",
          surname: "Hamilton"
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
      if SolidusSupport.combined_first_and_last_name_in_address?
        expect(subject.name).to eq address.name
      else
        expect(subject.firstname).to eq address.firstname
        expect(subject.lastname).to eq address.lastname
      end
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

  def name_attributes
    if SolidusSupport.combined_first_and_last_name_in_address?
      { name: "Alexander Hamilton" }
    else
      { firstname: "Alexander", lastname: "Hamilton" }
    end
  end
end

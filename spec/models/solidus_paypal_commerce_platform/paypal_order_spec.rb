# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusPaypalCommercePlatform::PaypalOrder, type: :model do
  describe '#to_json' do
    subject(:to_json) { described_class.new(order).to_json('intent') }

    let(:order) { create(:order_ready_to_complete) }

    it { expect { to_json }.not_to raise_error }

    if Spree.solidus_gem_version >= Gem::Version.new('2.11')
      it 'returns the name of the user' do
        expect(to_json).to match hash_including(
          purchase_units: array_including(
            hash_including(shipping: hash_including(name: { full_name: 'John Von Doe' }))
          ),
          payer: hash_including(name: { given_name: 'John', surname: 'Von Doe' })
        )
      end
    else
      it 'returns the name and surname of the user' do
        expect(to_json).to match hash_including(
          purchase_units: array_including(
            hash_including(shipping: hash_including(name: { full_name: 'John' }))
          ),
          payer: hash_including(name: { given_name: 'John', surname: nil })
        )
      end
    end
  end
end

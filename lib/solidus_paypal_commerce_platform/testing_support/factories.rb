# frozen_string_literal: true

FactoryBot.define do
  factory :paypal_payment_method, class: 'SolidusPaypalCommercePlatform::PaymentMethod' do
    type { "SolidusPaypalCommercePlatform::PaymentMethod" }
    name { "PayPal Payment Method" }
    preferences {
      {
        client_id: SecureRandom.hex(8),
        client_secret: SecureRandom.hex(10),
        venmo_standalone: 'disabled'
      }
    }
  end
end

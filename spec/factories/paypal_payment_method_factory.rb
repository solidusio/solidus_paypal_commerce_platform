# frozen_string_literal: true

FactoryBot.define do
  factory :paypal_payment_method, class: 'SolidusPaypalCommercePlatform::Gateway' do
    type { "SolidusPaypalCommercePlatform::Gateway" }
    name { "PayPal Payment Method" }
    preferences { 
      { 
        client_id: SecureRandom.hex(8),
        client_secret: SecureRandom.hex(10) 
      } 
    }
  end
end
# frozen_string_literal: true

module SolidusPaypalCommercePlatform
  class PricingOptions < Spree::Variant::PricingOptions
    def cache_key
      SolidusPaypalCommercePlatform::PaymentMethod.active.map(&:cache_key).sort + [super]
    end
  end
end

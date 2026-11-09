# frozen_string_literal: true

module SolidusPaypalCommercePlatform
  module Spree
    module Variant
      module PricingOptionsPatch
        def cache_key
          SolidusPaypalCommercePlatform::PaymentMethod.
            active.
            map(&:cache_key_with_version).
            sort + [super]
        end

        ::Spree::Variant::PricingOptions.prepend self
      end
    end
  end
end

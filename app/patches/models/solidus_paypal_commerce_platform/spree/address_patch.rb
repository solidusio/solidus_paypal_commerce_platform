# frozen_string_literal: true

module SolidusPaypalCommercePlatform
  module Spree
    module AddressPatch
      # PayPal doesn't use the phone number, so in cases where the user checks out via
      # PayPal, this field will be unpopulated. If you want to require phone numbers,
      # you'll need to turn off cart & product page displays on the payment method edit
      # page.
      def require_phone?
        super && false
      end

      ::Spree::Address.prepend self
    end
  end
end

# frozen_string_literal: true

require 'securerandom'

module SolidusPaypalCommercePlatform
  class Wizard
    def name
      I18n.t('start_paying_with_paypal')
    end

    def partial_name
      '/solidus_paypal_commerce_platform/admin/payment_methods/paypal_wizard'
    end

    def button_url
      parameters = {
        product: "addipmt",
        partnerId: SolidusPaypalCommercePlatform.config.partner_id,
        partnerClientId: SolidusPaypalCommercePlatform.config.partner_client_id,
        features: "PAYMENT,REFUND",
        partnerLogoUrl: logo,
        integrationType: "FO",
        displayMode: "minibrowser",
        sellerNonce: nonce,
      }

      URI("https://#{SolidusPaypalCommercePlatform.config.env_domain}/bizsignup/partner/entry?#{parameters.to_query}")
    end

    def nonce
      @nonce ||= SecureRandom.alphanumeric(128)
    end

    private

    def logo
      ActionController::Base.helpers.image_path(::Spree::Config[:admin_interface_logo])
    end
  end
end

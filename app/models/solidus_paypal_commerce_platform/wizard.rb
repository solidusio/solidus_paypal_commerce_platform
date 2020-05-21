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
        partnerId: "5LQZV7RJDGKG2",
        partnerClientId: "ATDpQjHzjCz_C_qbbJ76Ca0IjcmwlS4FztD6YfuRFZXDCmcWWw8-8QWcF3YIkbC85ixTUuuSEvrBMVSX",
        features: "PAYMENT,REFUND",
        partnerLogoUrl: logo,
        integrationType:"FO",
        displayMode:"minibrowser",
        sellerNonce:"0fb0e3e75e3deb58de8fb4e8dc27eb25ab2cbcabdb84"
      }

      URI("https://www.sandbox.paypal.com/bizsignup/partner/entry?"+parameters.to_query)
    end

    private

    def logo
      ActionController::Base.helpers.image_url(Spree::Config[:admin_interface_logo])
    end

  end
end

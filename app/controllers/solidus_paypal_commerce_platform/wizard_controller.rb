require 'paypal-checkout-sdk'

module SolidusPaypalCommercePlatform
  class WizardController < ::Spree::Api::BaseController
    helper ::Spree::Core::Engine.routes.url_helpers

    def create
      authorize! :create, Spree::PaymentMethod

      @payment_method = Spree::PaymentMethod.new(payment_method_params)

      if @payment_method.save
        edit_url = spree.edit_admin_payment_method_url(@payment_method)

        render(
          json: {redirectUrl: edit_url},
          status: :created,
          location: edit_url,
          notice: "The PayPal Commerce Platform payment method has been successfully created"
        )
      else
        render json: @payment_method.errors, status: :unprocessable_entity
      end
    end

    private

    def use_sandbox?
      !Rails.env.production?
    end

    def payment_method_params
      {
        name: "PayPal Commerce Platform",
        type: SolidusPaypalCommercePlatform::Gateway,
        preferred_client_id: api_credentials.client_id,
        preferred_client_secret: api_credentials.client_secret,
        preferred_test_mode: use_sandbox?
      }
    end

    def api_credentials
      @api_credentials ||= begin
        paypal_env_class = use_sandbox? ? PayPal::SandboxEnvironment : PayPal::LiveEnvironment
        paypal_env = paypal_env_class.new(params.fetch(:sharedId), nil)
        paypal_client = SolidusPaypalCommercePlatform::Requests.new(paypal_env)

        paypal_client.trade_tokens(params)
      end
    end
  end
end

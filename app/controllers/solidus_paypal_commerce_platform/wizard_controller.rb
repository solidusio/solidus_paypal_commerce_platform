module SolidusPaypalCommercePlatform
  class WizardController < ::Spree::Api::BaseController
    helper ::Spree::Core::Engine.routes.url_helpers

    def create
      authorize! :create, Spree::PaymentMethod

      @payment_method = Spree::PaymentMethod.new(payment_method_params)

      if @payment_method.save
        flash[:success] = "The PayPal Commerce Platform payment method has been successfully created"
        render json: {
          redirectUrl: spree.edit_admin_payment_method_url(@payment_method.id)
        }, status: :ok
      else
        render json: {}, status: 500
      end
    end

    private

    def payment_method_params
      {
        name: "PayPal Commerce Platform",
        type: SolidusPaypalCommercePlatform::Gateway,
        preferred_client_id: api_credentials.client_id,
        preferred_client_secret: api_credentials.client_secret,
        preferred_test_mode: !Rails.env.production?
      }
    end

    def api_credentials
      @api_credentials ||= begin
        paypal_env = PayPal::SandboxEnvironment.new(credentials[:sharedId])
        paypal_client = SolidusPaypalCommercePlatform::Requests.new(paypal_env)

        paypal_client.trade_tokens(params)
      end
    end
  end
end

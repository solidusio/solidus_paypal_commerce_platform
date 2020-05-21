module SolidusPaypalCommercePlatform
  class WizardController < ::Spree::Api::BaseController
    helper ::Spree::Core::Engine.routes.url_helpers

    def create
      authorize! :create, Spree::PaymentMethod
      api_credentials = fetch_api_credentials(params)
      if payment_method = create_payment_method(api_credentials)
        flash[:success] = "The PayPal Commerce Platform payment method has been successfully created"
        render json: {
          redirectUrl: spree.edit_admin_payment_method_url(payment_method.id)
        }, status: :ok
      else
        render json: {}, status: 500
      end
    end

    private

    def fetch_api_credentials(credentials)
      SolidusPaypalCommercePlatform::Requests.new(credentials[:sharedId]).trade_tokens(credentials)
    end

    def create_payment_method(api_credentials)
      return false unless api_credentials
      Spree::PaymentMethod.create(
        name: "PayPal Commerce Platform",
        type: SolidusPaypalCommercePlatform::Gateway,
        preferences: {
          client_id: api_credentials.client_id,
          client_secret: api_credentials.client_secret,
          test_mode: !(Rails.env == "production")
        }
      )
    end

  end
end

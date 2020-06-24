# frozen_string_literal: true

module SolidusPaypalCommercePlatform
  class PaypalOrdersController < ::Spree::Api::BaseController
    before_action :load_payment_method
    skip_before_action :authenticate_user

    def show
      authorize! :show, @order, order_token
      render json: @payment_method.gateway.create_order(@order, @payment_method.auto_capture), status: :ok
    end

    private

    def load_payment_method
      @payment_method = ::Spree::PaymentMethod.find(params[:payment_method_id])
    end
  end
end

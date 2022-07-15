# frozen_string_literal: true

module SolidusPaypalCommercePlatform
  class PaypalOrdersController < ::Spree::Api::BaseController
    before_action :load_order
    before_action :load_payment_method
    skip_before_action :authenticate_user

    def show
      authorize! :show, @order, order_token
      order_request = @payment_method.gateway.create_order(@order, @payment_method.auto_capture)

      render json: order_request, status: order_request.status_code
    end

    def update
      authorize! :update, @order, order_token
      source = @payment_method.payments.try(:last).try(:source)
      order_request = @payment_method.gateway.update_order(@order, source)

      render json: order_request, status: order_request.status_code
    end

    private

    def load_order
      @order = ::Spree::Order.find_by!(number: params[:order_id])
    end

    def load_payment_method
      @payment_method = ::Spree::PaymentMethod.find(params[:payment_method_id])
    end
  end
end

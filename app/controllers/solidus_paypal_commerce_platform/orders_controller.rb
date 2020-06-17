module SolidusPaypalCommercePlatform
  class OrdersController < ::Spree::Api::BaseController
    before_action :load_order
    before_action :load_payment_method, only: :create
    skip_before_action :authenticate_user

    def create
      authorize! :update, @order, order_token
      render json: @payment_method.gateway.create_order(@order, @payment_method.auto_capture), status: :ok
    end

    def update_address
      authorize! :update, @order, order_token
      address = SolidusPaypalCommercePlatform::PaypalAddress.new(@order).update_address(params[:address])
      if address.errors.any?
        render json: address.errors.full_messages, status: :unprocessable_entity
      else
        render json: {}, status: :ok
      end
    end

    private

    def load_order
      @order = Spree::Order.find_by!(number: params[:order_id])
    end

    def load_payment_method
      @payment_method = Spree::PaymentMethod.find(params[:payment_method_id])
    end

  end
end

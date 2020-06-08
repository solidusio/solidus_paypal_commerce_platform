module SolidusPaypalCommercePlatform
  class OrdersController < ::Spree::Api::BaseController
    before_action :load_order
    before_action :load_payment_method
    skip_before_action :authenticate_user

    def create
      authorize! :update, @order, order_token
      @payment_method.request.create_order(@order, @payment_method.auto_capture)
      render json: request, status: :ok
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

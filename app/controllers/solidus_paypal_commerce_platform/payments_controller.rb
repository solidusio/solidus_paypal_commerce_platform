module SolidusPaypalCommercePlatform
  class PaymentsController < ::Spree::Api::BaseController
    before_action :load_order
    skip_before_action :authenticate_user

    def create
      authorize! :update, @order, order_token
      paypal_order_id = paypal_params[:paypal_order_id]

      if !paypal_order_id
        return redirect_to checkout_state_path(@order.state), notice: "Invalid order confirmation data passed in"
      end

      if @order.complete?
        return redirect_to spree.order_path(@order), notice: "Order is already in complete state"
      end

      source = SolidusPaypalCommercePlatform::PaymentSource.new(paypal_order_id: paypal_order_id)

      source.transaction do
        if source.save!
          payment = @order.payments.create!({
            payment_method_id: paypal_params[:payment_method_id],
            source: source
          })

          render json: {}, status: :ok
        end
      end
    end

    private

    def paypal_params
      params.permit(:paypal_order_id, :order_id, :order_token, :payment_method_id)
    end

    def load_order
      @order = Spree::Order.find_by!(number: params[:order_id])
    end

  end
end

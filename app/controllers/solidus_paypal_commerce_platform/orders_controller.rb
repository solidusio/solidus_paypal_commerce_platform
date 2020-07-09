# frozen_string_literal: true

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
      paypal_address = SolidusPaypalCommercePlatform::PaypalAddress.new(@order)

      if paypal_address.update(paypal_address_params).valid?
        render json: {}, status: :ok
      else
        render json: paypal_address.errors.full_messages, status: :unprocessable_entity
      end
    end

    def verify_total
      authorize! :show, @order, order_token

      if total_is_correct?(params[:paypal_total])
        render json: {}, status: :ok
      else
        respond_with(@order, default_template: 'spree/api/orders/expected_total_mismatch', status: 400)
      end
    end

    private

    def total_is_correct?(paypal_total)
      @order.outstanding_balance == BigDecimal(paypal_total)
    end

    def paypal_address_params
      params.require(:address).permit(
        updated_address: [
          :address_line_1,
          :address_line_2,
          :admin_area_1,
          :admin_area_2,
          :postal_code,
          :country_code,
        ],
        recipient: [
          :email_address,
          name: [
            :given_name,
            :surname,
          ]
        ]
      )
    end

    def load_order
      @order = ::Spree::Order.find_by!(number: params[:order_id])
    end

    def load_payment_method
      @payment_method = ::Spree::PaymentMethod.find(params[:payment_method_id])
    end
  end
end

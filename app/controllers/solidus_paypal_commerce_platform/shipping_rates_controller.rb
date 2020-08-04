# frozen_string_literal: true

module SolidusPaypalCommercePlatform
  class ShippingRatesController < ::Spree::Api::BaseController
    before_action :load_order
    skip_before_action :authenticate_user

    def simulate_shipping_rates
      authorize! :show, @order, order_token

      @order.transaction do
        SolidusPaypalCommercePlatform::PaypalAddress.new(@order).simulate_update(params[:address])
        @paypal_order = SolidusPaypalCommercePlatform::PaypalOrder.new(@order).to_replace_json
        raise ActiveRecord::Rollback
      end

      render json: @paypal_order, status: :ok
    end

    private

    def load_order
      @order = ::Spree::Order.find_by(number: params[:order_id])
    end
  end
end

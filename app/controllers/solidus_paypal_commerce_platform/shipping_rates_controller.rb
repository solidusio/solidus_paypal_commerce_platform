# frozen_string_literal: true

module SolidusPaypalCommercePlatform
  class ShippingRatesController < ::Spree::Api::BaseController
    before_action :load_order
    skip_before_action :authenticate_user

    def simulate_shipping_rates
      authorize! :show, @order, order_token
      order_simulator = SolidusPaypalCommercePlatform::OrderSimulator.new(@order)
      simulated_order = order_simulator.simulate_with_address(params[:address])

      if simulated_order.ship_address.valid?
        render json: SolidusPaypalCommercePlatform::PaypalOrder.new(simulated_order).to_replace_json, status: :ok
      else
        render json: simulated_order.ship_address.errors.full_messages, status: :unprocessable_entity
      end
    end

    private

    def load_order
      @order = Spree::Order.find_by(number: params[:order_id])
    end
  end
end

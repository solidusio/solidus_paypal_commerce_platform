module SolidusPaypalCommercePlatform
  class ShippingRatesController < ::Spree::Api::BaseController
    before_action :load_order
    skip_before_action :authenticate_user

    def simulate_shipping_rates
      authorize! :show, @order, order_token
      simulated_order = SolidusPaypalCommercePlatform::OrderSimulator.new(@order).simulate_with_address(params[:address])
      
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

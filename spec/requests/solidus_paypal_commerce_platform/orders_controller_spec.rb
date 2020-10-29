require 'spec_helper'

RSpec.describe SolidusPaypalCommercePlatform::OrdersController, type: :request do
  stub_authorization!
  let(:order) { create(:order_with_line_items) }
  let(:auth_headers) {
    ENV['BASIC_AUTH'].present? ? { 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(ENV['BASIC_AUTH'].split(':')[0], ENV['BASIC_AUTH'].split(':')[1]) } : {}
  }

  describe "GET /solidus_paypal_commerce_platform/verify_total" do
    context "when the amount is correct" do
      it "passes" do
        params = {
          order_id: order.number,
          paypal_total: order.total,
          format: :json
        }

        get solidus_paypal_commerce_platform.verify_total_path, params: params, headers: auth_headers

        expect(response).to have_http_status(200)
      end
    end

    context "when the amount is incorrect" do
      it "fails" do
        params = {
          order_id: order.number,
          paypal_total: order.total - 1,
          format: :json
        }

        get solidus_paypal_commerce_platform.verify_total_path, params: params, headers: auth_headers

        expect(response).to have_http_status(400)
      end
    end
  end
end

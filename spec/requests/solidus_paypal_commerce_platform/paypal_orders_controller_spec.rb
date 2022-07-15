require 'spec_helper'

RSpec.describe SolidusPaypalCommercePlatform::PaypalOrdersController, type: :request do
  stub_authorization!
  let(:order) { create(:order_with_line_items) }
  let(:paypal_order_id) { SecureRandom.uuid }
  let(:capture_id) { SecureRandom.uuid }
  let(:refund_id) { SecureRandom.uuid }
  let(:paypal_payment_method) { create(:paypal_payment_method) }
  let(:payment_source) do
    SolidusPaypalCommercePlatform::PaymentSource.new(
      paypal_order_id: paypal_order_id,
      capture_id: capture_id,
      refund_id: refund_id,
      payment_method: create(:paypal_payment_method)
    )
  end
  let(:payment) do
    order.payments.create!(
      payment_method: payment_source.payment_method,
      source: payment_source,
    )
  end
  let(:response) do
    Struct(
      result: nil,
      headers: {},
      status_code: 200
    )
  end
  let(:error_response) do
    Struct(
      result: nil,
      headers: {},
      status_code: 401
    )
  end

  def Struct(data) # rubocop:disable Naming/MethodName
    Struct.new(*data.keys, keyword_init: true).new(data)
  end

  describe 'GET /solidus_paypal_commerce_platform/paypal_orders' do
    context 'when is correct' do
      before do
        allow_any_instance_of(PayPal::PayPalHttpClient)
          .to receive(:execute) { response }
        allow_any_instance_of(SolidusPaypalCommercePlatform::Client)
          .to receive(:execute) { response }
      end

      it 'passes' do
        get "/solidus_paypal_commerce_platform/paypal_orders/#{order.number}"

        expect(response.status_code).to be(200)
      end
    end

    context 'when is incorrect' do
      before do
        allow_any_instance_of(PayPal::PayPalHttpClient)
          .to receive(:execute) { error_response }
        allow_any_instance_of(SolidusPaypalCommercePlatform::Client)
          .to receive(:execute) { error_response }
      end

      it 'fails' do
        get "/solidus_paypal_commerce_platform/paypal_orders/#{order.number}"

        expect(error_response.status_code).to be(401)
      end
    end
  end

  describe 'PUT /solidus_paypal_commerce_platform/paypal_orders' do
    context 'when is correct' do
      before do
        allow_any_instance_of(PayPal::PayPalHttpClient)
          .to receive(:execute) { response }
        allow_any_instance_of(SolidusPaypalCommercePlatform::Client)
          .to receive(:execute) { response }
      end

      it 'passes' do
        params = {
          payment_method_id: payment.payment_method.id,
          format: :json
        }

        put "/solidus_paypal_commerce_platform/paypal_orders/#{order.number}",
            params: params

        expect(response.status_code).to be(200)
      end
    end

    context 'when is incorrect' do
      before do
        allow_any_instance_of(PayPal::PayPalHttpClient)
          .to receive(:execute) { error_response }
        allow_any_instance_of(SolidusPaypalCommercePlatform::Client)
          .to receive(:execute) { error_response }
      end

      it 'fails' do
        params = {
          payment_method_id: payment.payment_method.id,
          format: :json
        }

        put "/solidus_paypal_commerce_platform/paypal_orders/#{order.number}",
            params: params

        expect(error_response.status_code).to be(401)
      end
    end
  end
end

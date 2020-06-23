require 'spec_helper'

RSpec.describe SolidusPaypalCommercePlatform::PaymentMethod, type: :model do
  let(:paypal_payment_method) { create(:paypal_payment_method) }
  let(:payment) { create(:payment) }
  let(:completed_payment) { create(:payment, :completed)}

  before do
    response = OpenStruct.new(
      status_code: 201,
      result: OpenStruct.new(
        id: SecureRandom.hex(4),
        purchase_units: [
          OpenStruct.new(
            payments: OpenStruct.new(
              authorizations: [
                OpenStruct.new(id: SecureRandom.hex(4))
              ],
              captures: [
                OpenStruct.new(id: SecureRandom.hex(4))
              ]
            )
          )
        ]
      )
    )

    allow_any_instance_of(PayPal::PayPalHttpClient).to receive(:execute) { response }
  end

  describe "#purchase" do
    it "should send a purchase request to paypal" do
      paypal_order_id = SecureRandom.hex(8)
      source = paypal_payment_method.payment_source_class.create(paypal_order_id: paypal_order_id)
      expect(SolidusPaypalCommercePlatform::Gateway::OrdersCaptureRequest).to receive(:new).with(paypal_order_id)
      paypal_payment_method.purchase(1000,source,{})
    end
  end

  describe "#authorize" do
    it "should send an authorize request to paypal" do
      paypal_order_id = SecureRandom.hex(8)
      source = paypal_payment_method.payment_source_class.create(paypal_order_id: paypal_order_id)
      expect(SolidusPaypalCommercePlatform::Gateway::OrdersAuthorizeRequest).to receive(:new).with(paypal_order_id)
      paypal_payment_method.authorize(1000,source,{})
    end
  end

  describe "#capture" do
    it "should send a capture request to paypal" do
      authorization_id = SecureRandom.hex(8)
      source = paypal_payment_method.payment_source_class.create(authorization_id: authorization_id)
      payment.source = source
      expect(SolidusPaypalCommercePlatform::Gateway::AuthorizationsCaptureRequest).to receive(:new).with(authorization_id)
      paypal_payment_method.capture(1000,{},{originator: payment})
    end
  end

  describe "#void" do
    it "should send a void request to paypal" do
      authorization_id = SecureRandom.hex(8)
      source = paypal_payment_method.payment_source_class.create(authorization_id: authorization_id)
      payment.source = source
      expect(SolidusPaypalCommercePlatform::Gateway::AuthorizationsVoidRequest).to receive(:new).with(authorization_id)
      paypal_payment_method.void(nil, {originator: payment})
    end
  end

  describe "#credit" do
    it "should send a refund request to paypal" do
      capture_id = SecureRandom.hex(4)
      source = paypal_payment_method.payment_source_class.create(capture_id: capture_id)
      completed_payment.source = source
      expect(SolidusPaypalCommercePlatform::Gateway::CapturesRefundRequest).to receive(:new).with(capture_id).and_call_original
      paypal_payment_method.credit(1000, {}, {originator: completed_payment.refunds.new(amount: 12)})
    end
  end

  describe '.javascript_sdk_url' do
    subject(:url) { URI(paypal_payment_method.javascript_sdk_url(order: order)) }

    context 'when checkout_steps include "confirm"' do
      let(:order) { double("order", checkout_steps: {"confirm" => "bar"}) }

      it 'sets autocommit' do
        expect(url.query.split("&")).to include("commit=false")
      end
    end

    context 'when checkout_steps does not include "confirm"' do
      let(:order) { double("order", checkout_steps: {"foo" => "bar"}) }

      it 'disables autocommit' do
        expect(url.query.split("&")).to include("commit=true")
      end
    end
  end
end

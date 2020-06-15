require 'spec_helper'
require 'paypal-checkout-sdk'

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
    allow_any_instance_of(PayPal::SandboxEnvironment).to receive(:authorizationString) { "test auth" }
  end

  describe "#purchase" do
    it "should send a purchase request to paypal" do
      paypal_order_id = SecureRandom.hex(8)
      source = paypal_payment_method.payment_source_class.create(paypal_order_id: paypal_order_id)
      request = {
        path: "/v2/checkout/orders/#{paypal_order_id}/capture",
        headers: {
          "Content-Type" => "application/json",
          "Authorization" => "test auth",
          "PayPal-Partner-Attribution-Id" => "Solidus_PCP_SP",
        },
        verb: "POST"
      }
      expect(SolidusPaypalCommercePlatform::Gateway::Request).to receive(:new).with(request)
      paypal_payment_method.purchase(1000,source,{})
    end
  end

  describe "#authorize" do
    it "should send an authorize request to paypal" do
      paypal_order_id = SecureRandom.hex(8)
      source = paypal_payment_method.payment_source_class.create(paypal_order_id: paypal_order_id)
      request = {
        path: "/v2/checkout/orders/#{paypal_order_id}/authorize",
        headers: {
          "Content-Type" => "application/json",
          "Authorization" => "test auth",
          "PayPal-Partner-Attribution-Id" => "Solidus_PCP_SP",
        },
        verb: "POST"
      }
      expect(SolidusPaypalCommercePlatform::Gateway::Request).to receive(:new).with(request)
      paypal_payment_method.authorize(1000,source,{})
    end
  end

  describe "#capture" do
    it "should send a capture request to paypal" do
      authorization_id = SecureRandom.hex(8)
      source = paypal_payment_method.payment_source_class.create(authorization_id: authorization_id)
      payment.source = source
      request = {
        path: "/v2/payments/authorizations/#{authorization_id}/capture",
        headers: {
          "Content-Type" => "application/json",
          "Authorization" => "test auth",
          "PayPal-Partner-Attribution-Id" => "Solidus_PCP_SP",
        },
        verb: "POST"
      }
      expect(SolidusPaypalCommercePlatform::Gateway::Request).to receive(:new).with(request)
      paypal_payment_method.capture(1000,{},{originator: payment})
    end
  end

  describe "#void" do
    it "should send a void request to paypal" do
      authorization_id = SecureRandom.hex(8)
      source = paypal_payment_method.payment_source_class.create(authorization_id: authorization_id)
      payment.source = source
      request = {
        path: "/v2/payments/authorizations/#{authorization_id}/void",
        headers: {
          "Content-Type" => "application/json",
          "Authorization" => "test auth",
        },
        verb: "POST"
      }

      expect(SolidusPaypalCommercePlatform::Gateway::Request).to receive(:new).with(request)

      paypal_payment_method.void(nil,{originator: payment})
    end
  end

  describe "#refund" do
    it "should send a refund request to paypal" do
      capture_id = SecureRandom.hex(4)
      source = paypal_payment_method.payment_source_class.create(capture_id: capture_id)
      completed_payment.source = source
      request = {
        path: "/v2/payments/captures/#{capture_id}/refund",
        body: {
          amount: {
            currency_code: "USD",
            value: 0.12e2
          }
        },
        headers: {
          "Content-Type" => "application/json",
          "Authorization" => "test auth"
        },
        verb: "POST"
      }

      expect(SolidusPaypalCommercePlatform::Gateway::Request).to receive(:new).with(request)

      paypal_payment_method.credit(1000,{},{originator: completed_payment.refunds.new(amount:12)})
    end
  end
end

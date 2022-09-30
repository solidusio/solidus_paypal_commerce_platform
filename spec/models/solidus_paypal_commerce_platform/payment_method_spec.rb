require 'spec_helper'

RSpec.describe SolidusPaypalCommercePlatform::PaymentMethod, type: :model do
  let(:paypal_payment_method) { create(:paypal_payment_method) }
  let(:payment) { create(:payment) }
  let(:completed_payment) { create(:payment, :completed) }
  let(:response) { Struct(status_code: status_code, result: result, headers: headers) }
  let(:status_code) { 201 }
  let(:result) { nil }
  let(:headers) { {} }

  def Struct(data) # rubocop:disable Naming/MethodName
    Struct.new(*data.keys, keyword_init: true).new(data)
  end

  before { allow_any_instance_of(PayPal::PayPalHttpClient).to receive(:execute) { response } }

  describe 'preferences' do
    context 'with paypal_button_color' do
      before do
        paypal_payment_method.preferences.update(paypal_button_color: 'gold')
        paypal_payment_method.save
      end

      it 'cannot be gold when Venmo standalone is enabled' do
        expect(paypal_payment_method).to be_valid
        paypal_payment_method.preferences.update(venmo_standalone: 'enabled')
        expect(paypal_payment_method).to be_invalid
        paypal_payment_method.preferences.update(venmo_standalone: 'only render standalone')
        expect(paypal_payment_method).to be_invalid
      end
    end
  end

  describe "#purchase" do
    let(:result) { Struct(purchase_units: [Struct(payments: payments)]) }
    let(:payments) { Struct(captures: [Struct(id: SecureRandom.hex(4))]) }

    it "sends a purchase request to paypal" do # rubocop:disable Rspec/NoExpectationExample
      paypal_order_id = SecureRandom.hex(8)
      source = paypal_payment_method.payment_source_class.create(paypal_order_id: paypal_order_id)
      expect_request(:OrdersCaptureRequest).to receive(:new).with(paypal_order_id).and_call_original
      paypal_payment_method.purchase(1000, source, {})
    end
  end

  describe "#authorize" do
    let(:result) { Struct(purchase_units: [Struct(payments: payments)]) }
    let(:payments) { Struct(authorizations: [Struct(id: SecureRandom.hex(4))]) }

    it "sends an authorize request to paypal" do # rubocop:disable Rspec/NoExpectationExample
      paypal_order_id = SecureRandom.hex(8)
      source = paypal_payment_method.payment_source_class.create(paypal_order_id: paypal_order_id)
      expect_request(:OrdersAuthorizeRequest).to receive(:new).with(paypal_order_id)
      paypal_payment_method.authorize(1000, source, {})
    end
  end

  describe "#capture" do
    let(:result) { Struct(id: SecureRandom.hex(4), status: status) }

    context "when payment COMPLETED" do
      let(:status) { "COMPLETED" }

      it "sends a capture request to paypal" do
        authorization_id = SecureRandom.hex(8)
        source = paypal_payment_method.payment_source_class.create(authorization_id: authorization_id)
        payment.source = source
        expect_request(:AuthorizationsCaptureRequest).to receive(:new).with(authorization_id).and_call_original
        billing_response = paypal_payment_method.capture(1000, {}, originator: payment)
        expect(billing_response.message).to eq("Authorization captured")
      end
    end

    context "when payment PENDING" do
      let(:status) { "PENDING" }

      it "sends a capture request to paypal" do
        authorization_id = SecureRandom.hex(8)
        source = paypal_payment_method.payment_source_class.create(authorization_id: authorization_id)
        payment.source = source
        expect_request(:AuthorizationsCaptureRequest).to receive(:new).with(authorization_id).and_call_original
        billing_response = paypal_payment_method.capture(1000, {}, originator: payment)
        expect(billing_response.message).to eq("Payment is awaiting processing on PayPal's side")
      end
    end
  end

  describe "#void" do
    it "sends a void request to paypal" do # rubocop:disable Rspec/NoExpectationExample
      authorization_id = SecureRandom.hex(8)
      source = paypal_payment_method.payment_source_class.create(authorization_id: authorization_id)
      payment.source = source
      expect_request(:AuthorizationsVoidRequest).to receive(:new).with(authorization_id)
      paypal_payment_method.void(nil, originator: payment)
    end
  end

  describe "#credit" do
    let(:result) { Struct(id: SecureRandom.hex(4)) }

    it "sends a refund request to paypal" do
      capture_id = SecureRandom.hex(4)
      source = paypal_payment_method.payment_source_class.create(capture_id: capture_id)
      completed_payment.source = source
      expect_request(:CapturesRefundRequest).to receive(:new).with(capture_id).and_call_original
      paypal_payment_method.credit(1000, {}, originator: completed_payment.refunds.new(amount: 12))
      expect(source.refund_id).not_to be_blank
    end
  end

  describe '.javascript_sdk_url' do
    subject(:url) { URI(paypal_payment_method.javascript_sdk_url(order: order)) }

    let(:order) { build_stubbed(:order) }

    context 'when checkout_steps include "confirm"' do
      it 'sets autocommit' do
        expect(url.query.split("&")).to include("commit=false")
      end
    end

    context 'when checkout_steps does not include "confirm"' do
      it 'disables autocommit' do
        allow(order).to receive(:checkout_steps).and_return([:address, :delivery, :payment])
        expect(url.query.split("&")).to include("commit=true")
      end
    end

    context 'when checkout_steps does not include "delivery"' do
      it 'disables autocommit' do
        allow(order).to receive(:checkout_steps).and_return([:address, :confirm, :payment])
        expect(url.query.split("&")).to include("shipping_preference=NO_SHIPPING")
      end
    end

    context 'when messaging is turned on' do
      it 'includes messaging component' do
        paypal_payment_method.preferences.update(display_credit_messaging: true)
        expect(url.query.split("&")).to include("components=buttons%2Cmessages")
      end
    end

    context 'when messaging is turned off' do
      it 'only includes buttons components' do
        paypal_payment_method.preferences.update(display_credit_messaging: false)
        expect(url.query.split("&")).not_to include("messages")
        expect(url.query.split("&")).to include("components=buttons")
      end
    end

    context 'when venmo_standalone is "only render standalone"' do
      before { paypal_payment_method.preferences.update(venmo_standalone: 'only render standalone') }

      it 'includes "enable-funding=venmo" as a parameter' do
        expect(url.query.split('&')).to include('enable-funding=venmo')
      end
    end

    context 'when venmo_standalone is "enabled"' do
      before { paypal_payment_method.preferences.update(venmo_standalone: 'enabled') }

      it 'includes "enable-funding=venmo" as a parameter' do
        expect(url.query.split('&')).to include('enable-funding=venmo')
      end
    end

    context 'when venmo_standalone is "disabled"' do
      before { paypal_payment_method.preferences.update(venmo_standalone: 'disabled') }

      it 'does not include the "enable-funding" parameter' do
        expect(url.query.split('&')).not_to include(match 'enable-funding')
      end
    end

    context 'when force_buyer_country is an empty string' do
      it 'does not include the "buyer-country" parameter' do
        expect(url.query.split('&')).not_to include(match 'buyer-country')
      end
    end

    context 'when force_buyer_country is "US"' do
      before { paypal_payment_method.preferences.update(force_buyer_country: 'US') }

      it 'includes "buyer-country=US" as a parameter' do
        expect(url.query.split('&')).to include('buyer-country=US')
      end
    end

    context 'when force_buyer_country is "US" but the environment is production' do
      before {
        allow(Rails.env).to receive(:production?).and_return(true)
        paypal_payment_method.preferences.update(force_buyer_country: 'US')
      }

      it 'includes "buyer-country=US" as a parameter' do
        expect(url.query.split('&')).not_to include(match 'buyer-country')
      end
    end
  end

  private

  def expect_request(name)
    expect(SolidusPaypalCommercePlatform::Gateway.const_get(name))
  end
end

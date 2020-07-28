require 'spec_helper'

RSpec.describe SolidusPaypalCommercePlatform::WebhookJob do
  let(:paypal_order_id) { SecureRandom.uuid }
  let(:capture_id) { SecureRandom.uuid }
  let(:refund_id) { SecureRandom.uuid }

  let(:payment_source) {
    SolidusPaypalCommercePlatform::PaymentSource.new(
      paypal_order_id: paypal_order_id,
      capture_id: capture_id,
      refund_id: refund_id,
      payment_method: create(:paypal_payment_method),
    )
  }

  let(:payment) {
    create(:order).payments.create!(
      payment_method: payment_source.payment_method,
      source: payment_source,
    )
  }

  [
    ["CHECKOUT.ORDER.COMPLETED.v2", "paypal_order_id"],
    ["CHECKOUT.ORDER.PROCESSED.v2", "paypal_order_id"],
    ["PAYMENT.CAPTURE.COMPLETED.v1", "capture_id"],
    ["PAYMENT.CAPTURE.COMPLETED.v2", "capture_id"],
    ["PAYMENT.CAPTURE.DENIED.v1", "capture_id"],
    ["PAYMENT.CAPTURE.DENIED.v2", "capture_id"],
    ["PAYMENT.CAPTURE.REFUNDED.v1", "capture_id"],
    ["PAYMENT.CAPTURE.REFUNDED.v2", "refund_id"],
  ].each do |(event, source_attr)|
    describe event do
      let(:payload) { JSON.parse(File.read("#{__dir__}/fixtures/#{event}.json")) }
      let(source_attr) { payload.dig("resource", "id") }

      it 'inserts a log entry for the corresponding payment source' do
        expect { described_class.perform_now(payload) }.to change(payment.log_entries, :count).by(1)
        expect(YAML.load(payment.log_entries.last.details)).to eq(payload)
      end
    end
  end
end

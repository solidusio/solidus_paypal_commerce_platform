require 'spec_helper'

RSpec.describe SolidusPaypalCommercePlatform::PaymentSource, type: :model do
  let(:order) { Spree::TestingSupport::OrderWalkthrough.up_to(:payment) }
  let(:paypal_payment_method) { create(:paypal_payment_method) }
  let(:paypal_order_id) { "foo-123" }
  let(:payment_source) {
    described_class.new(
      paypal_order_id: paypal_order_id,
      payment_method: paypal_payment_method,
    )
  }
  let(:payment) {
    order.payments.create!(
      payment_method: paypal_payment_method,
      source: payment_source
    )
  }
  let(:paypal_order_status) { "COMPLETED" }

  before do
    allow_any_instance_of(SolidusPaypalCommercePlatform::Client).to receive(:execute) do |client, request|
      expect(request).to be_a(SolidusPaypalCommercePlatform::Gateway::OrdersGetRequest)
      OpenStruct.new(result: OpenStruct.new(status: paypal_order_status))
    end
  end

  describe '#actions' do
    context 'when the payment is not yet completed' do
      it 'shows "capture" and "void"' do
        expect(payment.actions).to contain_exactly("capture", "void")
      end
    end

    context 'when the payment is completed and captured' do
      before do
        payment.update!(state: :completed, amount: 123)
        payment_source.update!(capture_id: 1234)
      end

      it 'shows "credit"' do
        expect(payment.actions).to contain_exactly("credit")
      end

      context 'when the PayPal order status is not COMPLETED' do
        let(:paypal_order_status) { "FOOBAR" }

        it 'hides the "credit" action' do
          expect(payment.actions).not_to include("credit")
        end
      end
    end

    context 'when it cannot capture' do
      it 'also cannot void' do
        # One for "capture", and one for "void"
        expect(payment_source).to receive(:can_capture?).and_return(false).twice
        expect(payment.actions).not_to include("void")
      end
    end
  end
end

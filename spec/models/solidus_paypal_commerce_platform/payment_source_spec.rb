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
    allow_any_instance_of(SolidusPaypalCommercePlatform::Client).to receive(:execute) do |_client, request|
      expect(request).to be_a(SolidusPaypalCommercePlatform::Gateway::OrdersGetRequest) # rubocop:disable RSpec/ExpectInHook
      instance_double(
        response,
        result: instance_double(result, status: paypal_order_status)
      )
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

    context 'with #display_paypal_funding_source' do
      context 'when the EN locale exists' do
        it 'translates the funding source' do
          payment_source.paypal_funding_source = 'card'

          result = payment_source.display_paypal_funding_source

          expect(result).to eq('Credit or debit card')
        end
      end

      context "when the locale doesn't exist" do
        it 'returns the paypal_funding_source as the default' do
          allow(payment_source).to receive(:paypal_funding_source).and_return('non-existent')

          result = payment_source.display_paypal_funding_source

          expect(result).to eq('non-existent')
        end
      end
    end
  end

  describe 'attributes' do
    context 'with paypal_funding_source' do
      it 'can be nil' do
        payment_source.paypal_funding_source = nil

        expect(payment_source).to be_valid
      end

      it 'makes empty strings nil' do
        payment_source.paypal_funding_source = ''

        result = payment_source.save

        expect(result).to be(true)
        expect(payment_source.paypal_funding_source).to be_nil
      end

      it 'gets correctly mapped as an enum' do
        payment_source.paypal_funding_source = 'applepay'

        result = payment_source.save

        expect(result).to be(true)
        expect(payment_source.paypal_funding_source).to eq('applepay')
        expect(payment_source.applepay_funding?).to be(true)
      end
    end
  end
end

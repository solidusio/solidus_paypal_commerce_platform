require 'spec_helper'

RSpec.describe SolidusPaypalCommercePlatform::Client do
  subject(:client) { described_class.new(client_id: "1234") }

  describe '#execute_with_response' do
    let(:request_class) { SolidusPaypalCommercePlatform::Gateway::OrdersCaptureRequest }
    let(:paypal_request) { double(:request, class: request_class) }
    let(:paypal_response) { double(:response, status_code: status_code, result: nil, headers: {}) }
    let(:status_code) { 201 }

    it 'forwards to the upstream client adding i18n response messages' do
      allow_any_instance_of(PayPal::PayPalHttpClient)
        .to receive(:execute).with(paypal_request).and_return(paypal_response)

      response = subject.execute_with_response(paypal_request)

      expect(response.message).to eq("Payment captured")
    end
  end
end

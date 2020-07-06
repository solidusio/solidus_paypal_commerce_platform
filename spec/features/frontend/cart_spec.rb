require 'spec_helper'

RSpec.describe "Cart page" do
  describe "paypal payment method" do
    let(:order) { Spree::TestingSupport::OrderWalkthrough.up_to(:address) }
    let(:paypal_payment_method) { create(:paypal_payment_method) }

    before do
      user = create(:user)
      order.user = user

      paypal_payment_method
      allow_any_instance_of(Spree::OrdersController).to receive_messages(
        current_order: order,
        try_spree_current_user: user
      )
    end

    def paypal_script_options
      script_tag_url = URI(page.find('script[src*="sdk/js?"]', visible: false)[:src])
      script_tag_url.query.split('&')
    end

    it "generate a js file with the correct credentials and intent attached" do
      visit '/cart'
      expect(paypal_script_options).to include("client-id=#{paypal_payment_method.preferences[:client_id]}")
    end

    context "when auto-capture is set to true" do
      it "generate a js file with intent capture" do
        paypal_payment_method.update(auto_capture: true)
        visit '/cart'
        expect(paypal_script_options).to include("client-id=#{paypal_payment_method.preferences[:client_id]}")
        expect(paypal_script_options).to include("intent=capture")
      end
    end
  end
end

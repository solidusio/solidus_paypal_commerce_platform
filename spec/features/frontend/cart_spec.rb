require 'solidus_paypal_commerce_platform_spec_helper'

RSpec.describe "Cart page" do
  describe "paypal payment method" do
    let(:order) { Spree::TestingSupport::OrderWalkthrough.up_to(:address) }
    let(:paypal_payment_method) { create(:paypal_payment_method) }

    before do
      user = create(:user)
      order.user = user
      visit spree.root_path
      click_link 'Login'

      fill_in 'spree_user[email]', with: user.email
      fill_in 'spree_user[password]', with: 'secret'
      click_button 'Login'

      paypal_payment_method
      allow_any_instance_of(Spree::OrdersController).to receive_messages(
        current_order: order,
        try_spree_current_user: user
      )
    end

    context "when generating a script tag" do
      it "generates a url with the correct credentials attached" do
        visit '/cart'
        expect(js_sdk_script_query).to include("client-id=#{paypal_payment_method.preferences[:client_id]}")
      end

      it "generates a partner_id attribute with the correct partner code attached" do
        visit '/cart'
        expect(js_sdk_script_partner_id).to eq("Solidus_PCP_SP")
      end

      it "generates a URL with the correct currency" do
        allow(order).to receive(:currency).and_return "EUR"
        visit '/cart'
        expect(js_sdk_script_query).to include("currency=EUR")
      end

      context "when auto-capture is set to true" do
        it "generates a url with intent capture" do
          paypal_payment_method.update(auto_capture: true)
          visit '/cart'

          expect(js_sdk_script_query).to include("client-id=#{paypal_payment_method.preferences[:client_id]}")
          expect(js_sdk_script_query).to include("intent=capture")
        end
      end
    end
  end
end

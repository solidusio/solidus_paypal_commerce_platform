require 'solidus_paypal_commerce_platform_spec_helper'

RSpec.describe "Product page", js: true do
  describe "paypal button", :skip do
    before { create(:store, default: true) }

    let!(:paypal_payment_method) { create(:paypal_payment_method) }
    let!(:variants) {
      option_type = create(:option_type)
      product = create(:product, option_types: [option_type], slug: 'foo-bar')
      option_s = create(:option_value, option_type: option_type, presentation: 'S')
      option_xs = create(:option_value, option_type: option_type, presentation: 'XS')

      [
        create(:variant, product: product, option_values: [option_s]),
        create(:variant, product: product, option_values: [option_xs]),
      ]
    }

    context "when generating a script tag" do
      it "generates a url with the correct credentials attached" do
        visit "/products/foo-bar"

        expect(js_sdk_script_query).to include("client-id=#{paypal_payment_method.preferences[:client_id]}")
      end

      it "generates a partner_id attribute with the correct partner code attached" do
        visit "/products/foo-bar"

        expect(js_sdk_script_partner_id).to eq("Solidus_PCP_SP")
      end

      it "generates a URL with the correct currency" do
        allow_any_instance_of(SolidusPaypalCommercePlatform::PricingOptions).to receive(:currency).and_return "EUR"

        visit "/products/foo-bar"

        expect(js_sdk_script_query).to include("currency=EUR")
      end

      context "when auto-capture is set to true" do
        it "generates a url with intent capture" do
          paypal_payment_method.update(auto_capture: true)

          visit "/products/foo-bar"

          expect(js_sdk_script_query).to include("client-id=#{paypal_payment_method.preferences[:client_id]}")
          expect(js_sdk_script_query).to include("intent=capture")
        end
      end
    end

    describe "order creation" do
      it "creates an order successfully" do
        visit "/products/foo-bar"
        page.evaluate_script("SolidusPaypalCommercePlatform.createOrder()")

        expect(Spree::Order.last).to be_an_instance_of(Spree::Order)
      end

      it "sets the Spree number and token variables" do
        visit "/products/foo-bar"
        page.evaluate_script("SolidusPaypalCommercePlatform.createOrder()")

        order = Spree::Order.last
        expect(page.evaluate_script("SolidusPaypalCommercePlatform.current_order_id")).to eq order.number
        expect(page.evaluate_script("SolidusPaypalCommercePlatform.current_order_token")).to eq order.guest_token
      end

      it "uses the specified quantity" do
        visit "/products/foo-bar"
        fill_in('quantity', with: 12)
        page.evaluate_script("SolidusPaypalCommercePlatform.createOrder()")

        expect(Spree::Order.last.line_items.first.quantity).to eq(12)
      end

      it "uses the selected variant" do
        visit "/products/foo-bar"
        find('label', text: 'XS').click
        page.evaluate_script("SolidusPaypalCommercePlatform.createOrder()")

        expect(Spree::Order.last.line_items.first.variant).to eq(variants.last)
      end

      it "assigns the order to the api token holder" do
        user = create(:user)
        user.generate_spree_api_key!

        visit "/products/foo-bar"
        page.evaluate_script("SolidusPaypalCommercePlatform.api_key = #{user.spree_api_key.to_json}")
        page.evaluate_script("SolidusPaypalCommercePlatform.createOrder()")

        expect(Spree::Order.last.user).to eq(user)
      end
    end
  end
end

require 'spec_helper'

RSpec.describe "Product page", js: true do
  describe "paypal button" do
    let(:paypal_payment_method) { create(:paypal_payment_method) }
    let(:product) { create(:product, variants: [variant, variant_two]) }
    let(:store) { create(:store) }
    let(:variant) { create(:variant) }
    let(:variant_two) { create(:variant) }

    before do
      paypal_payment_method
    end

    context "when generating a script tag" do
      it "generates a url with the correct credentials attached" do
        visit "/products/#{product.slug}"
        expect(js_sdk_script_query).to include("client-id=#{paypal_payment_method.preferences[:client_id]}")
      end

      it "generates a partner_id attribute with the correct partner code attached" do
        visit "/products/#{product.slug}"
        expect(js_sdk_script_partner_id).to eq("Solidus_PCP_SP")
      end

      it "generates a URL with the correct currency" do
        allow_any_instance_of(SolidusPaypalCommercePlatform::PricingOptions).to receive(:currency).and_return "EUR"
        visit "/products/#{product.slug}"
        expect(js_sdk_script_query).to include("currency=EUR")
      end

      context "when auto-capture is set to true" do
        it "generates a url with intent capture" do
          paypal_payment_method.update(auto_capture: true)
          visit "/products/#{product.slug}"
          expect(js_sdk_script_query).to include("client-id=#{paypal_payment_method.preferences[:client_id]}")
          expect(js_sdk_script_query).to include("intent=capture")
        end
      end
    end

    describe "order creation" do
      before do
        allow_any_instance_of(Spree::Core::ControllerHelpers::Store).to receive(:current_store) { store }
        visit "/products/#{product.slug}"

        # Stubbing out paypal methods since their JS doesn't load in correctly on tests
        page.execute_script("paypal = {}")
        page.execute_script("paypal.render = function(){}")
        page.execute_script("paypal.Buttons = function(){return paypal}")

        # Waiting until the paypal button becomes available, because the SPCP namespace
        # isn't immediately available
        page.find_by_id('paypal-button-container') # rubocop:disable Rails/DynamicFindBy
      end

      it "creates an order successfully" do
        page.evaluate_script("SolidusPaypalCommercePlatform.createOrder()")
        page.driver.wait_for_network_idle

        expect(Spree::Order.last).to be_an_instance_of(Spree::Order)
      end

      it "sets the Spree number and token variables" do
        page.evaluate_script("SolidusPaypalCommercePlatform.createOrder()")
        page.driver.wait_for_network_idle

        expect(page.evaluate_script("Spree.current_order_id")).to eq Spree::Order.last.number
        expect(page.evaluate_script("Spree.current_order_token")).to eq Spree::Order.last.guest_token
      end

      it "uses the specified quantity" do
        quantity = 12
        fill_in('quantity', with: quantity)

        page.evaluate_script("SolidusPaypalCommercePlatform.createOrder()")
        page.driver.wait_for_network_idle

        expect(Spree::Order.last.line_items.first.quantity).to eq quantity
      end

      it "uses the selected variant" do
        page.choose("variant_id_#{variant_two.id}")
        page.evaluate_script("SolidusPaypalCommercePlatform.createOrder()")
        page.driver.wait_for_network_idle

        expect(Spree::Order.last.line_items.first.variant_id).to eq variant_two.id
      end

      it "assigns the order to the api token holder" do
        user = create(:user)
        user.generate_spree_api_key!

        page.evaluate_script("Spree.api_key = #{user.spree_api_key.to_json}")
        page.evaluate_script("SolidusPaypalCommercePlatform.createOrder()")
        page.driver.wait_for_network_idle

        expect(Spree::Order.last).to be_an_instance_of(Spree::Order)
        expect(Spree::Order.last.user).to eq(user)
      end
    end
  end
end

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

    def paypal_script_options
      script_tag_url = URI(page.find('script[src*="sdk/js?"]', visible: false)[:src])
      script_tag_url.query.split('&')
    end

    it "generates a js file with the correct credentials and intent attached" do
      visit "/products/#{product.slug}"
      expect(paypal_script_options).to include("client-id=#{paypal_payment_method.preferences[:client_id]}")
    end

    context "when auto-capture is set to true" do
      it "generates a js file with intent capture" do
        paypal_payment_method.update(auto_capture: true)
        visit "/products/#{product.slug}"
        expect(paypal_script_options).to include("client-id=#{paypal_payment_method.preferences[:client_id]}")
        expect(paypal_script_options).to include("intent=capture")
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
        page.find("#paypal-button-container")
      end

      it "creates an order successfully" do
        page.evaluate_script("SolidusPaypalCommercePlatform.createOrder()")
        page.driver.wait_for_network_idle

        expect(Spree::Order.last).not_to be nil
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
    end
  end
end

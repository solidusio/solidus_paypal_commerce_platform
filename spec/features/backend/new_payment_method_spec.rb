require 'spec_helper'

RSpec.describe "creating a new payment" do
  stub_authorization!

  scenario "should display PayPal Commerce Platform as an option" do
    visit "/admin/payment_methods/new"
    expect(page).to have_select('payment_method_type', :options => ["Paypal Commerce Platform", "Bogus Credit Card Payments", "Check Payments", "Simple Bogus Credit Card Payments", "Store Credit Payments"])
  end

  scenario "should display the onboarding button", :js do
    visit "/admin/payment_methods"

    main_window = current_window

    within ".setup-wizard" do
      paypal_button = page.find("button")
      expect(paypal_button.text).to eq("Setup PayPal Commerce Platform")
      # TODO: make this more complete
      # paypal_window = window_opened_by do
      #   paypal_button.click
      # end
    end
  end
end

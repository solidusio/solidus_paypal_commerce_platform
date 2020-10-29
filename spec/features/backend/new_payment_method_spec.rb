require 'spec_helper'

RSpec.describe "creating a new payment" do
  stub_authorization!

  it "displays PayPal Commerce Platform as an option" do
    if ENV['BASIC_AUTH'].present?
      name, password = ENV['BASIC_AUTH'].split(':')
      page.driver.browser.authorize(name, password)
    end
    visit "/admin/payment_methods/new"
    expect(page).to have_select('payment_method_type', options: [
      "PayPal Commerce Platform",
      "Bogus Credit Card Payments",
      "Check Payments",
      "Simple Bogus Credit Card Payments",
      "Store Credit Payments",
    ])
    select "PayPal Commerce Platform", from: 'payment_method_type'
    fill_in "Name", with: "PayPal!"
    click_on "Create"
    expect(page).to have_text("Payment Method has been successfully created!")

    fill_in "Client", with: "cli-123"
    fill_in "Client secret", with: "cli-sec-123"
    click_on "Update"
    expect(page).to have_text("Payment Method has been successfully updated!")
  end

  it "displays the onboarding button", :js do
    if ENV['BASIC_AUTH'].present?
      name, password = ENV['BASIC_AUTH'].split(':')
      page.driver.basic_authorize(name, password)
    end
    visit "/admin/payment_methods"

    # main_window = current_window

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

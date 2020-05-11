require 'spec_helper'

RSpec.describe "creating a new payment" do
  stub_authorization!

  scenario "should display PayPal Commerce Platform as an option" do
    visit "/admin/payment_methods/new"
    expect(page).to have_select('payment_method_type', :options => ["Paypal Commerce Platform", "Bogus Credit Card Payments", "Check Payments", "Simple Bogus Credit Card Payments", "Store Credit Payments"])
  end
end

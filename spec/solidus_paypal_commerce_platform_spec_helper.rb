# frozen_string_literal: true

begin
  require 'solidus_storefront_spec_helper'
rescue LoadError
  require 'solidus_starter_frontend_spec_helper'
end

Dir["#{__dir__}/support/solidus_paypal_commerce_platform/**/*.rb"].sort.each { |f| require f }

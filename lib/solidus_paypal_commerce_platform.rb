# frozen_string_literal: true

require 'solidus_core'
require 'solidus_support'

require 'solidus_paypal_commerce_platform/client'
require 'solidus_paypal_commerce_platform/configuration'
require 'solidus_paypal_commerce_platform/version'
require 'solidus_paypal_commerce_platform/engine'
require 'paypal/lib'

module SolidusPaypalCommercePlatform
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    alias config configuration

    def configure
      yield configuration
    end
  end
end

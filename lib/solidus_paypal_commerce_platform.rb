# frozen_string_literal: true

require 'solidus_core'
require 'solidus_support'

require 'solidus_paypal_commerce_platform/version'
require 'solidus_paypal_commerce_platform/configuration'
require 'solidus_paypal_commerce_platform/client'
require 'solidus_paypal_commerce_platform/engine'

module SolidusPaypalCommercePlatform
  class << self
    def config
      @config ||= Configuration.new
    end

    def configure
      yield config
    end
  end
end

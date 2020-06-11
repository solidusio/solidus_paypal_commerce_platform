# frozen_string_literal: true

require 'paypal-checkout-sdk'

module SolidusPaypalCommercePlatform
  module Environment
    InvalidEnvironment = Class.new(StandardError)

    def env=(value)
      unless %w[live sandbox].include? value
        raise InvalidEnvironment, "#{value} is not a valid environment"
      end

      @env = ActiveSupport::StringInquirer.new(value)
    end

    def env
      self.env = default_env unless @env

      @env
    end

    def default_env
      return ENV['PAYPAL_ENV'] if ENV['PAYPAL_ENV']

      case Rails.env
      when 'production'
        return 'live'
      when 'test', 'development'
        return 'sandbox'
      else
        raise InvalidEnvironment, 'Unable to guess the PayPal env, please set #{self}.env= explicitly.'
      end
    end

    def env_class
      env.live? ? PayPal::LiveEnvironment : PayPal::SandboxEnvironment
    end

    def env_domain
      env.live? ? "www.paypal.com" : "www.sandbox.paypal.com"
    end
  end

  extend Environment
end


# frozen_string_literal: true

require 'paypal-checkout-sdk'

module SolidusPaypalCommercePlatform
  module Environment
    InvalidEnvironment = Class.new(StandardError)

    DEFAULT_NONCE = {
      sandbox: "0fb0e3e75e3deb58de8fb4e8dc27eb25ab2cbcabdb84",
      live: "5RNMN2F8cBpVd9ek2F060WB03WWzjs64pYCUxhsJFg0d",
    }.freeze

    DEFAULT_PARTNER_ID = {
      sandbox: "5LQZV7RJDGKG2",
      live: "TBD",
    }.freeze

    DEFAULT_PARTNER_CLIENT_ID = {
      sandbox: "ATDpQjHzjCz_C_qbbJ76Ca0IjcmwlS4FztD6YfuRFZXDCmcWWw8-8QWcF3YIkbC85ixTUuuSEvrBMVSX",
      live: "TBD",
    }.freeze

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
        raise InvalidEnvironment, "Unable to guess the PayPal env, please set #{self}.env= explicitly."
      end
    end

    def env_class
      env.live? ? PayPal::LiveEnvironment : PayPal::SandboxEnvironment
    end

    def env_domain
      env.live? ? "www.paypal.com" : "www.sandbox.paypal.com"
    end

    attr_writer :partner_id, :partner_client_id, :nonce

    def nonce
      @nonce ||= ENV['PAYPAL_NONCE'] || DEFAULT_NONCE[env.to_sym]
    end

    def partner_id
      @partner_id ||= ENV['PAYPAL_PARTNER_ID'] || DEFAULT_PARTNER_ID[env.to_sym]
    end

    def partner_client_id
      @partner_client_id ||= ENV['PAYPAL_PARTNER_CLIENT_ID'] || DEFAULT_PARTNER_CLIENT_ID[env.to_sym]
    end
  end

  extend Environment
end

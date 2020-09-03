# frozen_string_literal: true

require 'paypal-checkout-sdk'

module SolidusPaypalCommercePlatform
  class Configuration
    attr_writer :state_guesser_class, :partner_id, :partner_client_id

    InvalidEnvironment = Class.new(StandardError)

    DEFAULT_PARTNER_ID = {
      sandbox: "5LQZV7RJDGKG2",
      live: "NBKVLAA7K2V5S",
    }.freeze

    DEFAULT_PARTNER_CLIENT_ID = {
      sandbox: "ATDpQjHzjCz_C_qbbJ76Ca0IjcmwlS4FztD6YfuRFZXDCmcWWw8-8QWcF3YIkbC85ixTUuuSEvrBMVSX",
      live: "ASOxaUMkeX5bv7PbXnWUDnqb3SVYkzRSosApmLGFih-eAhB_OS_Wo6juijE5t8NCmWDgpN2ugHMmQFWA",
    }.freeze

    def state_guesser_class
      self.state_guesser_class = "SolidusPaypalCommercePlatform::StateGuesser" unless @state_guesser_class

      @state_guesser_class.constantize
    end

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

    def partner_id
      @partner_id ||= ENV['PAYPAL_PARTNER_ID'] || DEFAULT_PARTNER_ID[env.to_sym]
    end

    def partner_client_id
      @partner_client_id ||= ENV['PAYPAL_PARTNER_CLIENT_ID'] || DEFAULT_PARTNER_CLIENT_ID[env.to_sym]
    end
  end
end

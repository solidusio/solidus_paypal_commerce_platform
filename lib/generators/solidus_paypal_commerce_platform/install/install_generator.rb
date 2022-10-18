# frozen_string_literal: true

module SolidusPaypalCommercePlatform
  module Generators
    class InstallGenerator < Rails::Generators::Base
      class_option :auto_run_migrations, type: :boolean, default: false

      # This should only be used by the solidus installer prior to v3.3.
      class_option :skip_migrations, type: :boolean, default: false, hide: true

      source_root File.expand_path('templates', __dir__)

      def copy_initializer
        template 'initializer.rb', 'config/initializers/solidus_paypal_commerce_platform.rb'
      end

      def add_javascripts
        append_file 'vendor/assets/javascripts/spree/frontend/all.js', "//= require spree/frontend/solidus_paypal_commerce_platform\n" # rubocop:disable Layout/LineLength
        append_file 'vendor/assets/javascripts/spree/backend/all.js', "//= require spree/backend/solidus_paypal_commerce_platform\n" # rubocop:disable Layout/LineLength
      end

      def add_stylesheets
        inject_into_file 'vendor/assets/stylesheets/spree/frontend/all.css', " *= require spree/frontend/solidus_paypal_commerce_platform\n", before: %r{\*/}, verbose: true # rubocop:disable Layout/LineLength
        inject_into_file 'vendor/assets/stylesheets/spree/backend/all.css', " *= require spree/backend/solidus_paypal_commerce_platform\n", before: %r{\*/}, verbose: true # rubocop:disable Layout/LineLength
      end

      def add_migrations
        run 'bin/rails railties:install:migrations FROM=solidus_paypal_commerce_platform'
      end

      def mount_engine
        route "mount SolidusPaypalCommercePlatform::Engine, at: '/solidus_paypal_commerce_platform'"
      end

      def run_migrations
        return rake 'db:migrate' if options[:auto_run_migrations] && !options[:skip_migrations]

        say_status :skip, 'db:migrate'
      end
    end
  end
end

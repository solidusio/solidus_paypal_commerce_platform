# frozen_string_literal: true

module SolidusPaypalCommercePlatform
  module Generators
    class InstallGenerator < Rails::Generators::Base
      class_option :migrate, type: :boolean, default: true

      source_root File.expand_path('templates', __dir__)

      def install_solidus_core_support
        template 'initializer.rb', 'config/initializers/solidus_paypal_commerce_platform.rb'
        rake 'railties:install:migrations FROM=solidus_paypal_commerce_platform'
        run 'bin/rails db:migrate' if options[:migrate]
        route "mount SolidusPaypalCommercePlatform::Engine, at: '/solidus_paypal_commerce_platform'"
      end

      def install_solidus_backend_support
        support_code_for('solidus_backend') do
          append_file(
            'vendor/assets/javascripts/spree/backend/all.js',
            "//= require spree/backend/solidus_paypal_commerce_platform\n"
          )
          inject_into_file(
            'vendor/assets/stylesheets/spree/backend/all.css',
            " *= require spree/backend/solidus_paypal_commerce_platform\n",
            before: %r{\*/},
            verbose: true,
          )
        end
      end

      def install_solidus_frontend_support
        support_code_for('solidus_frontend') do
          append_file(
            'vendor/assets/javascripts/spree/frontend/all.js',
            "//= require spree/frontend/solidus_paypal_commerce_platform\n",
          )
          inject_into_file(
            'vendor/assets/stylesheets/spree/frontend/all.css',
            " *= require spree/frontend/solidus_paypal_commerce_platform\n",
            before: %r{\*/},
            verbose: true,
          )
          directory engine.root.join("lib/views/frontend"), 'app/views/'
        end
      end

      private

      def support_code_for(gem_name, run_if: Bundler.locked_gems.specs.map(&:name).include?(gem_name), &block)
        if run_if
          say_status :install, "[#{engine.engine_name}] #{gem_name} code", :blue
          shell.indent(&block)
        else
          say_status :skip, "[#{engine.engine_name}] #{gem_name} code", :blue
        end
      end

      def engine
        SolidusPaypalCommercePlatform::Engine
      end
    end
  end
end

# frozen_string_literal: true

module SolidusPaypalCommercePlatform
  module Generators
    class InstallGenerator < Rails::Generators::Base
      class_option :migrate, type: :boolean, default: true
      class_option :specs, type: :string, enum: %w[all frontend], default: 'frontend'

      source_root File.expand_path('templates', __dir__)

      def install_solidus_core_support
        directory 'config/initializers', 'config/initializers'
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

      def install_solidus_starter_frontend_support
        solidus_frontend_is_missing = !Bundler.locked_gems.specs.map(&:name).include?('solidus_frontend')

        # We can't do better than this for now, over time we might want to mark things differently
        support_code_for('solidus_starter_frontend', run_if: solidus_frontend_is_missing) do
          directory 'app', 'app'
          append_file(
            'app/assets/javascripts/solidus_starter_frontend.js',
            "//= require spree/frontend/solidus_paypal_commerce_platform\n"
          )
          inject_into_file(
            'app/assets/stylesheets/solidus_starter_frontend.css',
            " *= require spree/frontend/solidus_paypal_commerce_platform\n",
            before: %r{\*/},
            verbose: true,
          )

          spec_paths =
            case options[:specs]
            when 'all' then %w[spec]
            when 'frontend'
              %w[
                spec/solidus_paypal_commerce_platform_spec_helper.rb
                spec/system/frontend
                spec/support
              ]
            end

          spec_paths.each do |path|
            if engine.root.join(path).directory?
              directory engine.root.join(path), path
            else
              template engine.root.join(path), path
            end
          end
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

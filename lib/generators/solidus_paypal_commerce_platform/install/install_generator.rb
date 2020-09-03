# frozen_string_literal: true

module SolidusPaypalCommercePlatform
  module Generators
    class InstallGenerator < Rails::Generators::Base
      class_option :auto_run_migrations, type: :boolean, default: false

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
        insert_into_file File.join('config', 'routes.rb'), after: "Rails.application.routes.draw do\n" do
          "mount SolidusPaypalCommercePlatform::Engine, at: '/solidus_paypal_commerce_platform'\n"
        end
      end

      def run_migrations
        run_migrations = options[:auto_run_migrations] || ['', 'y', 'Y'].include?(ask('Would you like to run the migrations now? [Y/n]')) # rubocop:disable Layout/LineLength
        if run_migrations
          run 'bin/rails db:migrate'
        else
          puts 'Skipping bin/rails db:migrate, don\'t forget to run it!' # rubocop:disable Rails/Output
        end
      end
    end
  end
end

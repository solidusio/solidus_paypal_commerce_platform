# frozen_string_literal: true

SolidusPaypalCommercePlatform::Engine.routes.draw do
  # Add your extension routes here
  resources :wizard, only: [:create]
  # post :paypal_wizard, to: "wizard#create"
end

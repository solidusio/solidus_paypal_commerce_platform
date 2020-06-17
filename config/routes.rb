# frozen_string_literal: true

SolidusPaypalCommercePlatform::Engine.routes.draw do
  # Add your extension routes here
  resources :wizard, only: [:create]
  resources :orders, only: [:create]
  resources :payments, only: [:create]
  get :shipping_rates, to: "shipping_rates#simulate_shipping_rates"
  post :update_address, to: "orders#update_address"
end

# frozen_string_literal: true

SolidusPaypalCommercePlatform::Engine.routes.draw do
  # Add your extension routes here
  resources :wizard, only: [:create]
  resources :orders, only: [:create]
  resources :payments, only: [:create]
end

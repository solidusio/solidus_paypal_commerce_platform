# frozen_string_literal: true

Deface::Override.new(
  name: "orders/edit/insert_cart_buttons",
  virtual_path: "spree/orders/edit",
  original: "6af87f9fd7740e8f8493c7e8d875690c49fe2adb",
  insert_after: "[data-hook='cart_items']",
  partial: 'solidus_paypal_commerce_platform/cart/cart_buttons'
)

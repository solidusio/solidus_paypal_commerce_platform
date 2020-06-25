# frozen_string_literal: true

Deface::Override.new(
  name: "products/cart_form/insert_product_buttons",
  virtual_path: "spree/products/_cart_form",
  insert_bottom: "[data-hook='product_price']",
  original: '09b5c0504202d92adbfb0f92d6bf12fc17752295',
  source: :partial,
  partial: 'solidus_paypal_commerce_platform/product/product_buttons'
)

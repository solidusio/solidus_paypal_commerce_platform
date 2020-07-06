# frozen_string_literal: true

Deface::Override.new(
  name: "payment_methods/index/insert_setup_wizards#list",
  virtual_path: "spree/admin/payment_methods/index",
  original: "bf5a94b3b0967d88b88f72bc26131897ff85a1d0",
  insert_after: "#listing_payment_methods",
  partial: 'solidus_paypal_commerce_platform/admin/payment_methods/setup_wizards'
)

Deface::Override.new(
  name: "payment_methods/index/insert_setup_wizards#empty",
  virtual_path: "spree/admin/payment_methods/index",
  original: "318d918b15df51842a5d98a6230bea96ffa05142",
  insert_after: ".no-objects-found",
  partial: 'solidus_paypal_commerce_platform/admin/payment_methods/setup_wizards'
)

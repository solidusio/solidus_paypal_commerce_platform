# frozen_string_literal: true

Deface::Override.new(
  name: "payment_methods/form/insert_email_verification_notification",
  virtual_path: "spree/admin/payment_methods/_form",
  original: "471a995989ea93a58118c80be38fafcd1fd3ee69",
  replace: "erb[loud]:contains('f.check_box :available_to_users')",
  partial: "solidus_paypal_commerce_platform/admin/payment_methods/available_to_users"
)

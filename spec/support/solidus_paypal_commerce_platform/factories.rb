FactoryBot.definition_file_paths << SolidusPaypalCommercePlatform::Engine.root.join(
  'lib/solidus_paypal_commerce_platform/testing_support/factories'
).to_s

FactoryBot.reload

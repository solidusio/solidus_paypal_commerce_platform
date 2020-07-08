class AddEmailToPaypalCommercePlatformSources < ActiveRecord::Migration[5.2]
  def change
    add_column :paypal_commerce_platform_sources, :paypal_email, :string
  end
end

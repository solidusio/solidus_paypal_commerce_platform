class AddPaypalCommercePlatformSources < ActiveRecord::Migration[5.2]
  def change
    create_table :paypal_commerce_platform_sources do |t|
      t.integer :payment_method_id
      t.string :authorization_id
      t.string :capture_id
      t.string :paypal_email
      t.string :paypal_order_id
      t.timestamps
    end
  end
end

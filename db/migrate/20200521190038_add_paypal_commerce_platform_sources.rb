class AddPaypalCommercePlatformSources < ActiveRecord::Migration[5.2]
  def change
    create_table :paypal_commerce_platform_sources do |t|
      t.string :paypal_order_id
      t.integer :payment_method_id
      t.string :authorization_id
      t.timestamps
    end
  end
end

class AddPaypalFundingSourceToPaypalCommercePlatformSources < ActiveRecord::Migration[5.2]
  def change
    add_column :paypal_commerce_platform_sources, :paypal_funding_source, :integer
  end
end

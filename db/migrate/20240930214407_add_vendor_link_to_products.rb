class AddVendorLinkToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :vendor_link, :string
  end
end

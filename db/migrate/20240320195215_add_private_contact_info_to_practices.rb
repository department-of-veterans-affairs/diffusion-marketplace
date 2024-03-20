class AddPrivateContactInfoToPractices < ActiveRecord::Migration[6.1]
  def change
    add_column :practices, :private_contact_info, :boolean, default: false
  end
end

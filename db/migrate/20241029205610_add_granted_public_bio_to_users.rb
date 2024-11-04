class AddGrantedPublicBioToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :granted_public_bio, :boolean, default: false
    add_index :users, :granted_public_bio
  end
end

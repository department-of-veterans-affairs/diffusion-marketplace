class AddAcceptedTermsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :accepted_terms, :boolean, default: false
  end
end

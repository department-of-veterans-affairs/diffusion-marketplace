class AddColumnsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :alt_first_name, :string
    add_column :users, :alt_last_name, :string
    add_column :users, :fellowship, :text
    add_column :users, :work, :json
    add_column :users, :project, :text
    add_column :users, :alt_job_title, :string
    add_column :users, :accolades, :string
  end
end

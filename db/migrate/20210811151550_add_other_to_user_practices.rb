class AddOtherToUserPractices < ActiveRecord::Migration[5.2]
  def change
    add_column :user_practices, :other, :boolean, default: false
  end
end


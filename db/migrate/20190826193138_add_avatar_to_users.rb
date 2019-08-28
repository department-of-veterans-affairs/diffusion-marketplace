# frozen_string_literal: true

class AddAvatarToUsers < ActiveRecord::Migration[5.2]
  def up
    add_attachment :users, :avatar
  end

  def down
    remove_attachment :users, :avatar
  end
end

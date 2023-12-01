class AddPublicToPages < ActiveRecord::Migration[6.1]
  def up
    add_column :pages, :is_public, :boolean, default: false

    Page.find_each do |page|
      page.update_column(:is_public, false)
    end
  end

  def down
    remove_column :pages, :is_public
  end
end

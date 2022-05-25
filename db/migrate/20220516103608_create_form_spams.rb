class CreateFormSpams < ActiveRecord::Migration[5.2]
  def change
    create_table :form_spams do |t|
      t.string :form
      t.string :original_url
      t.string :ip_address
      t.timestamps
    end
  end
end
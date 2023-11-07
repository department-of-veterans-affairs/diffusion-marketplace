class AddLocationToPageEventComponent < ActiveRecord::Migration[6.0]
  def change
    add_column :page_event_components, :location, :string
  end
end

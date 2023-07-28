class AddPresentedByToPageEventComponents < ActiveRecord::Migration[6.0]
  def change
    add_column :page_event_components, :presented_by, :string
  end
end

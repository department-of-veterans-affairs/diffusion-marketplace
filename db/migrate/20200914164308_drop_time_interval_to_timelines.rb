class DropTimeIntervalToTimelines < ActiveRecord::Migration[5.2]
  def change
    remove_column :timelines, :time_interval, :string
  end
end
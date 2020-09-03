class AddTimeIntervalToTimelines < ActiveRecord::Migration[5.2]
  def change
    add_column :timelines, :time_interval, :string
  end
end
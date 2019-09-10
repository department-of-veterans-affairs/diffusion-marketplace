class CreateDiffusionHistoryStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :diffusion_history_statuses do |t|
      t.belongs_to :diffusion_history, foreign_key: true
      t.string :status
      t.datetime :start_time
      t.datetime :end_time
      t.timestamps
    end
  end
end

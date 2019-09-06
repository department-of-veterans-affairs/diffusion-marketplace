class CreateDiffusionHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :diffusion_histories do |t|
      t.belongs_to :practice, foreign_key: true
      t.string :facility_id
      t.string :status
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end

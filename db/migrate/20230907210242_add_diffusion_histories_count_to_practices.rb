class AddDiffusionHistoriesCountToPractices < ActiveRecord::Migration[6.0]
  def change
    add_column :practices, :diffusion_histories_count, :integer, default: 0
  end
end

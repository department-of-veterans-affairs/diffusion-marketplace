class AddUnsuccessfulReasonsToDiffusionHistoryStatuses < ActiveRecord::Migration[5.2]
  def change
    add_column :diffusion_history_statuses, :unsuccessful_reasons, :integer, array: true, default: []
    add_column :diffusion_history_statuses, :unsuccessful_reasons_other, :text
  end
end

class AddVaFacilityToDiffusionHistories < ActiveRecord::Migration[5.2]
  def change
    add_reference :diffusion_histories, :va_facility, foreign_key: true
  end
end

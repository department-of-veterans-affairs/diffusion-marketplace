class AddVaFacilityToDiffusionHistoriesAndPracticeOriginFacilities < ActiveRecord::Migration[5.2]
  def change
    add_reference :diffusion_histories, :va_facility, foreign_key: true
    add_reference :practice_origin_facilities, :va_facility, foreign_key: true
  end
end

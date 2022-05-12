class AddClinicalResourceHubForeignKeyToDiffusionHistoriesAndPracticeOriginFacilities < ActiveRecord::Migration[5.2]
  def change
    add_reference :diffusion_histories, :clinical_resource_hub, foreign_key: true
    add_reference :practice_origin_facilities, :clinical_resource_hub, foreign_key: true
  end
end
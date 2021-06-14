class UpdateCategoryGroupings < ActiveRecord::Migration[5.2]
  def change
    strategic_rec = Category.create(name: "Strategic", short_name: "strategic", description: "Categories on strategical domain's",
                                  position: Category.maximum(:position).next, created_at: Time.now,
                                  updated_at: Time.now, is_other: false)

    strategy_id = strategic_rec.id
    clinical_rec = Category.find_by(name: 'Clinical')
    clinical_id = clinical_rec.id unless clinical_rec.blank?
    operational_rec = Category.find_by(name: 'Operational')
    operational_id = operational_rec.id unless operational_rec.blank?

    cur_others = Category.where(name: 'Other', parent_category_id: nil)
    if cur_others.blank?
      Category.create(name: "Other", short_name: "other", description: "Other",
                      parent_category_id: clinical_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cur_others.update(parent_category_id: clinical_id)
    end

    Category.create(name: "Other", short_name: "other", description: "Other",
                    parent_category_id: operational_id,  position: Category.maximum(:position).next,
                    created_at: Time.now, updated_at: Time.now, is_other: false)

    Category.create(name: "Other", short_name: "other", description: "Other",
                   parent_category_id: strategy_id,  position: Category.maximum(:position).next,
                   created_at: Time.now, updated_at: Time.now, is_other: false)

    Category.find_each do |cat|
      if cat.name == "Access to Care" || cat.name == "Age-Friendly" || cat.name == "COVID-19" || cat.name == "Employee Experience" || cat.name == "Health Equity" || cat.name == "High Reliability" || cat.name == "Moving Forward" || cat.name == "Suicide Prevention"
        cat.update(parent_category_id: strategy_id)
      elsif cat.name == "Building Management" || cat.name == "Contracting" || cat.name == "Healthcare Administration" || cat.name == "Information Technology" || cat.name == "Logistics" || cat.name == "Veterans Benefits" || cat.name == "Workforce Development"
        cat.update(parent_category_id: operational_id)
      elsif cat.name == "Anesthesiology" || cat.name == "Chaplain Care" || cat.name == "Continuity of Care" || cat.name == "Coordinated Care" || cat.name == "COVID-19 Testing and Screening" || cat.name == "Curbside Care" || cat.name == "Dentistry" || cat.name == "Dermatology" || cat.name == "Emergency Care" || cat.name == "Environmental Services" || cat.name == "Ethics in Health Care" || cat.name == "Geriatric Health" || cat.name == "Home Health" || cat.name == "Hospital Medicine" || cat.name == "Inpatient Care" || cat.name == "LGBT Health" || cat.name == "Medication Management" || cat.name == "Mental Health" || cat.name == "Nephrology" || cat.name == "Neurology" || cat.name == "Nursing" || cat.name == "Nutrition & Food" || cat.name == "Oncology" || cat.name == "Ophthalmology" || cat.name == "Outpatient Care" || cat.name == "Pathology" || cat.name == "Pharmacy" || cat.name == "Primary Care" || cat.name == "Prosthetic and Sensory Aids" || cat.name == "Psychiatry" || cat.name == "Pulmonary Care" || cat.name == "Radiology" || cat.name == "Rural Health" || cat.name == "Specialty Care" || cat.name == "Surgery" || cat.name == "Telehealth" || cat.name == "Urology" || cat.name == "Veteran Experience" || cat.name == "Whole Health" || cat.name == "Women's Health"
        cat.update(parent_category_id: clinical_id)
      end
    end

    #is_other ?  set any is_other = true's to parent_category_id clinical for now.. may need to adjust manually.
    is_others = Category.where(is_other: true)
    is_others.each do |rec|
      rec.update(parent_category_id: clinical_id)
    end
  end
end
class UpdateCategoryGroupings < ActiveRecord::Migration[5.2]
  def change
    strategic_rec = Category.create(name: "Strategic", short_name: "strategic", description: "Categories on strategical domain's",
                                  position: Category.maximum(:position).next, created_at: Time.now,
                                  updated_at: Time.now, is_other: false)

    strategy_id = strategic_rec.id
    clinical_rec = Category.find_by(name: 'Clinical')
    clinical_id = clinical_rec.id
    operational_rec = Category.find_by(name: 'Operational')
    operational_id = operational_rec.id

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
      if cat.name = "Access to Care" || "Age-Friendly" || "COVID-19" || "Employee Experience" || "Health Equity" || "High Reliability" || "Moving Forward" || "Suicide Prevention"
        cat.update(parent_category_id: strategy_id)
      elsif cat.name = "Building Management" || "Contracting" || "Healthcare Administration" || "Information Technology" || "Logistics" || "Veterans Benefits" || "Workforce Development"
        cat.update(parent_category_id: operational_id)
      elsif cat.name = "Anesthesiology" ||"Chaplain Care" || "Continuity of Care" || "Coordinated Care" || "COVID-19 Testing and Screening" || "Curbside Care" || "Dentistry" || "Dermatology" || "Emergency Care" || "Environmental Services" || "Ethics in Health Care" || "Geriatric Health" || "Home Health" || "Home Health" ||"Hospital Medicine" || "Inpatient Care" || "LGBT Health" || "Medication Management" || "Mental Health" || "Nephrology" || "Neurology" || "Neurology" || "Nursing" || "Nutrition & Food" || "Oncology" || "Ophthalmology" || "Outpatient Care" || "Pathology" || "Pharmacy" || "Primary Care" || "Prosthetic and Sensory Aids" || "Psychiatry" || "Pulmonary Care" || "Radiology" || "Rural Health" || "Specialty Care" || "Surgery" || "Telehealth" || "Urology" || "Veteran Experience" || "Whole Health" || "Women's Health"
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
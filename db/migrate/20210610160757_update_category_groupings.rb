class UpdateCategoryGroupings < ActiveRecord::Migration[5.2]
  def change
    num_cats = Category.count
    if num_cats == 0
      Category.create(name: "TEMP_CAT", short_name: "TEMP_CAT", description: "TEMP_CAT",
                      position: 0, created_at: Time.now,
                      updated_at: Time.now, is_other: false)
    end

    strategic_rec = Category.create(name: "Strategic", short_name: "strategic", description: "Categories on strategical domain's",
                                  position: Category.maximum(:position).next, created_at: Time.now,
                                  updated_at: Time.now, is_other: false)
    strategy_id = strategic_rec.id
    clinical_rec = Category.find_by(name: 'Clinical')
    if clinical_rec.blank?
      clinical_rec = Category.create(name: "Clinical", short_name: "Clinical", description: "Categories on clinical domain's",
                                      position: Category.maximum(:position).next, created_at: Time.now,
                                      updated_at: Time.now, is_other: false)
      clinical_id = clinical_rec.id
    else
      clinical_id = clinical_rec.id
    end

    operational_rec = Category.find_by(name: 'Operational')
    if operational_rec.blank?
      operational_rec = Category.create(name: "Operational", short_name: "operational", description: "Categories on operational domain's",
                                     position: Category.maximum(:position).next, created_at: Time.now,
                                     updated_at: Time.now, is_other: false)
      operational_id = operational_rec.id
    else
      operational_id = operational_rec.id
    end

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

    cat_rec = Category.find_by(name: "Access to Care")
    if cat_rec.blank?
      Category.create(name: "Access to Care", short_name: "access to care", description: "Access to Care",
                      parent_category_id: strategy_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: strategy_id)
    end

    cat_rec = Category.find_by(name: "Age-Friendly")
    if cat_rec.blank?
      Category.create(name: "Age-Friendly", short_name: "age-friendly", description: "Age-Friendly",
                      parent_category_id: strategy_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: strategy_id)
    end

    cat_rec = Category.find_by(name: "COVID-19")
    if cat_rec.blank?
      Category.create(name: "COVID-19", short_name: "COVID-19", description: "COVID-19",
                      parent_category_id: strategy_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: strategy_id)
    end

    cat_rec = Category.find_by(name: "Employee Experience")
    if cat_rec.blank?
      Category.create(name: "Employee Experience", short_name: "employee experience", description: "Employee Experience",
                      parent_category_id: strategy_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: strategy_id)
    end

    cat_rec = Category.find_by(name: "Health Equity")
      if cat_rec.blank?
        Category.create(name: "Health Equity", short_name: "health equity", description: "Health Equity",
                        parent_category_id: strategy_id,  position: Category.maximum(:position).next,
                        created_at: Time.now, updated_at: Time.now, is_other: false)
      else
        cat_rec.update(parent_category_id: strategy_id)
      end

    cat_rec = Category.find_by(name: "High Reliability")
    if cat_rec.blank?
      Category.create(name: "High Reliability", short_name: "high reliability", description: "High Reliability",
                      parent_category_id: strategy_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: strategy_id)
    end

    cat_rec = Category.find_by(name: "Moving Forward")
    if cat_rec.blank?
      Category.create(name: "Moving Forward", short_name: "moving forward", description: "Moving Forward",
                      parent_category_id: strategy_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: strategy_id)
    end

    cat_rec = Category.find_by(name: "Suicide Prevention")
    if cat_rec.blank?
      Category.create(name: "Suicide Prevention", short_name: "suicide prevention", description: "Suicide Prevention",
                      parent_category_id: strategy_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: strategy_id)
    end

    cat_rec = Category.find_by(name: "Building Management")
      if cat_rec.blank?
        Category.create(name: "Building Management", short_name: "building management", description: "Building Management",
                        parent_category_id: operational_id,  position: Category.maximum(:position).next,
                        created_at: Time.now, updated_at: Time.now, is_other: false)
      else
        cat_rec.update(parent_category_id: operational_id)
      end

    cat_rec = Category.find_by(name: "Contracting")
      if cat_rec.blank?
        Category.create(name: "Contracting", short_name: "contracting", description: "Contracting",
                        parent_category_id: operational_id,  position: Category.maximum(:position).next,
                        created_at: Time.now, updated_at: Time.now, is_other: false)
      else
        cat_rec.update(parent_category_id: operational_id)
      end

    cat_rec = Category.find_by(name: "Healthcare Administration")
    if cat_rec.blank?
      Category.create(name: "Healthcare Administration", short_name: "healthcare administration", description: "Healthcare Administration",
                      parent_category_id: operational_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: operational_id)
    end

    cat_rec = Category.find_by(name: "Information Technology")
        if cat_rec.blank?
          Category.create(name: "Information Technology", short_name: "Information technology", description: "Information Technology",
                          parent_category_id: operational_id,  position: Category.maximum(:position).next,
                          created_at: Time.now, updated_at: Time.now, is_other: false)
        else
          cat_rec.update(parent_category_id: operational_id)
        end

    cat_rec = Category.find_by(name: "Logistics")
    if cat_rec.blank?
      Category.create(name: "Logistics", short_name: "logistics", description: "Logistics",
                      parent_category_id: operational_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: operational_id)
    end

    cat_rec = Category.find_by(name: "Veterans Benefits")
      if cat_rec.blank?
        Category.create(name: "Veterans Benefits", short_name: "veterans benefits", description: "Veterans Benefits",
                        parent_category_id: operational_id,  position: Category.maximum(:position).next,
                        created_at: Time.now, updated_at: Time.now, is_other: false)
      else
        cat_rec.update(parent_category_id: operational_id)
      end

    cat_rec = Category.find_by(name: "Workforce Development")
    if cat_rec.blank?
      Category.create(name: "Workforce Development", short_name: "workforce development", description: "Workforce Development",
                      parent_category_id: operational_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: operational_id)
    end

    cat_rec = Category.find_by(name: "Anesthesiology")
    if cat_rec.blank?
      Category.create(name: "Anesthesiology", short_name: "anesthesiology", description: "Anesthesiology",
                      parent_category_id: clinical_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: clinical_id)
    end

    cat_rec = Category.find_by(name: "Chaplain Care")
    if cat_rec.blank?
      Category.create(name: "Chaplain Care", short_name: "chaplain care", description: "Chaplain Care",
                      parent_category_id: clinical_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: clinical_id)
    end

    cat_rec = Category.find_by(name: "Continuity of Care")
    if cat_rec.blank?
      Category.create(name: "Continuity of Care", short_name: "continuity of care", description: "Continuity of Care",
                      parent_category_id: clinical_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: clinical_id)
    end

    cat_rec = Category.find_by(name: "Coordinated Care")
    if cat_rec.blank?
      Category.create(name: "Coordinated Care", short_name: "coordinated care", description: "Coordinated Care",
                      parent_category_id: clinical_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: clinical_id)
    end

    cat_rec = Category.find_by(name: "COVID-19 Testing and Screening")
    if cat_rec.blank?
      Category.create(name: "COVID-19 Testing and Screening", short_name: "COVID-19 testing and screening", description: "COVID-19 Testing and Screening",
                      parent_category_id: clinical_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: clinical_id)
    end

    cat_rec = Category.find_by(name: "Curbside Care")
    if cat_rec.blank?
      Category.create(name: "Curbside Care", short_name: "curbside care", description: "Curbside Care",
                      parent_category_id: clinical_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: clinical_id)
    end

    cat_rec = Category.find_by(name: "Dentistry")
    if cat_rec.blank?
      Category.create(name: "Dentistry", short_name: "dentistry", description: "Dentistry",
                      parent_category_id: clinical_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: clinical_id)
    end

    cat_rec = Category.find_by(name: "Dermatology")
    if cat_rec.blank?
      Category.create(name: "Dermatology", short_name: "dermatology", description: "Dermatology",
                      parent_category_id: clinical_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: clinical_id)
    end

    cat_rec = Category.find_by(name: "Emergency Care")
    if cat_rec.blank?
      Category.create(name: "Emergency Care", short_name: "emergency care", description: "Emergency Care",
                      parent_category_id: clinical_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: clinical_id)
    end

    cat_rec = Category.find_by(name: "Environmental Services")
    if cat_rec.blank?
      Category.create(name: "Environmental Services", short_name: "environmental services", description: "Environmental Services",
                      parent_category_id: clinical_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: clinical_id)
    end

    cat_rec = Category.find_by(name: "Ethics in Health Care")
    if cat_rec.blank?
      Category.create(name: "Ethics in Health Care", short_name: "ethics in health care", description: "Ethics in Health Care",
                      parent_category_id: clinical_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: clinical_id)
    end

    cat_rec = Category.find_by(name: "Geriatric Health")
    if cat_rec.blank?
      Category.create(name: "Geriatric Health", short_name: "geriatric health", description: "Geriatric Health",
                      parent_category_id: clinical_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: clinical_id)
    end

    cat_rec = Category.find_by(name: "Home Health")
      if cat_rec.blank?
        Category.create(name: "Home Health", short_name: "home health", description: "Home Health",
                        parent_category_id: clinical_id,  position: Category.maximum(:position).next,
                        created_at: Time.now, updated_at: Time.now, is_other: false)
      else
        cat_rec.update(parent_category_id: clinical_id)
      end

    cat_rec = Category.find_by(name: "Hospital Medicine")
    if cat_rec.blank?
      Category.create(name: "Hospital Medicine", short_name: "hospital medicine", description: "Hospital Medicine",
                      parent_category_id: clinical_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: clinical_id)
    end

    cat_rec = Category.find_by(name: "Inpatient Care")
    if cat_rec.blank?
      Category.create(name: "Inpatient Care", short_name: "inpatient care", description: "Inpatient Care",
                      parent_category_id: clinical_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: clinical_id)
    end

    cat_rec = Category.find_by(name: "LGBT Health")
    if cat_rec.blank?
      Category.create(name: "LGBT Health", short_name: "LGBT health", description: "LGBT Health",
                      parent_category_id: clinical_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: clinical_id)
    end

    cat_rec = Category.find_by(name: "Medication Management")
    if cat_rec.blank?
      Category.create(name: "Medication Management", short_name: "medication management", description: "Medication Management",
                      parent_category_id: clinical_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: clinical_id)
    end


    cat_rec = Category.find_by(name: "Mental Health")
    if cat_rec.blank?
      Category.create(name: "Mental Health", short_name: "mental health", description: "Mental Health",
                      parent_category_id: clinical_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: clinical_id)
    end

    cat_rec = Category.find_by(name: "Nephrology")
    if cat_rec.blank?
      Category.create(name: "Nephrology", short_name: "nephrology", description: "Nephrology",
                      parent_category_id: clinical_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: clinical_id)
    end

    cat_rec = Category.find_by(name: "Neurology")
    if cat_rec.blank?
      Category.create(name: "Neurology", short_name: "neurology", description: "Neurology",
                      parent_category_id: clinical_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: clinical_id)
    end

    cat_rec = Category.find_by(name: "Nursing")
    if cat_rec.blank?
      Category.create(name: "Nursing", short_name: "nursing", description: "Nursing",
                      parent_category_id: clinical_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: clinical_id)
    end

    cat_rec = Category.find_by(name: "Nutrition & Food")
    if cat_rec.blank?
      Category.create(name: "Nutrition & Food", short_name: "nutrition & food", description: "Nutrition & Food",
                      parent_category_id: clinical_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: clinical_id)
    end

    cat_rec = Category.find_by(name: "Oncology")
    if cat_rec.blank?
      Category.create(name: "Oncology", short_name: "oncology", description: "Oncology",
                      parent_category_id: clinical_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: clinical_id)
    end

    cat_rec = Category.find_by(name: "Ophthalmology")
    if cat_rec.blank?
      Category.create(name: "Ophthalmology", short_name: "ophthalmology", description: "Ophthalmology",
                      parent_category_id: clinical_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: clinical_id)
    end

    cat_rec = Category.find_by(name: "Outpatient Care")
    if cat_rec.blank?
      Category.create(name: "Outpatient Care", short_name: "outpatient care", description: "Outpatient Care",
                      parent_category_id: clinical_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: clinical_id)
    end

    cat_rec = Category.find_by(name: "Pathology")
    if cat_rec.blank?
      Category.create(name: "Pathology", short_name: "pathology", description: "Pathology",
                      parent_category_id: clinical_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: clinical_id)
    end

    cat_rec = Category.find_by(name: "Pharmacy")
    if cat_rec.blank?
      Category.create(name: "Pharmacy", short_name: "pharmacy", description: "Pharmacy",
                      parent_category_id: clinical_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: clinical_id)
    end

    cat_rec = Category.find_by(name: "Primary Care")
    if cat_rec.blank?
      Category.create(name: "Primary Care", short_name: "primary care", description: "Primary Care",
                      parent_category_id: clinical_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: clinical_id)
    end

    cat_rec = Category.find_by(name: "Prosthetic and Sensory Aids")
    if cat_rec.blank?
      Category.create(name: "Prosthetic and Sensory Aids", short_name: "prosthetic and sensory aids", description: "Prosthetic and Sensory Aids",
                      parent_category_id: clinical_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: clinical_id)
    end

    cat_rec = Category.find_by(name: "Psychiatry")
    if cat_rec.blank?
      Category.create(name: "Psychiatry", short_name: "psychiatry", description: "Psychiatry",
                      parent_category_id: clinical_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: clinical_id)
    end

    cat_rec = Category.find_by(name: "Pulmonary Care")
    if cat_rec.blank?
      Category.create(name: "Pulmonary Care", short_name: "pulmonary care", description: "Pulmonary Care",
                      parent_category_id: clinical_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: clinical_id)
    end

    cat_rec = Category.find_by(name: "Radiology")
    if cat_rec.blank?
      Category.create(name: "Radiology", short_name: "radiology", description: "Radiology",
                      parent_category_id: clinical_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: clinical_id)
    end

    cat_rec = Category.find_by(name: "Rural Health")
    if cat_rec.blank?
      Category.create(name: "Rural Health", short_name: "rural health", description: "Rural Health",
                      parent_category_id: clinical_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: clinical_id)
    end

    cat_rec = Category.find_by(name: "Specialty Care")
    if cat_rec.blank?
      Category.create(name: "Specialty Care", short_name: "specialty care", description: "Specialty Care",
                      parent_category_id: clinical_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: clinical_id)
    end

    cat_rec = Category.find_by(name: "Surgery")
    if cat_rec.blank?
      Category.create(name: "Surgery", short_name: "surgery", description: "Surgery",
                      parent_category_id: clinical_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: clinical_id)
    end

    cat_rec = Category.find_by(name: "Telehealth")
    if cat_rec.blank?
      Category.create(name: "Telehealth", short_name: "telehealth", description: "Telehealth",
                      parent_category_id: clinical_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: clinical_id)
    end

    cat_rec = Category.find_by(name: "Urology")
    if cat_rec.blank?
      Category.create(name: "Urology", short_name: "urology", description: "Urology",
                      parent_category_id: clinical_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: clinical_id)
    end

    cat_rec = Category.find_by(name: "Veteran Experience")
    if cat_rec.blank?
      Category.create(name: "Veteran Experience", short_name: "veteran experience", description: "Veteran Experience",
                      parent_category_id: clinical_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: clinical_id)
    end

    cat_rec = Category.find_by(name: "Whole Health")
    if cat_rec.blank?
      Category.create(name: "Whole Health", short_name: "whole health", description: "Whole Health",
                      parent_category_id: clinical_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: clinical_id)
    end

    cat_rec = Category.find_by(name: "Women's Health")
    if cat_rec.blank?
      Category.create(name: "Women's Health", short_name: "women's health", description: "Women's Health",
                      parent_category_id: clinical_id,  position: Category.maximum(:position).next,
                      created_at: Time.now, updated_at: Time.now, is_other: false)
    else
      cat_rec.update(parent_category_id: clinical_id)
    end

    #is_other ?  set any is_other = true's to parent_category_id clinical for now.. may need to adjust manually.
    is_others = Category.where(is_other: true)
    is_others.each do |rec|
      rec.update(parent_category_id: clinical_id)
    end
    if num_cats == 0
      Category.find_by(name: 'TEMP_CAT').destroy
    end
  end
end
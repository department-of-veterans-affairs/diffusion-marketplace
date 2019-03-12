# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#

if StrategicSponsor.all.blank?
  puts 'Seeding Database...'
  sponsors = [
      StrategicSponsor.create!(name: 'VISN', short_name: 'visn', description: 'Sponsored by at least one VISN'),
      StrategicSponsor.create!(name: 'Diffusion of Excellence', short_name: 'diffusion_of_excellence', description: 'Sponsored by Diffusion of Excellence'),
      StrategicSponsor.create!(name: 'Office of Rural Health', short_name: 'office_of_rural_heath', description: 'Sponsored by the Office of Rural Health'),
      StrategicSponsor.create!(name: 'HSR&D', short_name: 'hsrd', description: 'Sponsored by HASR&D'),
      StrategicSponsor.create!(name: 'VHA System Redesign', short_name: 'vha_system_redesign', description: 'Sponsored by VHA System Redesign'),
      StrategicSponsor.create!(name: 'VHA Office of Connected Care', short_name: 'vha_office_of_connected_care', description: 'Sponsored by the VHA Office of Connected Care'),
      StrategicSponsor.create!(name: 'Office of Prosthetics and Rehabilitation', short_name: 'office_of_prosthetics_and_rehabilitation', description: 'Sponsored by the Office of Prosthetics and Rehabilitation'),
      StrategicSponsor.create!(name: 'Office of Mental Health and Suicide Prevention (OMHSP)', short_name: 'omhsp', description: 'Sponsored by the Office of Mental Health and Suicide Prevention (OMHSP)'),
      StrategicSponsor.create!(name: 'National Opioid Overdose Education Naloxone Distribution (OEND) Program Office', short_name: 'oend', description: 'Sponsored by the National Opioid Overdose Education Naloxone Distribution Program Office'),
      StrategicSponsor.create!(name: 'Pharmacy Benefits Management (PBM)', short_name: 'pbm', description: 'Sponsored by the Pharmacy Benefits Management (PBM)'),
      StrategicSponsor.create!(name: 'Academic Detailing Service', short_name: 'ads', description: 'Sponsored by the Academic Detailing Service'),
      StrategicSponsor.create!(name: 'National Center for Patient Safety (NCPS)', short_name: 'ncps', description: 'Sponsored by the National Center for Patient Safety (NCPS)'),
      StrategicSponsor.create!(name: 'VA Police', short_name: 'va_police', description: 'Sponsored by the VA Police'),
      StrategicSponsor.create!(name: 'None', short_name: 'none', description: 'Not Sponsored'),
  ]

  23.times do |t|
    StrategicSponsor.create!(name: "VISN #{t}", short_name: "visn_#{t}", description: "Vetted by VISN #{t}")
  end

  unless Badge.all.present?
    badge_image_base_path = "#{Rails.root}/db/seed_images/badges"
    badges = [
        Badge.create!(name: 'VHA System Redesign', short_name: 'vha_system_redesign', description: 'Vetted by VHA System Redesign', strategic_sponsor: sponsors[4],
                      icon: 'fas fa-cogs', color: '#FE4497'),
        Badge.create!(name: 'VHA Office of Connected Care', short_name: 'vha_office_of_connected_care', description: 'Vetted by the VHA Office of Connected Care', strategic_sponsor: sponsors[5],
                      icon: 'fas fa-hand-holding-heart', color: '#E52107'),
        Badge.create!(name: 'Health Systems Research & Design', short_name: 'hsrd', description: 'Vetted by Health Systems Research & Design', strategic_sponsor: sponsors[3],
                      icon: 'fas fa-microscope', color: '#9058D3'),
        Badge.create!(name: 'Office of Rural Health', short_name: 'office_of_rural_health', description: 'Vetted by the Office of Rural Health', strategic_sponsor: sponsors[2],
                      icon: 'fas fa-mountain', color: '#1CC2AE'),
        Badge.create!(name: 'Diffusion of Excellence', short_name: 'diffusion_of_excellence', description: 'Vetted by Diffusion of Excellence', strategic_sponsor: sponsors[1],
                      icon: 'fas fa-certificate', color: '#0076D6'),
        Badge.create!(name: 'Shark Tank Approved', short_name: 'shark_tank_approved', description: 'Shark Tank Approved', strategic_sponsor: sponsors[1],
                      icon: 'fas fa-fish', color: '#0076D6'),
        Badge.create!(name: 'Top 100 Shark Tank', short_name: 'shark_tank_100', description: 'Top 100 Shark Tank finisher', strategic_sponsor: sponsors[1],
                      icon: 'fas fa-fish', color: '#0076D6'),
        Badge.create!(name: 'Top 20 Shark Tank', short_name: 'shark_tank_20', description: 'Top 20 Shark Tank finisher', strategic_sponsor: sponsors[1],
                      icon: 'fas fa-fish', color: '#0076D6'),
        Badge.create!(name: 'Gold Status Practice', short_name: 'gold_status', description: 'Gold Status Practice', strategic_sponsor: sponsors[1],
                      icon: 'fas fa-heart', color: '#E4A002'),
        Badge.create!(name: 'Authority to Operate (ATO)', short_name: 'ato', description: 'Authority to Operate (ATO) - applies to OIT projects', strategic_sponsor: sponsors.last,
                      icon: 'fas fa-check', color: '#E52107'),
        Badge.create!(name: 'VISN', short_name: 'visn', description: 'Vetted by at least one VISN', strategic_sponsor: sponsors.find {|s| s.name == 'VISN'},
                      icon: 'fas fa-hospital-alt', color: '#E4A002'),
    ]

    23.times do |t|
      i = t + 1
      badges << Badge.create!(name: "VISN #{i}", short_name: "visn_#{i}", description: "Vetted by VISN #{i}", strategic_sponsor: sponsors.find {|s| s.name == "VISN #{i}"},
                              icon: 'fas fa-hospital', color: '#E4A002'
      )
    end
  end

  unless VaSecretaryPriority.all.present?
    va_secretary_priorities = [
        VaSecretaryPriority.create!(name: 'Giving Veterans choice', short_name: 'giving_veterans_choice', description: 'Giving verterans choice'),
        VaSecretaryPriority.create!(name: 'Modernizing the VA', short_name: 'modernizing_the_va', description: 'Modernization the VA'),
        VaSecretaryPriority.create!(name: 'Improving the timeliness of services', short_name: 'improving_timeliness', description: 'Improving the timeliness of services'),
        VaSecretaryPriority.create!(name: 'Focusing resources based on importance', short_name: 'focusing_resources', description: 'Focusing resources based on importance'),
        VaSecretaryPriority.create!(name: 'Preventing suicide', short_name: 'preventing_suicide', description: 'Preventing suicide'),
    ]
  end

  unless ImpactCategory.all.present?
    impact_categories = [
        ImpactCategory.create!(name: 'Clinical', short_name: 'clinical', description: 'Impacts on clinical domains'),
        ImpactCategory.create!(name: 'Operational', short_name: 'operational', description: 'Impacts on operational domains'),
    ]

    clinical_impacts = [
        Impact.create!(name: 'Allergy and Immunology', short_name: 'allergy_and_immunology', description: 'Allergy and Immunology', impact_category: impact_categories[0]),
        Impact.create!(name: 'Cardiology', short_name: 'cardiology', description: 'Cardiology', impact_category: impact_categories[0]),
        Impact.create!(name: 'Critical Care (ICU)', short_name: 'icu', description: 'Critical Care (ICU)', impact_category: impact_categories[0]),
        Impact.create!(name: 'Dermatology', short_name: 'dermatology', description: 'Dermatology', impact_category: impact_categories[0]),
        Impact.create!(name: 'Endocrinology', short_name: 'endocrinology', description: 'Endocrinology', impact_category: impact_categories[0]),
        Impact.create!(name: 'Hematology', short_name: 'hematology', description: 'Hematology', impact_category: impact_categories[0]),
        Impact.create!(name: 'Infectious Disease', short_name: 'infectious_disease', description: 'Infectious Disease', impact_category: impact_categories[0]),
        Impact.create!(name: 'Mental Health / Psychiatry', short_name: 'mental_health_psychiatry', description: 'Mental Health / Psychiatry', impact_category: impact_categories[0]),
        Impact.create!(name: 'Neurology', short_name: 'neurology', description: 'Neurology', impact_category: impact_categories[0]),
        Impact.create!(name: 'Obstetrics & Gynecology', short_name: 'obstetrics_gynecology', description: 'Obstetrics & Gynecology', impact_category: impact_categories[0]),
        Impact.create!(name: 'Oncology', short_name: 'oncology', description: 'Oncology', impact_category: impact_categories[0]),
        Impact.create!(name: 'Ophthalmology', short_name: 'ophthalmology', description: 'Ophthalmology', impact_category: impact_categories[0]),
        Impact.create!(name: 'Orthopedic Surgery', short_name: 'orthopedic_surgery', description: 'Orthopedic Surgery', impact_category: impact_categories[0]),
        Impact.create!(name: 'Otolaryngology (ENT)', short_name: 'ent', description: 'Otolaryngology (ENT)', impact_category: impact_categories[0]),
        Impact.create!(name: 'Pathology', short_name: 'pathology', description: 'Pathology', impact_category: impact_categories[0]),
        Impact.create!(name: 'Pediatrics', short_name: 'pediatrics', description: 'Pediatrics', impact_category: impact_categories[0]),
        Impact.create!(name: 'Primary Care / Preventive Medicine', short_name: 'primary_care_preventive_medicine', description: 'Primary Care / Preventive Medicine', impact_category: impact_categories[0]),
        Impact.create!(name: 'Pulmonology / Respiratory', short_name: 'pulmonology_respiratory', description: 'Pulmonology / Respiratory', impact_category: impact_categories[0]),
        Impact.create!(name: 'Rehab Medicine', short_name: 'rehab_medicine', description: 'Rehab Medicine', impact_category: impact_categories[0]),
        Impact.create!(name: 'Renal / Nephrology', short_name: 'renal_nephrology', description: 'Renal / Nephrology', impact_category: impact_categories[0]),
        Impact.create!(name: 'Rheumatology', short_name: 'rheumatology', description: 'Rheumatology', impact_category: impact_categories[0]),
        Impact.create!(name: 'Specialty Care (outside of VA)', short_name: 'specialty_care_outside_of_va)', description: 'Specialty Care (outside of VA)', impact_category: impact_categories[0]),
        Impact.create!(name: 'Surgery', short_name: 'surgery', description: 'Surgery', impact_category: impact_categories[0]),
        Impact.create!(name: 'Toxicology', short_name: 'toxicology', description: 'Toxicology', impact_category: impact_categories[0]),
        Impact.create!(name: 'Urology', short_name: 'urology', description: 'Urology', impact_category: impact_categories[0]),
        Impact.create!(name: 'Prosthetics and Rehabilitation', short_name: 'prosthetics_and_rehabilitation', description: 'Prosthetics and Rehabilitation', impact_category: impact_categories[0]),
        Impact.create!(name: 'Alternative Therapies', short_name: 'alternative_therapies', description: 'Alternative Therapies', impact_category: impact_categories[0]),
        Impact.create!(name: 'Massage', short_name: 'massage', description: 'Massage', impact_category: impact_categories[0]),
        Impact.create!(name: 'Herbal Remedies', short_name: 'herbal_remedies', description: 'Herbal Remedies', impact_category: impact_categories[0]),
        Impact.create!(name: 'Acupuncture', short_name: 'acupuncture', description: 'Acupuncture', impact_category: impact_categories[0]),
        Impact.create!(name: 'Dental', short_name: 'dental', description: 'Dental', impact_category: impact_categories[0]),
        Impact.create!(name: 'Homeless services', short_name: 'homeless_services', description: 'Homeless services', impact_category: impact_categories[0]),
        Impact.create!(name: 'Social workers', short_name: 'social_workers', description: 'Social workers', impact_category: impact_categories[0]),
        Impact.create!(name: 'None', short_name: 'none', description: 'No clinical impact', impact_category: impact_categories[0]),
    ]

    operational_impacts = [
        Impact.create!(name: 'Administration', short_name: 'administration', description: 'Administration', impact_category: impact_categories[1]),
        Impact.create!(name: 'Billing', short_name: 'billing', description: 'Billing', impact_category: impact_categories[1]),
        Impact.create!(name: 'Biomed', short_name: 'biomed', description: 'Biomed', impact_category: impact_categories[1]),
        Impact.create!(name: 'Building Management', short_name: 'building_management', description: 'Building Management', impact_category: impact_categories[1]),
        Impact.create!(name: 'Education and Training', short_name: 'education_and_training', description: 'Education and Training', impact_category: impact_categories[1]),
        Impact.create!(name: 'Food Service', short_name: 'food_service', description: 'Food Service', impact_category: impact_categories[1]),
        Impact.create!(name: 'Human Resources', short_name: 'human_resources', description: 'Human Resources', impact_category: impact_categories[1]),
        Impact.create!(name: 'Information Technology', short_name: 'information_technology', description: 'Information Technology', impact_category: impact_categories[1]),
        Impact.create!(name: 'Logistics', short_name: 'logistics', description: 'Logistics', impact_category: impact_categories[1]),
        Impact.create!(name: 'Maintenance', short_name: 'maintenance', description: 'Maintenance', impact_category: impact_categories[1]),
        Impact.create!(name: 'Marketing', short_name: 'marketing', description: 'Marketing', impact_category: impact_categories[1]),
        Impact.create!(name: 'Medical Records', short_name: 'medical_records', description: 'Medical Records', impact_category: impact_categories[1]),
        Impact.create!(name: 'Occupational Health', short_name: 'occupational_health', description: 'Occupational Health', impact_category: impact_categories[1]),
        Impact.create!(name: 'Quality Control', short_name: 'quality_control', description: 'Quality Control', impact_category: impact_categories[1]),
        Impact.create!(name: 'Risk Management', short_name: 'risk_management', description: 'Risk Management', impact_category: impact_categories[1]),
        Impact.create!(name: 'Social Services', short_name: 'social_services', description: 'Social Services', impact_category: impact_categories[1]),
        Impact.create!(name: 'Contracting & Purchasing', short_name: 'contracting_purchasing', description: 'Contracting & Purchasing', impact_category: impact_categories[1]),
        Impact.create!(name: 'None', short_name: 'none', description: 'No clinical impact', impact_category: impact_categories[1]),
    ]
  end

  unless JobPosition.all.present?
    job_positions = [
        JobPosition.create!(name: 'Clinic based nurse', short_name: 'clinic_based_nurse', description: 'Clinic based nurse'),
        JobPosition.create!(name: 'Clinic based physician', short_name: 'clinic_based_physician', description: 'Clinic based physician'),
        JobPosition.create!(name: 'Hospital based nurse', short_name: 'hospital_based_nurse', description: 'Hospital based nurse'),
        JobPosition.create!(name: 'Hospital based physician', short_name: 'hospital_based_physician', description: 'Hospital based physician'),
        JobPosition.create!(name: 'Nursing Assistant', short_name: 'nursing_assistant', description: 'Nursing Assistant'),
        JobPosition.create!(name: 'Pharmacist', short_name: 'pharmacist', description: 'Pharmacist'),
        JobPosition.create!(name: 'Pharmacy Tech', short_name: 'pharmacy_tech', description: 'Pharmacy Tech'),
        JobPosition.create!(name: 'Researcher', short_name: 'researcher', description: 'Researcher'),
        JobPosition.create!(name: 'Prosthetist', short_name: 'prosthetist', description: 'Prosthetist'),
        JobPosition.create!(name: 'Purchasing Agent', short_name: 'purchasing_agent', description: 'Purchasing Agent'),
        JobPosition.create!(name: 'Dentist', short_name: 'dentist', description: 'Dentist'),
    ]
  end

  unless ClinicalCondition.all.present?
    clinical_conditions = [
        ClinicalCondition.create!(name: 'Back Pain', short_name: 'back_pain', description: 'Back pain'),
        ClinicalCondition.create!(name: 'Chronic Obstructive Pulmonary Disease (COPD)', short_name: 'copd', description: 'Chronic Obstructive Pulmonary Disease (COPD)'),
        ClinicalCondition.create!(name: 'Chronic Pain', short_name: 'chronic_pain', description: 'Chronic Pain'),
        ClinicalCondition.create!(name: 'Congestive Heart Failure (CHF)', short_name: 'chf', description: 'Congestive Heart Failure (CHF)'),
        ClinicalCondition.create!(name: 'Depression', short_name: 'depression', description: 'Depression'),
        ClinicalCondition.create!(name: 'Diabetes Melitus', short_name: 'diabetes_melitus', description: 'Diabetes Melitus'),
        ClinicalCondition.create!(name: 'Headache', short_name: 'headache', description: 'Headache'),
        ClinicalCondition.create!(name: 'Hearing Loss', short_name: 'hearing_loss', description: 'Hearing Loss'),
        ClinicalCondition.create!(name: 'Hypertension', short_name: 'hypertension', description: 'Hypertension'),
        ClinicalCondition.create!(name: 'Obesity', short_name: 'obesity', description: 'Obesity'),
        ClinicalCondition.create!(name: 'Post-Traumatic Stress Disorder', short_name: 'ptsd', description: 'Post-Traumatic Stress Disorder'),
        ClinicalCondition.create!(name: 'Sleep Apnea', short_name: 'sleep_apnea', description: 'Sleep Apnea'),
        ClinicalCondition.create!(name: 'Smoking', short_name: 'smoking', description: 'Smoking'),
        ClinicalCondition.create!(name: 'Suicide', short_name: 'suicide', description: 'Suicide'),
        ClinicalCondition.create!(name: 'Prosthetic Limbs', short_name: 'prosthetic_limbs', description: 'Prosthetic Limbs'),
        ClinicalCondition.create!(name: 'Sensory Aids', short_name: 'sensory_aids', description: 'Sensory Aids'),
        ClinicalCondition.create!(name: 'Amputation', short_name: 'amputation', description: 'Amputation'),
        ClinicalCondition.create!(name: 'Hospital acquired pneumonia', short_name: 'hospital_acquired_pneumonia', description: 'Hospital acquired pneumonia'),
        ClinicalCondition.create!(name: 'Addiction', short_name: 'addiction', description: 'Addiction'),
        ClinicalCondition.create!(name: 'Accidental overdose', short_name: 'accidental_overdose', description: 'Accidental overdose'),
        ClinicalCondition.create!(name: 'Hospital acquired pneumonia', short_name: 'hospital_acquired_pneumonia', description: 'Hospital acquired pneumonia'),
    ]
  end

  unless AncillaryService.all.present?
    ancillary_services = [
        AncillaryService.create!(name: 'Audiology', short_name: 'audiology', description: 'Audiology'),
        AncillaryService.create!(name: 'Laboratory', short_name: 'laboratory', description: 'Laboratory'),
        AncillaryService.create!(name: 'Occupational Therapy', short_name: 'occupational_therapy', description: 'Occupational Therapy'),
        AncillaryService.create!(name: 'Physical Therapy', short_name: 'physical_therapy', description: 'Physical Therapy'),
        AncillaryService.create!(name: 'Radiology', short_name: 'radiology', description: 'Radiology'),
        AncillaryService.create!(name: 'Rehabilitation & Prosthetics', short_name: 'rehabilitation_prosthetics', description: 'Rehabilitation & Prosthetics'),
        AncillaryService.create!(name: 'Social Work', short_name: 'social_work', description: 'Social Work'),
        AncillaryService.create!(name: 'Spiritual Services', short_name: 'spiritual_services', description: 'Spiritual Services'),
        AncillaryService.create!(name: 'Pharmacy', short_name: 'pharmacy', description: 'Pharmacy'),
    ]
  end

  unless ClinicalLocation.all.present?
    clinical_locations = [
        ClinicalLocation.create!(name: 'Alcohol and Other Drug Abuse (AODA) treatment center', short_name: 'aoda', description: 'Alcohol and Other Drug Abuse (AODA) treatment center'),
        ClinicalLocation.create!(name: 'Assisted Living Facility', short_name: 'assisted_living_facility', description: 'Assisted Living Facility'),
        ClinicalLocation.create!(name: 'Community Based Outpatient Clinic (CBOC)', short_name: 'cboc', description: 'Community Based Outpatient Clinic (CBOC)'),
        ClinicalLocation.create!(name: 'Community Living Centers (CLC)', short_name: 'clc', description: 'Community Living Centers (CLC)'),
        ClinicalLocation.create!(name: 'Home Health', short_name: 'home_health', description: 'Home Health'),
        ClinicalLocation.create!(name: 'Hospice Center', short_name: 'hospice_center', description: 'Hospice Center'),
        ClinicalLocation.create!(name: 'Inpatient Hospital', short_name: 'inpatient_hospital', description: 'Inpatient Hospital'),
        ClinicalLocation.create!(name: 'Outpatient Surgery Center', short_name: 'outpatient_surgery_center', description: 'Outpatient Surgery Center'),
        ClinicalLocation.create!(name: 'Pain Clinic', short_name: 'pain_clinic', description: 'Pain Clinic'),
        ClinicalLocation.create!(name: 'Skilled Nursing Facility (SNF)', short_name: 'snf', description: 'Skilled Nursing Facility (SNF)'),
    ]
  end

  unless DevelopingFacilityType.all.present?
    developing_facilities = [
        DevelopingFacilityType.create!(name: 'CBOC', short_name: 'cboc'),
        DevelopingFacilityType.create!(name: 'VA Medical Center', short_name: 'va_medical_center'),
        DevelopingFacilityType.create!(name: 'VA Program Office', short_name: 'va_program_office'),
        DevelopingFacilityType.create!(name: 'Outside of VA', short_name: 'outside_of_va'),
        DevelopingFacilityType.create!(name: 'Vendor', short_name: 'vendor'),
        DevelopingFacilityType.create!(name: 'Community Living Center (CLC)', short_name: 'clc'),
        DevelopingFacilityType.create!(name: 'Office of Mental Health', short_name: 'office_of_mental_health'),
    ]
  end

  unless PracticeManagement.all.present?
    area_of_affects = [
        PracticeManagement.create!(name: 'Wait time to be seen'),
        PracticeManagement.create!(name: 'Doctor to patient time'),
        PracticeManagement.create!(name: 'Throughput'),
        PracticeManagement.create!(name: 'Discharge process'),
        PracticeManagement.create!(name: 'Discharge planning'),
        PracticeManagement.create!(name: 'Patient satisfaction'),
        PracticeManagement.create!(name: 'Provider/Staff retention'),
        PracticeManagement.create!(name: 'Provider/Staff satisfaction'),
        PracticeManagement.create!(name: 'Efficiency'),
        PracticeManagement.create!(name: 'Cost avoidance'),
        PracticeManagement.create!(name: 'Management'),
        PracticeManagement.create!(name: 'None')
    ]
  end

  unless Department.all.present?
    departments = [
        Department.create!(name: 'Admissions', short_name: 'admissions'),
        Department.create!(name: 'Anesthetics', short_name: 'anesthetics'),
        Department.create!(name: 'Center Supply', short_name: 'center_supply'),
        Department.create!(name: 'Chaplaincy', short_name: 'chaplaincy'),
        Department.create!(name: 'Coronary Care Unit', short_name: 'coronary_care_unit'),
        Department.create!(name: 'Critical Care', short_name: 'critical_care'),
        Department.create!(name: 'Diagnostic Imaging/X-ray/Radiology', short_name: 'diagnostic _imaging_x-ray_Radiology'),
        Department.create!(name: 'Discharge Planning', short_name: 'discharge_planning'),
        Department.create!(name: 'Elderly Services', short_name: 'elderly_services'),
        Department.create!(name: 'Emergency Services', short_name: 'emergency_services'),
        Department.create!(name: 'Finance Department', short_name: 'finance_department'),
        Department.create!(name: 'House Keeping', short_name: 'house_keeping'),
        Department.create!(name: 'Security', short_name: 'security'),
        Department.create!(name: 'Laundry', short_name: 'laundry'),
        Department.create!(name: 'Parking', short_name: 'parking'),
        Department.create!(name: 'General Surgery', short_name: 'general_surgery'),
        Department.create!(name: 'Occupational Health and Safety', short_name: 'occupational_health_and_safety'),
        Department.create!(name: 'Intensive Care Unit', short_name: 'intensive_care_unit'),
        Department.create!(name: 'Human Resources', short_name: 'human_resources'),
        Department.create!(name: 'Infection Control', short_name: 'infection_control'),
        Department.create!(name: 'Information Management', short_name: 'information_management'),
        Department.create!(name: 'Maternity', short_name: 'maternity'),
        Department.create!(name: 'Medical Records', short_name: 'medical_records'),
        Department.create!(name: 'Microbiology', short_name: 'microbiology'),
        Department.create!(name: 'Nutrition and Dietetics', short_name: 'nutrition_and_dietetics'),
        Department.create!(name: 'Patient Accounts', short_name: 'patient_accounts'),
        Department.create!(name: 'Patient Services', short_name: 'patient_services'),
        Department.create!(name: 'Pharmacy', short_name: 'pharmacy'),
        Department.create!(name: 'Physiotherapy', short_name: 'physiotherapy'),
        Department.create!(name: 'Purchasing and Supplies', short_name: 'purchasing_and_supplies'),
        Department.create!(name: 'Radiology', short_name: 'radiology'),
        Department.create!(name: 'Radiotherapy', short_name: 'radiotherapy'),
        Department.create!(name: 'Social Work', short_name: 'social_work'),
        Department.create!(name: 'None', short_name: 'none'),
    ]
  end

  ### USERS ###
  User.create!(email: 'demo@va.gov', password: 'Demo#123', password_confirmation: 'Demo#123', skip_va_validation: true, confirmed_at: Time.now)
  User.create!(email: 'tom@skylight.digital', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now).add_role(User::USER_ROLES[1].to_sym)
  User.create!(email: 'aurora.hay@agile6.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now).add_role(User::USER_ROLES[1].to_sym)
  User.create!(email: 'jake.holzhauer@agile6.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now).add_role(User::USER_ROLES[1].to_sym)
  User::USER_ROLES.each_with_index do |role, index|
    User.create!(email: "A6test#{index}@agile6.com", password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now).add_role(User::USER_ROLES[index].to_sym)
  end

else
  puts 'Database already seeded... Nothing to do.'
end

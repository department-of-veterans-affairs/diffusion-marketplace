# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#

if PracticePartner.all.blank?
  puts 'Seeding Database...'

  sponsors = [
      PracticePartner.create!(name: 'Diffusion of Excellence', short_name: '', description: 'The Diffusion of Excellence Initiative helps to identify and disseminate clinical and administrative best practices through a learning environment that empowers its top performers to apply their innovative ideas throughout the system — further establishing VA as a leader in health care while promoting positive outcomes for Veterans.', icon: 'fas fa-heart', color: '#E4A002'),
      PracticePartner.create!(name: 'Office of Rural Health', short_name: 'ORH', description: 'ORH fulfills its mission by supporting targeted research, developing innovative programs, and identifying new care models in order to break down the barriers separating rural Veterans from quality care.', icon: 'fas fa-mountain', color: '#1CC2AE'),
      PracticePartner.create!(name: 'Health Services Research & Development', short_name: 'HSR&D', description: 'The HSR&D pursues research that underscores all aspects of VA healthcare: patient care, care delivery, health outcomes, cost, and quality. Within VA HSR&D, researchers focus on identifying and evaluating innovative strategies that lead to accessible, high quality, cost-effective care for Veterans and the nation.', icon: 'fas fa-microscope', color: '#9058D3'),
      PracticePartner.create!(name: 'VHA System Redesign', short_name: 'SR', description: 'The Office of Connected Care brings VA digital technology to Veterans and health care professionals, extending access to care beyond the traditional office visit.', icon: 'fas fa-cogs', color: '#FE4497'),
      PracticePartner.create!(name: 'VHA Office of Connected Care', short_name: 'OCC', description: 'The Office of Connected Care brings VA digital technology to Veterans and health care professionals, extending access to care beyond the traditional office visit. Through virtual technology, VA is able to deliver care to patients where and when they need it.', icon: 'fas fa-hand-holding-heart', color: '#E52107'),
      PracticePartner.create!(name: 'Office of Prosthetics and Rehabilitation', short_name: '', description: 'Rehabilitation and Prosthetic Services is committed to providing the highest quality, comprehensive, interdisciplinary care; the most advanced medical devices and products that are commercially available; and, promoting advancements in rehabilitative care and evidence-based treatment.', icon: 'fas fa-certificate', color: '#0076D6'),
      PracticePartner.create!(name: 'Office of Mental Health and Suicide Prevention', short_name: 'OMHSP', description: 'For the U.S. Department of Veterans Affairs (VA), nothing is more important than supporting the health and well-being of the Nation’s Veterans and their families. A major part of that support is providing timely access to high-quality, evidence-based mental health care. VA aims to address Veterans’ needs, during Service members’ reintegration into civilian life and beyond.', icon: 'fas fa-certificate', color: '#0076D6'),
      PracticePartner.create!(name: 'National Opioid Overdose Education Naloxone Distribution (OEND) Program Office', short_name: 'oend', description: 'Sponsored by the National Opioid Overdose Education Naloxone Distribution Program Office', icon: 'fas fa-certificate', color: '#0076D6'),
      PracticePartner.create!(name: 'Pharmacy Benefits Management (PBM)', short_name: 'pbm', description: 'Sponsored by the Pharmacy Benefits Management (PBM)', icon: 'fas fa-certificate', color: '#0076D6'),
      PracticePartner.create!(name: 'Academic Detailing Service', short_name: 'ads', description: 'Sponsored by the Academic Detailing Service', icon: 'fas fa-certificate', color: '#0076D6'),
      PracticePartner.create!(name: 'National Center for Patient Safety (NCPS)', short_name: 'ncps', description: 'Sponsored by the National Center for Patient Safety (NCPS)', icon: 'fas fa-certificate', color: '#0076D6'),
      PracticePartner.create!(name: 'VA Police', short_name: 'va_police', description: 'Sponsored by the VA Police', icon: 'fas fa-certificate', color: '#0076D6'),
      PracticePartner.create!(name: 'Veterans Experience Office', short_name: 'VEO', description: 'The VEO’s goal is to enable VA to be the leading customer service organization in government so that Veterans, their families, caregivers, and survivors Choose VA. VEO implements solutions based on Veteran-centered designs and industry best practices.', icon: 'fas fa-certificate', color: '#0076D6'),
      PracticePartner.create!(name: 'Quality Enhancement Research Initiative', short_name: 'QUERI', description: 'QUERI is committed to ensuring that research gets used effectively to ultimately sustain improvements in care for Veterans.', icon: 'fas fa-certificate', color: '#0076D6'),
      PracticePartner.create!(name: 'Office of Information and Technology', short_name: 'OIT', description: '', icon: 'fas fa-certificate', color: '#0076D6'),
      PracticePartner.create!(name: 'VHA Innovators Network', short_name: 'INET', description: '', icon: 'fas fa-certificate', color: '#0076D6'),
  ]

  unless VaSecretaryPriority.all.present?
    va_secretary_priorities = [
        VaSecretaryPriority.create!(name: 'Giving Veterans choice', short_name: 'giving_veterans_choice', description: 'Giving verterans choice'),
        VaSecretaryPriority.create!(name: 'Modernizing the VA', short_name: 'modernizing_the_va', description: 'Modernization the VA'),
        VaSecretaryPriority.create!(name: 'Improving the timeliness of services', short_name: 'improving_timeliness', description: 'Improving the timeliness of services'),
        VaSecretaryPriority.create!(name: 'Focusing resources based on importance', short_name: 'focusing_resources', description: 'Focusing resources based on importance'),
        VaSecretaryPriority.create!(name: 'Preventing suicide', short_name: 'preventing_suicide', description: 'Preventing suicide'),
    ]
  end

  unless Domain.all.present?
    domains = [
        Domain.create!(name: 'Veteran', description: 'Enables an improvement in satisfaction or customer experience for Veterans'),
        Domain.create!(name: 'Clinical', description: 'Produces an improvement in health outcomes'),
        Domain.create!(name: 'Financial', description: 'Generates cost savings or enables cost avoidance'),
        Domain.create!(name: 'Operational', description: 'Delivers a measure of increased efficiency or productivity in operational activities'),
        Domain.create!(name: 'Societal', description: 'Delivers a collective benefit to society or healthcare community as a whole'),
    ]
  end

  unless Category.all.present?
    impact_categories = [
        Category.create!(name: 'Clinical', short_name: 'clinical', description: 'Categorys on clinical domains'),
        Category.create!(name: 'Operational', short_name: 'operational', description: 'Categorys on operational domains'),
    ]

    clinical_impacts = [
        Category.create!(name: 'Allergy and Immunology', short_name: 'allergy_and_immunology', description: 'Allergy and Immunology', parent_category: impact_categories[0]),
        Category.create!(name: 'Cardiology', short_name: 'cardiology', description: 'Cardiology', parent_category: impact_categories[0]),
        Category.create!(name: 'Critical Care (ICU)', short_name: 'icu', description: 'Critical Care (ICU)', parent_category: impact_categories[0]),
        Category.create!(name: 'Dermatology', short_name: 'dermatology', description: 'Dermatology', parent_category: impact_categories[0]),
        Category.create!(name: 'Endocrinology', short_name: 'endocrinology', description: 'Endocrinology', parent_category: impact_categories[0]),
        Category.create!(name: 'Hematology', short_name: 'hematology', description: 'Hematology', parent_category: impact_categories[0]),
        Category.create!(name: 'Infectious Disease', short_name: 'infectious_disease', description: 'Infectious Disease', parent_category: impact_categories[0]),
        Category.create!(name: 'Mental Health / Psychiatry', short_name: 'mental_health_psychiatry', description: 'Mental Health / Psychiatry', parent_category: impact_categories[0]),
        Category.create!(name: 'Neurology', short_name: 'neurology', description: 'Neurology', parent_category: impact_categories[0]),
        Category.create!(name: 'Obstetrics & Gynecology', short_name: 'obstetrics_gynecology', description: 'Obstetrics & Gynecology', parent_category: impact_categories[0]),
        Category.create!(name: 'Oncology', short_name: 'oncology', description: 'Oncology', parent_category: impact_categories[0]),
        Category.create!(name: 'Ophthalmology', short_name: 'ophthalmology', description: 'Ophthalmology', parent_category: impact_categories[0]),
        Category.create!(name: 'Orthopedic Surgery', short_name: 'orthopedic_surgery', description: 'Orthopedic Surgery', parent_category: impact_categories[0]),
        Category.create!(name: 'Otolaryngology (ENT)', short_name: 'ent', description: 'Otolaryngology (ENT)', parent_category: impact_categories[0]),
        Category.create!(name: 'Pathology', short_name: 'pathology', description: 'Pathology', parent_category: impact_categories[0]),
        Category.create!(name: 'Pediatrics', short_name: 'pediatrics', description: 'Pediatrics', parent_category: impact_categories[0]),
        Category.create!(name: 'Primary Care / Preventive Medicine', short_name: 'primary_care_preventive_medicine', description: 'Primary Care / Preventive Medicine', parent_category: impact_categories[0]),
        Category.create!(name: 'Pulmonology / Respiratory', short_name: 'pulmonology_respiratory', description: 'Pulmonology / Respiratory', parent_category: impact_categories[0]),
        Category.create!(name: 'Rehab Medicine', short_name: 'rehab_medicine', description: 'Rehab Medicine', parent_category: impact_categories[0]),
        Category.create!(name: 'Renal / Nephrology', short_name: 'renal_nephrology', description: 'Renal / Nephrology', parent_category: impact_categories[0]),
        Category.create!(name: 'Rheumatology', short_name: 'rheumatology', description: 'Rheumatology', parent_category: impact_categories[0]),
        Category.create!(name: 'Specialty Care (outside of VA)', short_name: 'specialty_care_outside_of_va)', description: 'Specialty Care (outside of VA)', parent_category: impact_categories[0]),
        Category.create!(name: 'Surgery', short_name: 'surgery', description: 'Surgery', parent_category: impact_categories[0]),
        Category.create!(name: 'Toxicology', short_name: 'toxicology', description: 'Toxicology', parent_category: impact_categories[0]),
        Category.create!(name: 'Urology', short_name: 'urology', description: 'Urology', parent_category: impact_categories[0]),
        Category.create!(name: 'Prosthetics and Rehabilitation', short_name: 'prosthetics_and_rehabilitation', description: 'Prosthetics and Rehabilitation', parent_category: impact_categories[0]),
        Category.create!(name: 'Alternative Therapies', short_name: 'alternative_therapies', description: 'Alternative Therapies', parent_category: impact_categories[0]),
        Category.create!(name: 'Massage', short_name: 'massage', description: 'Massage', parent_category: impact_categories[0]),
        Category.create!(name: 'Herbal Remedies', short_name: 'herbal_remedies', description: 'Herbal Remedies', parent_category: impact_categories[0]),
        Category.create!(name: 'Acupuncture', short_name: 'acupuncture', description: 'Acupuncture', parent_category: impact_categories[0]),
        Category.create!(name: 'Dental', short_name: 'dental', description: 'Dental', parent_category: impact_categories[0]),
        Category.create!(name: 'Homeless services', short_name: 'homeless_services', description: 'Homeless services', parent_category: impact_categories[0]),
        Category.create!(name: 'Social workers', short_name: 'social_workers', description: 'Social workers', parent_category: impact_categories[0]),
        Category.create!(name: 'None', short_name: 'none', description: 'No clinical impact', parent_category: impact_categories[0]),
    ]

    operational_impacts = [
        Category.create!(name: 'Administration', short_name: 'administration', description: 'Administration', parent_category: impact_categories[1]),
        Category.create!(name: 'Billing', short_name: 'billing', description: 'Billing', parent_category: impact_categories[1]),
        Category.create!(name: 'Biomed', short_name: 'biomed', description: 'Biomed', parent_category: impact_categories[1]),
        Category.create!(name: 'Building Management', short_name: 'building_management', description: 'Building Management', parent_category: impact_categories[1]),
        Category.create!(name: 'Education and Training', short_name: 'education_and_training', description: 'Education and Training', parent_category: impact_categories[1]),
        Category.create!(name: 'Food Service', short_name: 'food_service', description: 'Food Service', parent_category: impact_categories[1]),
        Category.create!(name: 'Human Resources', short_name: 'human_resources', description: 'Human Resources', parent_category: impact_categories[1]),
        Category.create!(name: 'Information Technology', short_name: 'information_technology', description: 'Information Technology', parent_category: impact_categories[1]),
        Category.create!(name: 'Logistics', short_name: 'logistics', description: 'Logistics', parent_category: impact_categories[1]),
        Category.create!(name: 'Maintenance', short_name: 'maintenance', description: 'Maintenance', parent_category: impact_categories[1]),
        Category.create!(name: 'Marketing', short_name: 'marketing', description: 'Marketing', parent_category: impact_categories[1]),
        Category.create!(name: 'Medical Records', short_name: 'medical_records', description: 'Medical Records', parent_category: impact_categories[1]),
        Category.create!(name: 'Occupational Health', short_name: 'occupational_health', description: 'Occupational Health', parent_category: impact_categories[1]),
        Category.create!(name: 'Quality Control', short_name: 'quality_control', description: 'Quality Control', parent_category: impact_categories[1]),
        Category.create!(name: 'Risk Management', short_name: 'risk_management', description: 'Risk Management', parent_category: impact_categories[1]),
        Category.create!(name: 'Social Services', short_name: 'social_services', description: 'Social Services', parent_category: impact_categories[1]),
        Category.create!(name: 'Contracting & Purchasing', short_name: 'contracting_purchasing', description: 'Contracting & Purchasing', parent_category: impact_categories[1]),
        Category.create!(name: 'None', short_name: 'none', description: 'No clinical impact', parent_category: impact_categories[1]),
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
  User.create!(email: 'jackson.wilke@agile6.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now).add_role(User::USER_ROLES[1].to_sym)
  User::USER_ROLES.each_with_index do |role, index|
    User.create!(email: "A6test#{index}@agile6.com", password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now).add_role(User::USER_ROLES[index].to_sym)
  end

else
  puts 'Database already seeded... Nothing to do.'
end

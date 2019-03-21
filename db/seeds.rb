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
      StrategicSponsor.create!(name: 'VISN', short_name: 'visn', description: 'Sponsored by at least one VISN', icon: 'fas fa-certificate', color: '#0076D6'),
      StrategicSponsor.create!(name: 'Diffusion of Excellence', short_name: 'diffusion_of_excellence', description: 'Sponsored by Diffusion of Excellence', icon: 'fas fa-heart', color: '#E4A002'),
      StrategicSponsor.create!(name: 'Office of Rural Health', short_name: 'ORH', description: 'ORH fulfills its mission by supporting targeted research, developing innovative programs, and identifying new care models in order to break down the barriers separating rural Veterans from quality care.', icon: 'fas fa-mountain', color: '#1CC2AE'),
      StrategicSponsor.create!(name: 'Health Systems Research & Design', short_name: 'HSR&D', description: 'The HSR&D pursues research that underscores all aspects of VA healthcare: patient care, care delivery, health outcomes, cost, and quality. Within VA HSR&D, researchers focus on identifying and evaluating innovative strategies that lead to accessible, high quality, cost-effective care for Veterans and the nation.', icon: 'fas fa-microscope', color: '#9058D3'),
      StrategicSponsor.create!(name: 'VHA System Redesign', short_name: 'VHASR', description: 'The Office of Connected Care brings VA digital technology to Veterans and health care professionals, extending access to care beyond the traditional office visit.', icon: 'fas fa-cogs', color: '#FE4497'),
      StrategicSponsor.create!(name: 'VHA Office of Connected Care', short_name: 'OCC', description: 'The Office of Connected Care brings VA digital technology to Veterans and health care professionals, extending access to care beyond the traditional office visit. Through virtual technology, VA is able to deliver care to patients where and when they need it.', icon: 'fas fa-hand-holding-heart', color: '#E52107'),
      StrategicSponsor.create!(name: 'Office of Prosthetics and Rehabilitation', short_name: 'office_of_prosthetics_and_rehabilitation', description: 'Sponsored by the Office of Prosthetics and Rehabilitation', icon: 'fas fa-certificate', color: '#0076D6'),
      StrategicSponsor.create!(name: 'Office of Mental Health and Suicide Prevention (OMHSP)', short_name: 'omhsp', description: 'Sponsored by the Office of Mental Health and Suicide Prevention (OMHSP)', icon: 'fas fa-certificate', color: '#0076D6'),
      StrategicSponsor.create!(name: 'National Opioid Overdose Education Naloxone Distribution (OEND) Program Office', short_name: 'oend', description: 'Sponsored by the National Opioid Overdose Education Naloxone Distribution Program Office', icon: 'fas fa-certificate', color: '#0076D6'),
      StrategicSponsor.create!(name: 'Pharmacy Benefits Management (PBM)', short_name: 'pbm', description: 'Sponsored by the Pharmacy Benefits Management (PBM)', icon: 'fas fa-certificate', color: '#0076D6'),
      StrategicSponsor.create!(name: 'Academic Detailing Service', short_name: 'ads', description: 'Sponsored by the Academic Detailing Service', icon: 'fas fa-certificate', color: '#0076D6'),
      StrategicSponsor.create!(name: 'National Center for Patient Safety (NCPS)', short_name: 'ncps', description: 'Sponsored by the National Center for Patient Safety (NCPS)', icon: 'fas fa-certificate', color: '#0076D6'),
      StrategicSponsor.create!(name: 'VA Police', short_name: 'va_police', description: 'Sponsored by the VA Police', icon: 'fas fa-certificate', color: '#0076D6'),
      StrategicSponsor.create!(name: 'Veterans Experience Office', short_name: 'VEO', description: 'The VEO’s goal is to enable VA to be the leading customer service organization in government so that Veterans, their families, caregivers, and survivors Choose VA. VEO implements solutions based on Veteran-centered designs and industry best practices.', icon: 'fas fa-certificate', color: '#0076D6'),
      StrategicSponsor.create!(name: 'Quality Enhancement Research Initiative', short_name: 'QUERI', description: 'QUERI is committed to ensuring that research gets used effectively to ultimately sustain improvements in care for Veterans.', icon: 'fas fa-certificate', color: '#0076D6'),
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
        Badge.create!(name: 'Gold Status', short_name: 'gold_status', description: 'Gold Status Practice', strategic_sponsor: sponsors[1],
                      icon: 'fas fa-heart', color: '#E4A002'),
        Badge.create!(name: 'Authority to Operate (ATO)', short_name: 'ato', description: 'Authority to Operate (ATO) - applies to OIT projects', strategic_sponsor: sponsors.last,
                      icon: 'fas fa-check', color: '#E52107'),
    ]

    23.times do |t|
      i = t + 1
      badge_image_path = "#{Rails.root}/db/seed_images/badges/hospital_badge.svg"
      badge_image_file = File.new(badge_image_path)
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

  ### USERS ###
  User.create!(email: 'demo@va.gov', password: 'Demo#123', password_confirmation: 'Demo#123', skip_va_validation: true, confirmed_at: Time.now)
  User.create!(email: 'tom@skylight.digital', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now).add_role(User::USER_ROLES[1].to_sym)
  User.create!(email: 'aurora.hay@agile6.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now).add_role(User::USER_ROLES[1].to_sym)
  User.create!(email: 'jake.holzhauer@agile6.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now).add_role(User::USER_ROLES[1].to_sym)
  User.create!(email: 'jackson.wilke@agile6.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now).add_role(User::USER_ROLES[1].to_sym)
  User::USER_ROLES.each_with_index do |role, index|
    User.create!(email: "A6test#{index}@agile6.com", password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now).add_role(User::USER_ROLES[index].to_sym)
  end

  unless Practice.all.present?
    ############################################################################################################
    ############################################################################################################
    #############
    # FLOW3     #
    #############
    flow3_image_path = "#{Rails.root}/db/seed_images/practices/flow3/flow3.jpg"
    flow3_image_file = File.new(flow3_image_path)

    flow3_origin_image_path = "#{Rails.root}/db/seed_images/practices/flow3/origins/flow3_heckman.png"
    flow3_origin_image_file = File.new(flow3_origin_image_path)

    flow3 = Practice.create!(
        name: 'FLOW3',
        short_name: 'flow3',
        tagline: 'Delivery of prosthetic limbs to Veterans in less than ½ the time',
        gold_status_tagline: 'has saved over 1000 lives \n by helping to prevent suicide',
        description: 'Enable 53% faster delivery of prosthetic limbs to Veterans. Automating the prosthetic limb procurement process to improve continuity of care for Veterans.',
        summary: 'FLOW3 is a system of three interrelated software platforms that automate, standardize, and provide transparency into the limb acquisition process. FLOW3 begins in-clinic with physician entry of a prosthesis prescription using the FLOW Consult Templates. The order then moves to the prosthetist, who enters the appropriate codes using the Consult Comment Tool. Then, purchasing agents use the Web-based App to generate the quote for force entry, which contracting staff can access the very next day.',
        date_initiated: DateTime.now,
        vha_visn: 'Not Applicable',
        medical_center: 'Puget Sound Medical Center',
        initiating_facility: 'Puget Sound Medical Center',
        number_adopted: 10,
        cboc: 'Not Applicable',
        impact_veteran_experience: 'Reduces wait time for Prosthetic limbs by more than half',
        impact_veteran_satisfaction: 'Improved communication, patient engagement and continuity of care.  More Veterans are returning to clinic, excited to receive their prosthetic limbs.',
        impact_other_veteran_experience: 'Greater transparency and accuracy with data mining related to: Prosthetics, Veterans with Limb Loss, Current VA Services and need for new ones.',
        impact_financial_estimate_saved: '52% improvement in timeliness of delivery of prosthetic limbs',
        impact_financial_per_veteran: '1000 Veterans impacted',
        impact_financial_roi: '1000 Veterans received Prosthetic Limbs in less than half the time',
        business_case_summary: 'FLOW3 offers a faster process from prescription to purchase order to prosthetic limb delivery.  The System improves communication, patient engagement and continuity of care.  It provides greater data transparency and accuracy with data mining.',
        impact_financial_other: 'Time based Metrics + # of Veterans impacted.',
        phase_gate: 'Initial Diffusion',
        successful_implementation: '1 additional VISN and 7 Regional Amputee Clinics (RACs), Appx 8000 patients impacted',
        target_measures: 'FLOW3 Dashboard shows implementation phases of readiness and completion for all sites',
        target_success: '2',
        implementation_time_estimate: '3 months',
        support_network_email: 'FLOW3@va.gov',
        va_pulse_link: 'https://www.vapulse.net/groups/flow3',
        main_display_image: ActionDispatch::Http::UploadedFile.new(
            filename: File.basename(flow3_image_file),
            tempfile: flow3_image_file,
            # detect the image's mime type with MIME if you can't provide it yourself.
            type: MIME::Types.type_for(flow3_image_path).first.content_type
        ),
        cost_savings_aggregate: 2,
        cost_to_implement_aggregate: 1,
        difficulty_aggregate: 1,
        veteran_satisfaction_aggregate: 4,
        risk_level_aggregate: 1,
        origin_title: 'Innovation - Dr Jeffrey Heckman',
        origin_story: 'Dr. Jeffrey Heckman, a physician in the VA Puget Sound Health Care System, treated many Veterans frustrated by the lengthy process of receiving their prosthetic limbs. Motivated by one such Veteran, who offered his own technical services to improve the process, Dr. Heckman gathered a team, consisting of prosthetist Wayne Biggs and data system expert Jeffrey Bott, to overhaul and automate the prosthetic limb acquisition process. The result was a system of three interrelated software platforms, known as FLOW3, that streamlines and provides transparency into the acquisition flow. After successful implementation at Puget Sound, the team spread their innovation through the Diffusion of Excellence program, beginning with a partnership with Dawn Schwarten at the Milwaukee VA Medical Center and ultimately rolling FLOW3 out across VISN 12.',
        origin_picture: ActionDispatch::Http::UploadedFile.new(
            filename: File.basename(flow3_origin_image_file),
            tempfile: flow3_origin_image_file,
            # detect the image's mime type with MIME if you can't provide it yourself.
            type: MIME::Types.type_for(flow3_origin_image_path).first.content_type
        ),
        published: true,
        approved: true
    )

    flow3_strategic_sponsors = [
        StrategicSponsorPractice.create!(practice: flow3, strategic_sponsor: sponsors[1]),
        StrategicSponsorPractice.create!(practice: flow3, strategic_sponsor: sponsors[7]),
    ]

    flow3_team_image_path = "#{Rails.root}/db/seed_images/practices/flow3/team"
    flow3_team_heckman_image_path = "#{flow3_team_image_path}/heckman_jeff.jpg"
    flow3_team_heckman_image_file = File.new("#{flow3_team_heckman_image_path}")
    flow3_team_bott_image_path = "#{flow3_team_image_path}/bott_jeffrey.jpg"
    flow3_team_bott_image_file = File.new(flow3_team_bott_image_path)
    flow3_team_stevenson_image_path = "#{flow3_team_image_path}/stevenson_brian.jpg"
    flow3_team_stevenson_image_file = File.new(flow3_team_stevenson_image_path)
    flow3_team_biggs_path = "#{flow3_team_image_path}/biggs_wayne.jpg"
    flow3_team_biggs_image_file = File.new(flow3_team_biggs_path)

    flow3_va_employees = [
        VaEmployee.create!(
            name: 'Dr. Jeffrey T. Heckman',
            job_title: 'DO, Medical Director, Regional Amputation Center – Seattle, VA Puget Sound Health Care System; Associate Professor, Department of Rehabilitation Medicine, University of Washington School of Medicine',
            role: 'Clinical Lead and Gold Status Fellow',
            prefix: 'Dr.',
            email: 'jeffrey.heckman@va.gov',
            avatar: ActionDispatch::Http::UploadedFile.new(
                filename: File.basename(flow3_team_heckman_image_file),
                tempfile: flow3_team_heckman_image_file,
                # detect the image's mime type with MIME if you can't provide it yourself.
                type: MIME::Types.type_for(flow3_team_heckman_image_path).first.content_type
            )
        ),
        VaEmployee.create!(
            name: 'Jeff Bott',
            job_title: 'Management & Program Analyst',
            role: 'Technical Lead',
            prefix: 'Mr.',
            email: 'jeff.bott@va.gov',
            avatar: ActionDispatch::Http::UploadedFile.new(
                filename: File.basename(flow3_team_bott_image_file),
                tempfile: flow3_team_bott_image_file,
                # detect the image's mime type with MIME if you can't provide it yourself.
                type: MIME::Types.type_for(flow3_team_bott_image_path).first.content_type
            )
        ),
        VaEmployee.create!(
            name: 'Wayne Biggs',
            job_title: 'Prosthetist Orthotist Regional Clinical Director – Seattle, VA Puget Sound Health Care System',
            role: 'Coding and Template Lead',
            prefix: 'Mr.',
            email: 'wayne.biggs@va.gov',
            avatar: ActionDispatch::Http::UploadedFile.new(
                filename: File.basename(flow3_team_biggs_image_file),
                tempfile: flow3_team_biggs_image_file,
                # detect the image's mime type with MIME if you can't provide it yourself.
                type: MIME::Types.type_for(flow3_team_biggs_path).first.content_type
            )
        ),
        VaEmployee.create!(
            name: 'Brian Stevenson',
            job_title: 'Diffusion of Excellence',
            role: 'Diffusion Specialist',
            prefix: 'Mr.',
            email: 'brian.stevenson@va.gov',
            avatar: ActionDispatch::Http::UploadedFile.new(
                filename: File.basename(flow3_team_stevenson_image_file),
                tempfile: flow3_team_stevenson_image_file,
                # detect the image's mime type with MIME if you can't provide it yourself.
                type: MIME::Types.type_for(flow3_team_stevenson_image_path).first.content_type
            )
        )
    ]

    flow3_va_employees.each {|vae|
      VaEmployeePractice.create!(va_employee: vae, practice: flow3)
    }

    flow3_developing_facilities = [
        DevelopingFacilityTypePractice.create!(practice: flow3, developing_facility_type: developing_facilities[1]),
        DevelopingFacilityTypePractice.create!(practice: flow3, developing_facility_type: developing_facilities[2]),
    ]

    flow3_va_secretary_priorities = [
        VaSecretaryPriorityPractice.create!(practice: flow3, va_secretary_priority: va_secretary_priorities[1]),
        VaSecretaryPriorityPractice.create!(practice: flow3, va_secretary_priority: va_secretary_priorities[2]),
        VaSecretaryPriorityPractice.create!(practice: flow3, va_secretary_priority: va_secretary_priorities[3]),
    ]

    flow3_clinical_impacts = [
        ImpactPractice.create!(practice: flow3, impact: clinical_impacts.find {|ci| ci.name == 'Rehab Medicine'}),
        ImpactPractice.create!(practice: flow3, impact: clinical_impacts.find {|ci| ci.name == 'Prosthetics and Rehabilitation'}),
    ]

    flow3_clinical_conditions = [
        ClinicalConditionPractice.create!(practice: flow3, clinical_condition: clinical_conditions.find {|cc| cc.name == 'Prosthetic Limbs'}),
        ClinicalConditionPractice.create!(practice: flow3, clinical_condition: clinical_conditions.find {|cc| cc.name == 'Sensory Aids'}),
        ClinicalConditionPractice.create!(practice: flow3, clinical_condition: clinical_conditions.find {|cc| cc.name == 'Amputation'}),
    ]

    flow3_operational_impacts = [
        ImpactPractice.create!(practice: flow3, impact: operational_impacts.find {|oi| oi.name == 'Administration'}),
        ImpactPractice.create!(practice: flow3, impact: operational_impacts.find {|oi| oi.name == 'Billing'}),
        ImpactPractice.create!(practice: flow3, impact: operational_impacts.find {|oi| oi.name == 'Education and Training'}),
        ImpactPractice.create!(practice: flow3, impact: operational_impacts.find {|oi| oi.name == 'Information Technology'}),
        ImpactPractice.create!(practice: flow3, impact: operational_impacts.find {|oi| oi.name == 'Logistics'}),
        ImpactPractice.create!(practice: flow3, impact: operational_impacts.find {|oi| oi.name == 'Medical Records'}),
        ImpactPractice.create!(practice: flow3, impact: operational_impacts.find {|oi| oi.name == 'Contracting & Purchasing'}),
    ]

    flow3_job_titles = [
        JobPositionPractice.create!(practice: flow3, job_position: job_positions.find {|jp| jp.name == 'Clinic based physician'}),
        JobPositionPractice.create!(practice: flow3, job_position: job_positions.find {|jp| jp.name == 'Prosthetist'}),
        JobPositionPractice.create!(practice: flow3, job_position: job_positions.find {|jp| jp.name == 'Purchasing Agent'}),
    ]

    flow3_ancillary_services = [
        AncillaryServicePractice.create!(practice: flow3, ancillary_service: ancillary_services.find {|as| as.name == 'Rehabilitation & Prosthetics'}),
    ]

    flow3_clinical_locations = [
        ClinicalLocationPractice.create!(practice: flow3, clinical_location: clinical_locations.find {|cl| cl.name == 'Community Based Outpatient Clinic (CBOC)'}),
        ClinicalLocationPractice.create!(practice: flow3, clinical_location: clinical_locations.find {|cl| cl.name == 'Inpatient Hospital'}),
        ClinicalLocationPractice.create!(practice: flow3, clinical_location: clinical_locations.find {|cl| cl.name == 'Outpatient Surgery Center'}),
    ]

    flow3_risk_mitigations = [
        RiskMitigation.create!(practice: flow3)
    ]
    flow3_risks = [
        Risk.create!(description: 'If FLOW3 champions do not allocate sufficient time to training their site the implementation process will be slow and time savings will not be achieved.', risk_mitigation: flow3_risk_mitigations[0]),
    ]
    flow3_mitigations = [
        Mitigation.create!(description: 'Support Champions with a pre-implementation readiness checklist to help identify pitfalls in their planning.', risk_mitigation: flow3_risk_mitigations[0]),
        Mitigation.create!(description: ' Empower and Support Champions with official training materials.', risk_mitigation: flow3_risk_mitigations[0]),
    ]

    flow3_publications = [
        Publication.create!(practice: flow3, title: 'OIG Inspection')
    ]

    flow3_badges = [
        BadgePractice.create!(practice: flow3, badge: badges.find {|b| b.name == 'VISN 1'}),
        BadgePractice.create!(practice: flow3, badge: badges.find {|b| b.name == 'Diffusion of Excellence'}),
        BadgePractice.create!(practice: flow3, badge: badges.find {|b| b.name == 'Shark Tank Approved'}),
        BadgePractice.create!(practice: flow3, badge: badges.find {|b| b.name == 'Gold Status'}),
        BadgePractice.create!(practice: flow3, badge: badges.find {|b| b.name == 'Authority to Operate (ATO)'}),
    ]

    flow3_costs = [
        Cost.create!(practice: flow3, description: 'Minimal FTE'),
        Cost.create!(practice: flow3, description: 'Minimal Sustainment Cost')
    ]

    flow3_difficulties = [
        Difficulty.create!(practice: flow3, description: 'Champion training: 30 days'),
        Difficulty.create!(practice: flow3, description: 'Oversee staff training: 60 days')
    ]

    ############################################################################################################
    ############################################################################################################
    #############
    # Naloxone  #
    #############
    naloxone_image_path = "#{Rails.root}/db/seed_images/practices/naloxone/naloxone.jpg"
    naloxone_image_file = File.new(naloxone_image_path)

    naloxone_origin_image_path = "#{Rails.root}/db/seed_images/practices/naloxone/origins/naloxone_bellino.png"
    naloxone_origin_image_file = File.new(naloxone_origin_image_path)

    naloxone = Practice.create!(
        name: 'VHA Rapid Naloxone',
        short_name: 'vha_rapid_naloxone',
        tagline: 'Rapid naloxone',
        gold_status_tagline: 'saved 358 lives \n by improving access to life-saving naloxone',
        description: 'A safety belt in case of an overdose and saves the lives of our Veterans',
        summary: 'The VHA Rapid Naloxone Initiative acts as a safety belt in case of an overdose and saves the lives of our Veterans which creates a safer environment around the veteran on VA campuses. Since the adoption of at least one element in the Initiative within at least 43 facilities, there have been at least 44 successful overdose reversals within FY2018. The Initiative’s plan to spread across the nation has the potential to drastically increase the number of successful reversals within FY2019, improving patient safety across the VA.

The Initiative has a significant impact on the patient safety within VA medical facilities and patient experience. First responders have testified about the positive impact of the Initiative and the role it played in saving their lives and creating a safer environment. One such rescue was a 27-year-old male Veteran who experienced an overdose at a Substance Abuse Residential Rehabilitation Treatment Program (SARRTP), which is located on hospital grounds but some distance from the main building. Because of the availability of naloxone in the AED cabinet, the initial dose was administered to the Veteran before VA police arrived on the scene. The Veteran survived the overdose and was transported to the Critical Care Unit (CCU) for further treatment. Without the quick access of naloxone, this Veteran could have lost his life. His story, as well as many other many Veteran overdose survival stories, has pushed this Initiative into the national spotlight and sparked a flame for action to implement around the nation. ',
        date_initiated: DateTime.strptime('1/1/2016', '%m/%d/%Y'),
        vha_visn: 'VISN 1',
        initiating_facility: 'Boston Health Care System',
        number_adopted: 50,
        medical_center: 'Boston HCS',
        cboc: 'Not Applicable',
        impact_veteran_experience: '',
        impact_veteran_satisfaction: '',
        impact_other_veteran_experience: 'saves lives',
        impact_financial_estimate_saved: '0',
        impact_financial_per_veteran: '0',
        impact_financial_roi: '0',
        business_case_summary: 'Veterans are twice as likely to die from opioid overdoses and these overdoses are occurring at VAMCs where naloxone is infrequently available. Equipping AED cabinets and VA police with naloxone to provide naloxone quickly will save lives.',
        impact_financial_other: 'Time based Metrics + # of Veterans impacted.',
        phase_gate: 'National Diffusion',
        successful_implementation: 'Implementation in 168 facilities',
        target_measures: 'self reports',
        target_success: '148',
        implementation_time_estimate: '4-6 months',
        support_network_email: 'vharapidnalocone@va.gov',
        va_pulse_link: 'https://www.vapulse.net/groups/naloxone',
        main_display_image: ActionDispatch::Http::UploadedFile.new(
            filename: File.basename(naloxone_image_file),
            tempfile: naloxone_image_file,
            # detect the image's mime type with MIME if you can't provide it yourself.
            type: MIME::Types.type_for(naloxone_image_path).first.content_type
        ),
        cost_savings_aggregate: 1,
        cost_to_implement_aggregate: 1,
        difficulty_aggregate: 1,
        veteran_satisfaction_aggregate: 4,
        risk_level_aggregate: 1,
        origin_title: 'Innovation - Pamela Bellino',
        origin_story: 'Begun by Pamela Bellino, Patient Safety Manager at the VA Boston Healthcare System, the Opioid Overdose Reversal Program is a practice to increase the availability of IN naloxone to prevent overdose fatalities among Veterans at VA facilities. The program increases the likelihood of preventing these fatalities by equipping AED cabinets, VA police officers, and at-risk patients with naloxone. After successfully piloting the practice at the VA Boston Healthcare System, facilitated implementation of the innovation began in VISN 8 through the Diffusion of Excellence initiative.',
        origin_picture: ActionDispatch::Http::UploadedFile.new(
            filename: File.basename(naloxone_origin_image_file),
            tempfile: naloxone_origin_image_file,
            # detect the image's mime type with MIME if you can't provide it yourself.
            type: MIME::Types.type_for(naloxone_origin_image_path).first.content_type
        ),
        published: true,
        approved: true
    )

    naloxone_strategic_sponsors = [
        StrategicSponsorPractice.create!(practice: naloxone, strategic_sponsor: sponsors.find {|s| s.name == 'Office of Mental Health and Suicide Prevention (OMHSP)'}),
        StrategicSponsorPractice.create!(practice: naloxone, strategic_sponsor: sponsors.find {|s| s.name == 'National Opioid Overdose Education Naloxone Distribution (OEND) Program Office'}),
        StrategicSponsorPractice.create!(practice: naloxone, strategic_sponsor: sponsors.find {|s| s.name == 'Academic Detailing Service'}),
        StrategicSponsorPractice.create!(practice: naloxone, strategic_sponsor: sponsors.find {|s| s.name == 'National Center for Patient Safety (NCPS)'}),
        StrategicSponsorPractice.create!(practice: naloxone, strategic_sponsor: sponsors.find {|s| s.name == 'VA Police'}),
    ]

    naloxone_team_image_path = "#{Rails.root}/db/seed_images/practices/naloxone/team"
    naloxone_team_bellino_image_path = "#{naloxone_team_image_path}/bellino.png"
    naloxone_team_bellino_image_file = File.new("#{naloxone_team_bellino_image_path}")
    naloxone_team_olivia_image_path = "#{naloxone_team_image_path}/olivia.jpeg"
    naloxone_team_olivia_image_file = File.new(naloxone_team_olivia_image_path)
    naloxone_team_burkhardt_image_path = "#{naloxone_team_image_path}/burkhardt.jpeg"
    naloxone_team_burkdart_image_file = File.new(naloxone_team_burkhardt_image_path)
    naloxone_team_brick_image_path = "#{naloxone_team_image_path}/brick.jpeg"
    naloxone_team_brick_image_file = File.new(naloxone_team_brick_image_path)

    # TODO: find Carl McCoy!
    # naloxone_team_mccoy_path = "#{naloxone_team_image_path}/mccoy.jpg"
    # naloxone_team_mccoy_image_file = File.new(naloxone_team_mccoy_path)

    naloxone_va_employees = [
        VaEmployee.create!(
            name: 'Pam Bellino',
            job_title: 'Safety Manager VA Boston',
            role: 'Founder, Gold Status Fellow, Safety Manager VA Boston',
            email: 'pam.bellino@va.gov',
            avatar: ActionDispatch::Http::UploadedFile.new(
                filename: File.basename(naloxone_team_bellino_image_file),
                tempfile: naloxone_team_bellino_image_file,
                # detect the image's mime type with MIME if you can't provide it yourself.
                type: MIME::Types.type_for(naloxone_team_bellino_image_path).first.content_type
            )
        ),
        VaEmployee.create!(
            name: 'Dr. Elizabeth Oliva',
            job_title: 'National OEND Coordinator',
            role: 'National OEND Coordinator',
            email: 'elizabeth.oliva@va.gov',
            avatar: ActionDispatch::Http::UploadedFile.new(
                filename: File.basename(naloxone_team_olivia_image_file),
                tempfile: naloxone_team_olivia_image_file,
                # detect the image's mime type with MIME if you can't provide it yourself.
                type: MIME::Types.type_for(naloxone_team_olivia_image_path).first.content_type
            )
        ),
        VaEmployee.create!(
            name: 'Mary Burkhardt',
            job_title: 'Pharmacy Executive, National Center for Patient Safety',
            role: 'Pharmacy Executive, National Center for Patient Safety',
            email: 'mary.burkhardt@va.gov',
            avatar: ActionDispatch::Http::UploadedFile.new(
                filename: File.basename(naloxone_team_burkdart_image_file),
                tempfile: naloxone_team_burkdart_image_file,
                # detect the image's mime type with MIME if you can't provide it yourself.
                type: MIME::Types.type_for(naloxone_team_burkhardt_image_path).first.content_type
            )
        ),
        VaEmployee.create!(
            name: 'Carl McCoy',
            job_title: 'Diffusion Specialist',
            role: 'Diffusion Specialist',
            email: 'carl.mccoy@va.gov'
        ),
        VaEmployee.create!(
            name: 'Mollie Brick',
            job_title: 'Senior Consultant (Atlas)',
            role: 'Senior Consultant (Atlas)',
            email: 'mollie.brick@va.gov',
            avatar: ActionDispatch::Http::UploadedFile.new(
                filename: File.basename(naloxone_team_brick_image_file),
                tempfile: naloxone_team_brick_image_file,
                # detect the image's mime type with MIME if you can't provide it yourself.
                type: MIME::Types.type_for(naloxone_team_brick_image_path).first.content_type
            )
        ),
    ]

    naloxone_va_employees.each {|vae|
      VaEmployeePractice.create!(va_employee: vae, practice: naloxone)
    }

    naloxone_developing_facilities = [
        DevelopingFacilityTypePractice.create!(practice: naloxone, developing_facility_type: developing_facilities[1]),
    ]

    naloxone_va_secretary_priorities = [
        VaSecretaryPriorityPractice.create!(practice: naloxone, va_secretary_priority: va_secretary_priorities[2]),
    ]

    naloxone_clinical_impacts = [
        ImpactPractice.create!(practice: naloxone, impact: clinical_impacts.find {|ci| ci.name == 'Mental Health / Psychiatry'}),
        ImpactPractice.create!(practice: naloxone, impact: clinical_impacts.find {|ci| ci.name == 'Primary Care / Preventive Medicine'}),
        ImpactPractice.create!(practice: naloxone, impact: clinical_impacts.find {|ci| ci.name == 'Homeless services'}),
        ImpactPractice.create!(practice: naloxone, impact: clinical_impacts.find {|ci| ci.name == 'Social workers'}),
    ]

    naloxone_clinical_conditions = [
        ClinicalConditionPractice.create!(practice: naloxone, clinical_condition: clinical_conditions.find {|cc| cc.name == 'Chronic Pain'}),
        ClinicalConditionPractice.create!(practice: naloxone, clinical_condition: clinical_conditions.find {|cc| cc.name == 'Addiction'}),
        ClinicalConditionPractice.create!(practice: naloxone, clinical_condition: clinical_conditions.find {|cc| cc.name == 'Accidental overdose'}),
    ]

    naloxone_operational_impacts = [
        ImpactPractice.create!(practice: naloxone, impact: operational_impacts.find {|oi| oi.name == 'Education and Training'}),
        ImpactPractice.create!(practice: naloxone, impact: operational_impacts.find {|oi| oi.name == 'Social Services'}),
    ]

    naloxone_job_titles = [
        JobPositionPractice.create!(practice: naloxone, job_position: job_positions.find {|jp| jp.name == 'Clinic based nurse'}),
        JobPositionPractice.create!(practice: naloxone, job_position: job_positions.find {|jp| jp.name == 'Clinic based physician'}),
        JobPositionPractice.create!(practice: naloxone, job_position: job_positions.find {|jp| jp.name == 'Hospital based nurse'}),
        JobPositionPractice.create!(practice: naloxone, job_position: job_positions.find {|jp| jp.name == 'Hospital based physician'}),
        JobPositionPractice.create!(practice: naloxone, job_position: job_positions.find {|jp| jp.name == 'Nursing Assistant'}),
        JobPositionPractice.create!(practice: naloxone, job_position: job_positions.find {|jp| jp.name == 'Pharmacist'}),
        JobPositionPractice.create!(practice: naloxone, job_position: job_positions.find {|jp| jp.name == 'Pharmacy Tech'}),
    ]

    naloxone_ancillary_services = [
        AncillaryServicePractice.create!(practice: naloxone, ancillary_service: ancillary_services.find {|as| as.name == 'Pharmacy'}),
        AncillaryServicePractice.create!(practice: naloxone, ancillary_service: ancillary_services.find {|as| as.name == 'Social Work'}),
    ]

    naloxone_clinical_locations = [
        ClinicalLocationPractice.create!(practice: naloxone, clinical_location: clinical_locations.find {|cl| cl.name == 'Alcohol and Other Drug Abuse (AODA) treatment center'}),
        ClinicalLocationPractice.create!(practice: naloxone, clinical_location: clinical_locations.find {|cl| cl.name == 'Assisted Living Facility'}),
        ClinicalLocationPractice.create!(practice: naloxone, clinical_location: clinical_locations.find {|cl| cl.name == 'Community Based Outpatient Clinic (CBOC)'}),
        ClinicalLocationPractice.create!(practice: naloxone, clinical_location: clinical_locations.find {|cl| cl.name == 'Community Living Centers (CLC)'}),
        ClinicalLocationPractice.create!(practice: naloxone, clinical_location: clinical_locations.find {|cl| cl.name == 'Home Health'}),
        ClinicalLocationPractice.create!(practice: naloxone, clinical_location: clinical_locations.find {|cl| cl.name == 'Inpatient Hospital'}),
        ClinicalLocationPractice.create!(practice: naloxone, clinical_location: clinical_locations.find {|cl| cl.name == 'Outpatient Surgery Center'}),
        ClinicalLocationPractice.create!(practice: naloxone, clinical_location: clinical_locations.find {|cl| cl.name == 'Pain Clinic'}),
        ClinicalLocationPractice.create!(practice: naloxone, clinical_location: clinical_locations.find {|cl| cl.name == 'Skilled Nursing Facility (SNF)'}),
    ]

    naloxone_risk_mitigations = [
        RiskMitigation.create!(practice: naloxone)
    ]
    naloxone_risks = [
        Risk.create!(description: 'Leadership needs to choose to change policy.', risk_mitigation: naloxone_risk_mitigations[0]),
    ]
    naloxone_mitigations = [
        Mitigation.create!(description: 'Example policies included in toolkit.', risk_mitigation: naloxone_risk_mitigations[0])
    ]

    naloxone_publications = [
        # Publication.create!(practice: naloxone, title: 'OIG Inspection')
    ]

    naloxone_badges = [
        BadgePractice.create!(practice: naloxone, badge: badges.find {|b| b.name == 'Diffusion of Excellence'}),
        BadgePractice.create!(practice: naloxone, badge: badges.find {|b| b.name == 'Shark Tank Approved'}),
        BadgePractice.create!(practice: naloxone, badge: badges.find {|b| b.name == 'Gold Status'}),
    ]

    naloxone_costs = [
        Cost.create!(practice: naloxone, description: 'Minimal FTE'),
        Cost.create!(practice: naloxone, description: 'Need to buy Naloxone for AED cabinets and police')
    ]

    naloxone_difficulties = [
        Difficulty.create!(practice: naloxone, description: 'Minimal training'),
        Difficulty.create!(practice: naloxone, description: '~4 months to completely implement'),
    ]

    ############################################################################################################
    ############################################################################################################
    #############
    # HAPPEN  #
    #############
    happen_image_path = "#{Rails.root}/db/seed_images/practices/happen/happen.jpg"
    happen_image_file = File.new(happen_image_path)

    happen_origins_image_path = "#{Rails.root}/db/seed_images/practices/happen/origins/munro.jpg"
    happen_origins_image_file = File.new(happen_origins_image_path)

    happen = Practice.create!(
        name: 'VA Project HAPPEN ',
        short_name: 'va_project_happen',
        summary: 'Hospital-acquired pneumonia (HAP) is a substantial health risk for patients during their hospital stays. Anywhere from 15-31% of patients who contract HAP die from the disease or related complications, like sepsis. Until now, prevention efforts have focused on ventilated patients due to their increased risk of contracting pneumonia, with non-ventilated patients largely overlooked.

Poor oral hygiene increases the risk of HAP, with germs in the mouth rapidly multiplying and frequently aspirating into the lungs during sleep. Regular tooth brushing aids in removing these germs. By engaging Veterans in proper oral care practices, nurses teach the importance of good oral hygiene and its ability to reduce pneumonia rates and length of hospital stays. Project HAPPEN is a nurse-driven intervention; with nurses in charge of patient care, they must own and drive the practice. Garnering buy-in from nursing staff and nursing executives is essential. Tracking cases and sharing results demonstrate that oral care is not simply a comfort measure, but essential patient care.

Project HAPPEN supports the Department’s Priorities by focusing on things that matter—in addition to reducing the risk of NV-HAP, Veterans feel better and see improvement in their quality of life; modernizing systems/processes with a focus on preventive care; and improving access and timeliness of service by reducing patient length of stays and freeing up bed space for other patients. Every facility that has implemented this practice has seen immediate drops in pneumonia rates (of at least 40-60%) and associated costs (an average of $40,000 per case), easily recouping oral care supply costs within three months. News media is paying attention, too, with word getting out through over 60 media outlets, including the Wall Street Journal.
',
        tagline: 'Prevent pneumonia',
        gold_status_tagline: '- prevent non ventilator acquired pneumonia \n by engaging nursing staff to complete inpatient oral care',
        description: 'Prevent non ventilator acquired pneumonia with better oral care',
        date_initiated: DateTime.strptime('5/1/2016', '%m/%d/%Y'),
        vha_visn: 'VISN 6',
        initiating_facility: 'Salem VA Medical Center',
        number_adopted: 2,
        medical_center: 'Salem VA Medical Center',
        cboc: 'Not Applicable',
        impact_veteran_experience: '',
        impact_veteran_satisfaction: 'Approximately 24 lives have been saved since implementing the Project Happen initiative',
        impact_other_veteran_experience: 'Only 34.5% of veterans who develop NV-HAP (Non Ventilator Hospital Acquired Pneumonia) return home after admission impacting the quality of life of patients, their families, and the larger community.

By working with engaged nurses to provide oral care to veterans, a 92% decrease in NV-HAP and a reduced cost of $40,000 per case was accomplished. ',
        impact_financial_estimate_saved: '$5.46 million ',
        impact_financial_per_veteran: '$40,000',
        impact_financial_roi: '0',
        business_case_summary: 'Regard dental care supplies:

Pneumonia is a substantial health risk for patients during their hospital stay.
The average cost of one case of NV-HAP is $40,000. Mortality rates for NV-HAP range from 18-30%. Procuring ADA approved, high-quality toothbrushes, toothpaste, and other oral hygiene supplies such as alcohol-free mouthwash, denture cleansers, and lip moisturizers is critical to successful inpatient oral care implementation. Average cost to the VA for oral care supplies is $3.00 per patient.  The inpatient oral care intervention in VISN 6 and Houston VAMC saved an estimated $5.462M and 24 Veteran lives (October 2016- September 2018).
Oral care reduces the risk of developing pneumonia and lowers health care costs by avoiding long hospital stays.',
        impact_financial_other: '',
        phase_gate: 'National Diffusion',
        successful_implementation: 'Implementation of HAPPEN in 40+ facilities in 2019. ',
        target_measures: 'Zero cases on HV-HAP within hospital settings ',
        target_success: '8',
        implementation_time_estimate: '3 months',
        support_network_email: 'VAHAPPEN@va.gov',
        va_pulse_link: 'https://www.vapulse.net/groups/happen',
        main_display_image: ActionDispatch::Http::UploadedFile.new(
            filename: File.basename(happen_image_file),
            tempfile: happen_image_file,
            # detect the image's mime type with MIME if you can't provide it yourself.
            type: MIME::Types.type_for(happen_image_path).first.content_type
        ),
        cost_savings_aggregate: 1,
        cost_to_implement_aggregate: 1,
        difficulty_aggregate: 1,
        veteran_satisfaction_aggregate: 1,
        risk_level_aggregate: 1,
        origin_title: 'Innovation - About Shannon Munro, PhD, APRN, BC, FNP',
        origin_story: 'When VA Nurse Researcher and Nurse Practitioner Dr. Shannon Munro learned from nursing professor and researcher Dr. Dian Baker about the dramatic reduction in non-ventilator hospital-acquired pneumonia (NV-HAP) through a simple, low-cost, low-risk intervention—brushing teeth—she decided to bring the practice to VA.

Project HAPPEN started at the Salem VAMC (Salem, VA) and has been replicated at the Michael E. DeBakey VAMC (Houston, TX) through facilitated implementation with the Diffusion of Excellence. It is currently being implemented across VISN 6 Community Living Center (CLC) and medical-surgical inpatient units.  

Shannon Munro is a Nurse Researcher and Family Nurse Practitioner at Salem VAMC. She’s been with VA for over 15 years, caring for Veterans and conducting research directed toward the improvement of Veteran healthcare.',
        origin_picture: ActionDispatch::Http::UploadedFile.new(
            filename: File.basename(happen_origins_image_file),
            tempfile: happen_origins_image_file,
            # detect the image's mime type with MIME if you can't provide it yourself.
            type: MIME::Types.type_for(happen_origins_image_path).first.content_type
        ),
        published: true,
        approved: true
    )

    happen_strategic_sponsors = [
        StrategicSponsorPractice.create!(practice: happen, strategic_sponsor: sponsors.find {|s| s.name == 'Diffusion of Excellence'}),
    ]

    happen_team_image_path = "#{Rails.root}/db/seed_images/practices/happen/team"
    happen_team_munro_image_path = "#{happen_team_image_path}/munro.jpg"
    happen_team_munro_image_file = File.new("#{happen_team_munro_image_path}")

    # TODO: find Devin Harrision!
    # happen_team_harrison_image_path = "#{happen_team_image_path}/harrison.jpg"
    # happen_team_harrison_image_file = File.new("#{happen_team_munro_image_path}")

    happen_va_employees = [
        VaEmployee.create!(
            name: 'Dr. Shannon Munro',
            job_title: 'Nurse Researcher at Department of Veterans Affairs Medical Center',
            role: 'Gold Status Fellow',
            avatar: ActionDispatch::Http::UploadedFile.new(
                filename: File.basename(happen_team_munro_image_file),
                tempfile: happen_team_munro_image_file,
                # detect the image's mime type with MIME if you can't provide it yourself.
                type: MIME::Types.type_for(happen_team_munro_image_path).first.content_type
            )
        ),
        VaEmployee.create!(
            name: 'Devin Harrison',
            job_title: 'Diffusion Specialist',
            role: 'Diffusion Specialist'
        ),
    ]

    happen_va_employees.each {|vae|
      VaEmployeePractice.create!(va_employee: vae, practice: happen)
    }

    happen_developing_facilities = [
        DevelopingFacilityTypePractice.create!(practice: happen, developing_facility_type: developing_facilities.find {|df| df.name == 'Community Living Center (CLC)'}),
        DevelopingFacilityTypePractice.create!(practice: happen, developing_facility_type: developing_facilities.find {|df| df.name == 'VA Medical Center'}),
    ]

    happen_va_secretary_priorities = [
        VaSecretaryPriorityPractice.create!(practice: happen, va_secretary_priority: va_secretary_priorities.find {|sp| sp.name == 'Focusing resources based on importance'}),
    ]

    happen_clinical_impacts = [
        ImpactPractice.create!(practice: happen, impact: clinical_impacts.find {|ci| ci.name == 'Infectious Disease'}),
        ImpactPractice.create!(practice: happen, impact: clinical_impacts.find {|ci| ci.name == 'Primary Care / Preventive Medicine'}),
        ImpactPractice.create!(practice: happen, impact: clinical_impacts.find {|ci| ci.name == 'Dental'}),
    ]

    happen_clinical_conditions = [
        ClinicalConditionPractice.create!(practice: happen, clinical_condition: clinical_conditions.find {|cc| cc.name == 'Hospital acquired pneumonia'}),
    ]

    happen_operational_impacts = [
        ImpactPractice.create!(practice: happen, impact: operational_impacts.find {|oi| oi.name == 'Administration'}),
        ImpactPractice.create!(practice: happen, impact: operational_impacts.find {|oi| oi.name == 'Education and Training'}),
        ImpactPractice.create!(practice: happen, impact: operational_impacts.find {|oi| oi.name == 'Logistics'}),
    ]

    happen_job_titles = [
        JobPositionPractice.create!(practice: happen, job_position: job_positions.find {|jp| jp.name == 'Clinic based nurse'}),
        JobPositionPractice.create!(practice: happen, job_position: job_positions.find {|jp| jp.name == 'Hospital based physician'}),
        JobPositionPractice.create!(practice: happen, job_position: job_positions.find {|jp| jp.name == 'Nursing Assistant'}),
        JobPositionPractice.create!(practice: happen, job_position: job_positions.find {|jp| jp.name == 'Dentist'}),
    ]

    happen_ancillary_services = [

    ]

    happen_clinical_locations = [
        ClinicalLocationPractice.create!(practice: happen, clinical_location: clinical_locations.find {|cl| cl.name == 'Community Living Centers (CLC)'}),
        ClinicalLocationPractice.create!(practice: happen, clinical_location: clinical_locations.find {|cl| cl.name == 'Inpatient Hospital'}),
    ]

    happen_risk_mitigations = [
        RiskMitigation.create!(practice: happen)
    ]
    happen_risks = [
        Risk.create!(description: 'Facility buy in and continued monitoring of HV-HAP cases from month to month.', risk_mitigation: happen_risk_mitigations[0]),
    ]
    happen_mitigations = [
        Mitigation.create!(description: 'Efficient data collection.', risk_mitigation: happen_risk_mitigations[0])
    ]

    happen_publications = [
        # Publication.create!(practice: happen, title: 'OIG Inspection')
    ]

    happen_badges = [
        BadgePractice.create!(practice: happen, badge: badges.find {|b| b.name == 'Diffusion of Excellence'}),
        BadgePractice.create!(practice: happen, badge: badges.find {|b| b.name == 'VISN 6'}),
        BadgePractice.create!(practice: happen, badge: badges.find {|b| b.name == 'Gold Status'}),
    ]

  end
else
  puts 'Database already seeded... Nothing to do.'
end

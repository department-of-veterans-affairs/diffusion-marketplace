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
      StrategicSponsor.create!(name: 'Office of Mental Health', short_name: 'office_of_mental_health', description: 'Sponsored by the Office of Mental Health'),
      StrategicSponsor.create!(name: 'None', short_name: 'none', description: 'Not Sponsored'),
  ]

  unless Badge.all.present?
    badges = [
        Badge.create!(name: 'VISN', short_name: 'visn', description: 'Vetted by at least one VISN', strategic_sponsor: sponsors[0]),
        Badge.create!(name: 'VHA System Redesign', short_name: 'vha_system_redesign', description: 'Vetted by VHA System Redesign', strategic_sponsor: sponsors[4]),
        Badge.create!(name: 'VHA Office of Connected Care', short_name: 'vha_office_of_connected_care', description: 'Vetted by the VHA Office of Connected Care', strategic_sponsor: sponsors[5]),
        Badge.create!(name: 'HSR&D', short_name: 'hsrd', description: 'Vetted by HSR&D', strategic_sponsor: sponsors[3]),
        Badge.create!(name: 'Office of Rural Health', short_name: 'office_of_rural_health', description: 'Vetted by the Office of Rural Health', strategic_sponsor: sponsors[2]),
        Badge.create!(name: 'Diffusion of Excellence', short_name: 'diffusion_of_excellence', description: 'Vetted by Diffusion of Excellence', strategic_sponsor: sponsors[1]),
        Badge.create!(name: 'Shark Tank Approved', short_name: 'shark_tank_approved', description: 'Shark Tank Approved', strategic_sponsor: sponsors[1]),
        Badge.create!(name: 'Top 100 Shark Tank', short_name: 'shark_tank_100', description: 'Top 100 Shark Tank finisher', strategic_sponsor: sponsors[1]),
        Badge.create!(name: 'Top 20 Shark Tank', short_name: 'shark_tank_20', description: 'Top 20 Shark Tank finisher', strategic_sponsor: sponsors[1]),
        Badge.create!(name: 'Gold Status', short_name: 'gold_status', description: 'Gold Status Practice', strategic_sponsor: sponsors[1]),
        Badge.create!(name: 'Authority to Operate (ATO)', short_name: 'ato', description: 'Authority to Operate (ATO) - applies to OIT projects', strategic_sponsor: sponsors.last),
    ]
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
        ClinicalCondition.create!(name: 'Accidental overdose', short_name: 'accidental_overdose', description: 'Accidental Overdose'),
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
        DevelopingFacilityType.create!(name: 'Community Living Center', short_name: 'clc'),
        DevelopingFacilityType.create!(name: 'Office of Mental Health', short_name: 'office_of_mental_health'),
    ]
  end

  unless Practice.all.present?
    ############################################################################################################
    ############################################################################################################
    #############
    # FLOW3     #
    #############
    flow3_image_path = "#{Rails.root}/db/seed_images/flow3.jpg"
    flow3_image_file = File.new(flow3_image_path)

    flow3 = Practice.create!(
        name: 'FLOW3',
        short_name: 'flow3',
        description: 'FLOW3 improves the Prosthetic Limb Acquisition time by more than half.',
        date_initiated: DateTime.now,
        vha_visn: 'Not Applicable',
        medical_center: 'Pudget Sound Health Care System',
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
        )
    )

    flow3_strategic_sponsors = [
        StrategicSponsorPractice.create!(practice: flow3, strategic_sponsor: sponsors[1]),
        StrategicSponsorPractice.create!(practice: flow3, strategic_sponsor: sponsors[7]),
    ]

    flow3_va_employees = [
        VaEmployee.create!(name: 'Jefferey T. Heckman', prefix: 'Dr.'),
        VaEmployee.create!(name: 'Jeff Bott', prefix: 'Mr.'),
        VaEmployee.create!(name: 'Wayne Biggs', prefix: 'Mr.'),
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

    flow3_risks_and_mitigations = [
        RiskAndMitigation.create!(practice: flow3, risk: 'Minor App ATO under a VA GSS', mitigation: 'Currently traversing the appropriate process and protocols within OIT to achieve EOY 19 diffusion objectives.'),
    ]

    flow3_publications = [
        Publication.create!(practice: flow3, title: 'OIG Inspection')
    ]

    flow3_badges = [
        BadgePractice.create!(practice: flow3, badge: badges.find {|b| b.name == 'VISN'}),
        BadgePractice.create!(practice: flow3, badge: badges.find {|b| b.name == 'Diffusion of Excellence'}),
        BadgePractice.create!(practice: flow3, badge: badges.find {|b| b.name == 'Shark Tank Approved'}),
        BadgePractice.create!(practice: flow3, badge: badges.find {|b| b.name == 'Gold Status'}),
        BadgePractice.create!(practice: flow3, badge: badges.find {|b| b.name == 'Authority to Operate (ATO)'}),
    ]

    ############################################################################################################
    ############################################################################################################
    #############
    # Naloxone  #
    #############
    naloxone_image_path = "#{Rails.root}/db/seed_images/naloxone.jpg"
    naloxone_image_file = File.new(naloxone_image_path)

    naloxone = Practice.create!(
        name: 'VHA Rapid Naloxone',
        short_name: 'vha_rapid_naloxone',
        description: 'Ensuring rapid availability of naloxone through AED cabinets, Police, OEND',
        date_initiated: DateTime.strptime('1/1/2016', '%m/%d/%Y'),
        vha_visn: 'VISN 1',
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
        )
    )

    naloxone_strategic_sponsors = [
        StrategicSponsorPractice.create!(practice: naloxone, strategic_sponsor: sponsors.find {|s| s.name == 'Office of Mental Health'}),
    ]

    naloxone_va_employees = [
        VaEmployee.create!(name: 'Pam Bellino'),
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
        ClinicalConditionPractice.create!(practice: naloxone, clinical_condition: clinical_conditions.find {|cc| cc.name == 'Accidental Overdose'}),
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

    naloxone_risks_and_mitigations = [
        RiskAndMitigation.create!(practice: naloxone, risk: 'Unwillingness to participate', mitigation: ' mitigate through targeted comms and education'),
    ]

    naloxone_publications = [
        # Publication.create!(practice: naloxone, title: 'OIG Inspection')
    ]

    naloxone_badges = [
        BadgePractice.create!(practice: naloxone, badge: badges.find {|b| b.name == 'Diffusion of Excellence'}),
        BadgePractice.create!(practice: naloxone, badge: badges.find {|b| b.name == 'Shark Tank Approved'}),
        BadgePractice.create!(practice: naloxone, badge: badges.find {|b| b.name == 'Gold Status'}),
    ]

    ############################################################################################################
    ############################################################################################################
    #############
    # HAPPEN  #
    #############
    happen_image_path = "#{Rails.root}/db/seed_images/happen.jpg"
    happen_image_file = File.new(happen_image_path)

    happen = Practice.create!(
        name: 'VA Project HAPPEN ',
        short_name: 'va_project_happen',
        description: 'Non Ventilator Hospital Acquired Pneumonia Prevention by Engaging Nursing Staff to Complete Inpatient Oral Care. ',
        date_initiated: DateTime.strptime('1/1/2016', '%m/%d/%Y'),
        vha_visn: 'VISN 1',
        medical_center: 'Boston HCS',
        cboc: 'Not Applicable',
        impact_veteran_experience: '',
        impact_veteran_satisfaction: '',
        impact_other_veteran_experience: 'saves lives',
        impact_financial_estimate_saved: '0',
        impact_financial_per_veteran: '0',
        impact_financial_roi: '0',
        business_case_summary: 'Veterans are twice as likely to die from opioid overdoses and these overdoses are occurring at VAMCs where happen is infrequently available. Equipping AED cabinets and VA police with happen to provide happen quickly will save lives.',
        impact_financial_other: 'Time based Metrics + # of Veterans impacted.',
        phase_gate: 'National Diffusion',
        successful_implementation: 'Implementation in 168 facilities',
        target_measures: 'self reports',
        target_success: '148',
        implementation_time_estimate: '4-6 months',
        support_network_email: 'vharapidnalocone@va.gov',
        va_pulse_link: 'https://www.vapulse.net/groups/happen',
        main_display_image: ActionDispatch::Http::UploadedFile.new(
            filename: File.basename(happen_image_file),
            tempfile: happen_image_file,
            # detect the image's mime type with MIME if you can't provide it yourself.
            type: MIME::Types.type_for(happen_image_path).first.content_type
        )
    )

    happen_strategic_sponsors = [
        StrategicSponsorPractice.create!(practice: happen, strategic_sponsor: sponsors.find {|s| s.name == 'Diffusion of Excellence'}),
    ]

    happen_va_employees = [
        VaEmployee.create!(name: 'Pam Bellino'),
    ]

    happen_va_employees.each {|vae|
      VaEmployeePractice.create!(va_employee: vae, practice: happen)
    }

    happen_developing_facilities = [
        DevelopingFacilityTypePractice.create!(practice: happen, developing_facility_type: developing_facilities[1]),
    ]

    happen_va_secretary_priorities = [
        VaSecretaryPriorityPractice.create!(practice: happen, va_secretary_priority: va_secretary_priorities[2]),
    ]

    happen_clinical_impacts = [
        ImpactPractice.create!(practice: happen, impact: clinical_impacts.find {|ci| ci.name == 'Mental Health / Psychiatry'}),
        ImpactPractice.create!(practice: happen, impact: clinical_impacts.find {|ci| ci.name == 'Primary Care / Preventive Medicine'}),
        ImpactPractice.create!(practice: happen, impact: clinical_impacts.find {|ci| ci.name == 'Homeless services'}),
        ImpactPractice.create!(practice: happen, impact: clinical_impacts.find {|ci| ci.name == 'Social workers'}),
    ]

    happen_clinical_conditions = [
        ClinicalConditionPractice.create!(practice: happen, clinical_condition: clinical_conditions.find {|cc| cc.name == 'Chronic Pain'}),
        ClinicalConditionPractice.create!(practice: happen, clinical_condition: clinical_conditions.find {|cc| cc.name == 'Addiction'}),
        ClinicalConditionPractice.create!(practice: happen, clinical_condition: clinical_conditions.find {|cc| cc.name == 'Accidental Overdose'}),
    ]

    happen_operational_impacts = [
        ImpactPractice.create!(practice: happen, impact: operational_impacts.find {|oi| oi.name == 'Education and Training'}),
        ImpactPractice.create!(practice: happen, impact: operational_impacts.find {|oi| oi.name == 'Social Services'}),
    ]

    happen_job_titles = [
        JobPositionPractice.create!(practice: happen, job_position: job_positions.find {|jp| jp.name == 'Clinic based nurse'}),
        JobPositionPractice.create!(practice: happen, job_position: job_positions.find {|jp| jp.name == 'Clinic based physician'}),
        JobPositionPractice.create!(practice: happen, job_position: job_positions.find {|jp| jp.name == 'Hospital based nurse'}),
        JobPositionPractice.create!(practice: happen, job_position: job_positions.find {|jp| jp.name == 'Hospital based physician'}),
        JobPositionPractice.create!(practice: happen, job_position: job_positions.find {|jp| jp.name == 'Hospital based physician'}),
        JobPositionPractice.create!(practice: happen, job_position: job_positions.find {|jp| jp.name == 'Nursing Assistant'}),
        JobPositionPractice.create!(practice: happen, job_position: job_positions.find {|jp| jp.name == 'Pharmacist'}),
        JobPositionPractice.create!(practice: happen, job_position: job_positions.find {|jp| jp.name == 'Pharmacy Tech'}),
    ]

    happen_ancillary_services = [
        AncillaryServicePractice.create!(practice: happen, ancillary_service: ancillary_services.find {|as| as.name == 'Pharmacy'}),
        AncillaryServicePractice.create!(practice: happen, ancillary_service: ancillary_services.find {|as| as.name == 'Social Work'}),
    ]

    happen_clinical_locations = [
        ClinicalLocationPractice.create!(practice: happen, clinical_location: clinical_locations.find {|cl| cl.name == 'Alcohol and Other Drug Abuse (AODA) treatment center'}),
        ClinicalLocationPractice.create!(practice: happen, clinical_location: clinical_locations.find {|cl| cl.name == 'Assisted Living Facility'}),
        ClinicalLocationPractice.create!(practice: happen, clinical_location: clinical_locations.find {|cl| cl.name == 'Community Based Outpatient Clinic (CBOC)'}),
        ClinicalLocationPractice.create!(practice: happen, clinical_location: clinical_locations.find {|cl| cl.name == 'Community Living Centers (CLC)'}),
        ClinicalLocationPractice.create!(practice: happen, clinical_location: clinical_locations.find {|cl| cl.name == 'Home Health'}),
        ClinicalLocationPractice.create!(practice: happen, clinical_location: clinical_locations.find {|cl| cl.name == 'Inpatient Hospital'}),
        ClinicalLocationPractice.create!(practice: happen, clinical_location: clinical_locations.find {|cl| cl.name == 'Outpatient Surgery Center'}),
        ClinicalLocationPractice.create!(practice: happen, clinical_location: clinical_locations.find {|cl| cl.name == 'Pain Clinic'}),
        ClinicalLocationPractice.create!(practice: happen, clinical_location: clinical_locations.find {|cl| cl.name == 'Skilled Nursing Facility (SNF)'}),
    ]

    happen_risks_and_mitigations = [
        RiskAndMitigation.create!(practice: happen, risk: 'Unwillingness to participate', mitigation: ' mitigate through targeted comms and education'),
    ]

    happen_publications = [
        # Publication.create!(practice: happen, title: 'OIG Inspection')
    ]

    happen_badges = [
        BadgePractice.create!(practice: happen, badge: badges.find {|b| b.name == 'Diffusion of Excellence'}),
        BadgePractice.create!(practice: happen, badge: badges.find {|b| b.name == 'Shark Tank Approved'}),
        BadgePractice.create!(practice: happen, badge: badges.find {|b| b.name == 'Gold Status'}),
    ]
    
  end
else
  puts 'Database already seeded... Nothing to do.'
end

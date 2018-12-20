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
      StrategicSponsor.create!(name: 'VISIN', short_name: 'visin', description: 'Sponsored by a VISIN'),
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
        Badge.create!(name: 'VISIN', short_name: 'visin', description: 'Vetted by the VISIN', strategic_sponsor: sponsors[0]),
        Badge.create!(name: 'VHA System Redesign', short_name: 'vha_system_redesign', description: 'Vetted by VHA System Redesign', strategic_sponsor: sponsors[4]),
        Badge.create!(name: 'VHA Office of Connected Care', short_name: 'vha_office_of_connected_care', description: 'Vetted by the VHA Office of Connected Care', strategic_sponsor: sponsors[5]),
        Badge.create!(name: 'HSR&D', short_name: 'hsrd', description: 'Vetted by HSR&D', strategic_sponsor: sponsors[3]),
        Badge.create!(name: 'Office of Rural Health', short_name: 'office_of_rural_health', description: 'Vetted by the Office of Rural Health', strategic_sponsor: sponsors[2]),
        Badge.create!(name: 'Diffusion of Excellence', short_name: 'diffusion_of_excellence', description: 'Vetted by Diffusion of Excellence', strategic_sponsor: sponsors[1]),
        Badge.create!(name: 'Shark Tank Approved', short_name: 'shark_tank_approved', description: 'Shark Tank Approved', strategic_sponsor: sponsors[1]),
        Badge.create!(name: 'Top 100 Shark Tank', short_name: 'shark_tank_100', description: 'Top 100 Shark Tank finisher', strategic_sponsor: sponsors[1]),
        Badge.create!(name: 'Top 20 Shark Tank', short_name: 'shark_tank_20', description: 'Top 20 Shark Tank finisher', strategic_sponsor: sponsors[1]),
        Badge.create!(name: 'Gold Status', short_name: 'gold_status', description: 'Gold Status Practice', strategic_sponsor: sponsors[1]),
        Badge.create!(name: 'Authority to Operate (ATO)', short_name: 'ato', description: 'Authority to Operate (ATO)', strategic_sponsor: sponsors.last),
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

  unless Practice.all.present?
    flow3 = Practice.create!(
        name: 'FLOW3',
        short_name: 'flow3',
        description: 'FLOW3 improves the Prosthetic Limb Acquisition time by more than half.',
        date_initiated: DateTime.now,
        vha_visin: 'n/a',
        medical_center: 'Pudget Sound Health Care System',
        cboc: 'n/a',
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
        va_pulse_link: 'https://www.vapulse.net/groups/flow3'
    )
  end
else
  puts 'Database already seeded... Nothing to do.'
end

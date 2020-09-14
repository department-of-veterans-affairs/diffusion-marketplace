# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#


puts 'Seeding Database...'

_partners = [
    PracticePartner.find_or_create_by!(name: 'Diffusion of Excellence', short_name: '', description: 'The Diffusion of Excellence Initiative helps to identify and disseminate clinical and administrative best practices through a learning environment that empowers its top performers to apply their innovative ideas throughout the system — further establishing VA as a leader in health care, while promoting positive outcomes for Veterans.', icon: 'fas fa-heart', color: '#E4A002'),
    PracticePartner.find_or_create_by!(name: 'Office of Rural Health', short_name: 'ORH', description: 'Congress established the Veterans Health Administration Office of Rural Health in 2006 to conduct, coordinate, promote and disseminate research on issues that affect the nearly five million Veterans who reside in rural communities. Working through its three Veterans Rural Health Resource Centers, as well as partners from academia, state and local governments, private industry, and non-profit organizations, ORH strives to break down the barriers separating rural Veterans from quality care.', icon: 'fas fa-mountain', color: '#1CC2AE'),
    PracticePartner.find_or_create_by!(name: 'Health Services Research & Development', short_name: 'HSR&D', description: 'The VA Health Services Research and Development Service (HSR&D) is an integral part of VA’s quest for innovative solutions to today’s health care challenges. HSR&D supports research that encompasses all aspects of VA health care, focusing on patient care, cost, and quality. The main mission of HSR&D research is to identify, evaluate, and rapidly implement evidence-based strategies that improve the quality and safety of care delivered to Veterans.', icon: 'fas fa-microscope', color: '#9058D3'),
    PracticePartner.find_or_create_by!(name: 'Systems Redesign and Improvement', short_name: 'SR', description: 'The Systems Redesign and Improvement Program (10E2F) supports the development of VHA improvement capability to examine all parts of the VHA integrated delivery system with the overarching goal of identifying opportunities to reduce variation, remove waste, and manage constraints.', icon: 'fas fa-cogs', color: '#FE4497'),
    PracticePartner.find_or_create_by!(name: 'Office of Connected Care', short_name: 'OCC', description: 'The OCC focuses on improving health care through technology by engaging Veterans and care teams outside of traditional health care visits. By bringing together VA digital health technologies under one umbrella, the Office of Connected Care is enhancing health care coordination across VA and supporting Veterans’ participation in their own care.', icon: 'fas fa-hand-holding-heart', color: '#E52107'),
    # PracticePartner.find_or_create_by!(name: 'Office of Prosthetics and Rehabilitation', short_name: '', description: 'Rehabilitation and Prosthetic Services is committed to providing the highest quality, comprehensive, interdisciplinary care; the most advanced medical devices and products that are commercially available; and, promoting advancements in rehabilitative care and evidence-based treatment.', icon: 'fas fa-certificate', color: '#0076D6'),
    # PracticePartner.find_or_create_by!(name: 'Office of Mental Health and Suicide Prevention', short_name: 'OMHSP', description: 'For the U.S. Department of Veterans Affairs (VA), nothing is more important than supporting the health and well-being of the Nation’s Veterans and their families. A major part of that support is providing timely access to high-quality, evidence-based mental health care. VA aims to address Veterans’ needs, during Service members’ reintegration into civilian life and beyond.', icon: 'fas fa-certificate', color: '#0076D6'),
    # PracticePartner.find_or_create_by!(name: 'National Opioid Overdose Education Naloxone Distribution (OEND) Program Office', short_name: 'oend', description: 'Sponsored by the National Opioid Overdose Education Naloxone Distribution Program Office', icon: 'fas fa-certificate', color: '#0076D6'),
    # PracticePartner.find_or_create_by!(name: 'Pharmacy Benefits Management (PBM)', short_name: 'pbm', description: 'Sponsored by the Pharmacy Benefits Management (PBM)', icon: 'fas fa-certificate', color: '#0076D6'),
    # PracticePartner.find_or_create_by!(name: 'Academic Detailing Service', short_name: 'ads', description: 'Sponsored by the Academic Detailing Service', icon: 'fas fa-certificate', color: '#0076D6'),
    # PracticePartner.find_or_create_by!(name: 'National Center for Patient Safety (NCPS)', short_name: 'ncps', description: 'Sponsored by the National Center for Patient Safety (NCPS)', icon: 'fas fa-certificate', color: '#0076D6'),
    # PracticePartner.find_or_create_by!(name: 'VA Police', short_name: 'va_police', description: 'Sponsored by the VA Police', icon: 'fas fa-certificate', color: '#0076D6'),
    PracticePartner.find_or_create_by!(name: 'Veterans Experience Office', short_name: 'VEO', description: 'The mission of the VEO is to enable VA to be the leading customer service organization in government so that Veterans, their families, caregivers, and survivors choose VA. VEO implements solutions based on Veteran-centered designs and industry best practices, while aligning VA services with the Secretary’s five priorities.', icon: 'fas fa-certificate', color: '#0076D6'),
    PracticePartner.find_or_create_by!(name: 'Quality Enhancement Research Initiative', short_name: 'QUERI', description: 'QUERI leverages scientifically-supported quality improvement (QI) methods, paired with a deep understanding of Veterans’ preferences and needs, to implement evidence-based practices (EBPs) rapidly into routine care and improve the quality and safety of care delivered to Veterans.', icon: 'fas fa-certificate', color: '#0076D6'),
    # PracticePartner.find_or_create_by!(name: 'Office of Information and Technology', short_name: 'OIT', description: '', icon: 'fas fa-certificate', color: '#0076D6'),
    # PracticePartner.find_or_create_by!(name: 'VHA Innovators Network', short_name: 'INET', description: '', icon: 'fas fa-certificate', color: '#0076D6'),
    PracticePartner.find_or_create_by!(name: 'Office of Veterans Access to Care', short_name: 'OVAC', description: 'The purpose of OVAC is to grow and sustain the Veterans Health Administration (VHA) as the most accessible health care system in the U.S. by providing oversight and accountability for improvement solutions. OVAC continues the VA mission to offer Veterans timely and quality access to care.', icon: 'fas fa-certificate', color: '#0076D6'),
]

_va_secretary_priorities = [
    VaSecretaryPriority.find_or_create_by!(name: 'Giving Veterans choice', short_name: 'giving_veterans_choice', description: 'Giving verterans choice'),
    VaSecretaryPriority.find_or_create_by!(name: 'Modernizing the VA', short_name: 'modernizing_the_va', description: 'Modernization the VA'),
    VaSecretaryPriority.find_or_create_by!(name: 'Improving the timeliness of services', short_name: 'improving_timeliness', description: 'Improving the timeliness of services'),
    VaSecretaryPriority.find_or_create_by!(name: 'Focusing resources based on importance', short_name: 'focusing_resources', description: 'Focusing resources based on importance'),
    VaSecretaryPriority.find_or_create_by!(name: 'Preventing suicide', short_name: 'preventing_suicide', description: 'Preventing suicide'),
]


_domains = [
    Domain.find_or_create_by!(name: 'Veteran', description: 'Enables an improvement in satisfaction or customer experience for Veterans'),
    Domain.find_or_create_by!(name: 'Clinical', description: 'Produces an improvement in health outcomes'),
    Domain.find_or_create_by!(name: 'Financial', description: 'Generates cost savings or enables cost avoidance'),
    Domain.find_or_create_by!(name: 'Operational', description: 'Delivers a measure of increased efficiency or productivity in operational activities'),
    Domain.find_or_create_by!(name: 'Societal', description: 'Delivers a collective benefit to society or healthcare community as a whole'),
]


impact_categories = [
    Category.find_or_create_by!(name: 'Clinical', short_name: 'clinical', description: 'Categorys on clinical domains'),
    Category.find_or_create_by!(name: 'Operational', short_name: 'operational', description: 'Categorys on operational domains'),
]

_clinical_impacts = [
    Category.find_or_create_by!(name: 'Allergy and Immunology', short_name: 'allergy_and_immunology', description: 'Allergy and Immunology', parent_category: impact_categories[0]),
    Category.find_or_create_by!(name: 'Cardiology', short_name: 'cardiology', description: 'Cardiology', parent_category: impact_categories[0]),
    Category.find_or_create_by!(name: 'Critical Care (ICU)', short_name: 'icu', description: 'Critical Care (ICU)', parent_category: impact_categories[0]),
    Category.find_or_create_by!(name: 'Dermatology', short_name: 'dermatology', description: 'Dermatology', parent_category: impact_categories[0]),
    Category.find_or_create_by!(name: 'Endocrinology', short_name: 'endocrinology', description: 'Endocrinology', parent_category: impact_categories[0]),
    Category.find_or_create_by!(name: 'Hematology', short_name: 'hematology', description: 'Hematology', parent_category: impact_categories[0]),
    Category.find_or_create_by!(name: 'Infectious Disease', short_name: 'infectious_disease', description: 'Infectious Disease', parent_category: impact_categories[0]),
    Category.find_or_create_by!(name: 'Mental Health / Psychiatry', short_name: 'mental_health_psychiatry', description: 'Mental Health / Psychiatry', parent_category: impact_categories[0]),
    Category.find_or_create_by!(name: 'Neurology', short_name: 'neurology', description: 'Neurology', parent_category: impact_categories[0]),
    Category.find_or_create_by!(name: 'Obstetrics & Gynecology', short_name: 'obstetrics_gynecology', description: 'Obstetrics & Gynecology', parent_category: impact_categories[0]),
    Category.find_or_create_by!(name: 'Oncology', short_name: 'oncology', description: 'Oncology', parent_category: impact_categories[0]),
    Category.find_or_create_by!(name: 'Ophthalmology', short_name: 'ophthalmology', description: 'Ophthalmology', parent_category: impact_categories[0]),
    Category.find_or_create_by!(name: 'Orthopedic Surgery', short_name: 'orthopedic_surgery', description: 'Orthopedic Surgery', parent_category: impact_categories[0]),
    Category.find_or_create_by!(name: 'Otolaryngology (ENT)', short_name: 'ent', description: 'Otolaryngology (ENT)', parent_category: impact_categories[0]),
    Category.find_or_create_by!(name: 'Pathology', short_name: 'pathology', description: 'Pathology', parent_category: impact_categories[0]),
    Category.find_or_create_by!(name: 'Pediatrics', short_name: 'pediatrics', description: 'Pediatrics', parent_category: impact_categories[0]),
    Category.find_or_create_by!(name: 'Primary Care / Preventive Medicine', short_name: 'primary_care_preventive_medicine', description: 'Primary Care / Preventive Medicine', parent_category: impact_categories[0]),
    Category.find_or_create_by!(name: 'Pulmonology / Respiratory', short_name: 'pulmonology_respiratory', description: 'Pulmonology / Respiratory', parent_category: impact_categories[0]),
    Category.find_or_create_by!(name: 'Rehab Medicine', short_name: 'rehab_medicine', description: 'Rehab Medicine', parent_category: impact_categories[0]),
    Category.find_or_create_by!(name: 'Renal / Nephrology', short_name: 'renal_nephrology', description: 'Renal / Nephrology', parent_category: impact_categories[0]),
    Category.find_or_create_by!(name: 'Rheumatology', short_name: 'rheumatology', description: 'Rheumatology', parent_category: impact_categories[0]),
    Category.find_or_create_by!(name: 'Specialty Care (outside of VA)', short_name: 'specialty_care_outside_of_va)', description: 'Specialty Care (outside of VA)', parent_category: impact_categories[0]),
    Category.find_or_create_by!(name: 'Surgery', short_name: 'surgery', description: 'Surgery', parent_category: impact_categories[0]),
    Category.find_or_create_by!(name: 'Toxicology', short_name: 'toxicology', description: 'Toxicology', parent_category: impact_categories[0]),
    Category.find_or_create_by!(name: 'Urology', short_name: 'urology', description: 'Urology', parent_category: impact_categories[0]),
    Category.find_or_create_by!(name: 'Prosthetics and Rehabilitation', short_name: 'prosthetics_and_rehabilitation', description: 'Prosthetics and Rehabilitation', parent_category: impact_categories[0]),
    Category.find_or_create_by!(name: 'Alternative Therapies', short_name: 'alternative_therapies', description: 'Alternative Therapies', parent_category: impact_categories[0]),
    Category.find_or_create_by!(name: 'Massage', short_name: 'massage', description: 'Massage', parent_category: impact_categories[0]),
    Category.find_or_create_by!(name: 'Herbal Remedies', short_name: 'herbal_remedies', description: 'Herbal Remedies', parent_category: impact_categories[0]),
    Category.find_or_create_by!(name: 'Acupuncture', short_name: 'acupuncture', description: 'Acupuncture', parent_category: impact_categories[0]),
    Category.find_or_create_by!(name: 'Dental', short_name: 'dental', description: 'Dental', parent_category: impact_categories[0]),
    Category.find_or_create_by!(name: 'Homeless services', short_name: 'homeless_services', description: 'Homeless services', parent_category: impact_categories[0]),
    Category.find_or_create_by!(name: 'Social workers', short_name: 'social_workers', description: 'Social workers', parent_category: impact_categories[0]),
    Category.find_or_create_by!(name: 'None', short_name: 'none', description: 'No clinical impact', parent_category: impact_categories[0]),
]

_operational_impacts = [
    Category.find_or_create_by!(name: 'Administration', short_name: 'administration', description: 'Administration', parent_category: impact_categories[1]),
    Category.find_or_create_by!(name: 'Billing', short_name: 'billing', description: 'Billing', parent_category: impact_categories[1]),
    Category.find_or_create_by!(name: 'Biomed', short_name: 'biomed', description: 'Biomed', parent_category: impact_categories[1]),
    Category.find_or_create_by!(name: 'Building Management', short_name: 'building_management', description: 'Building Management', parent_category: impact_categories[1]),
    Category.find_or_create_by!(name: 'Education and Training', short_name: 'education_and_training', description: 'Education and Training', parent_category: impact_categories[1]),
    Category.find_or_create_by!(name: 'Food Service', short_name: 'food_service', description: 'Food Service', parent_category: impact_categories[1]),
    Category.find_or_create_by!(name: 'Human Resources', short_name: 'human_resources', description: 'Human Resources', parent_category: impact_categories[1]),
    Category.find_or_create_by!(name: 'Information Technology', short_name: 'information_technology', description: 'Information Technology', parent_category: impact_categories[1]),
    Category.find_or_create_by!(name: 'Logistics', short_name: 'logistics', description: 'Logistics', parent_category: impact_categories[1]),
    Category.find_or_create_by!(name: 'Maintenance', short_name: 'maintenance', description: 'Maintenance', parent_category: impact_categories[1]),
    Category.find_or_create_by!(name: 'Marketing', short_name: 'marketing', description: 'Marketing', parent_category: impact_categories[1]),
    Category.find_or_create_by!(name: 'Medical Records', short_name: 'medical_records', description: 'Medical Records', parent_category: impact_categories[1]),
    Category.find_or_create_by!(name: 'Occupational Health', short_name: 'occupational_health', description: 'Occupational Health', parent_category: impact_categories[1]),
    Category.find_or_create_by!(name: 'Quality Control', short_name: 'quality_control', description: 'Quality Control', parent_category: impact_categories[1]),
    Category.find_or_create_by!(name: 'Risk Management', short_name: 'risk_management', description: 'Risk Management', parent_category: impact_categories[1]),
    Category.find_or_create_by!(name: 'Social Services', short_name: 'social_services', description: 'Social Services', parent_category: impact_categories[1]),
    Category.find_or_create_by!(name: 'Contracting & Purchasing', short_name: 'contracting_purchasing', description: 'Contracting & Purchasing', parent_category: impact_categories[1]),
    Category.find_or_create_by!(name: 'None', short_name: 'none', description: 'No clinical impact', parent_category: impact_categories[1]),
]


_job_positions = [
    JobPosition.find_or_create_by!(name: 'Clinic based nurse', short_name: 'clinic_based_nurse', description: 'Clinic based nurse'),
    JobPosition.find_or_create_by!(name: 'Clinic based physician', short_name: 'clinic_based_physician', description: 'Clinic based physician'),
    JobPosition.find_or_create_by!(name: 'Hospital based nurse', short_name: 'hospital_based_nurse', description: 'Hospital based nurse'),
    JobPosition.find_or_create_by!(name: 'Hospital based physician', short_name: 'hospital_based_physician', description: 'Hospital based physician'),
    JobPosition.find_or_create_by!(name: 'Nursing Assistant', short_name: 'nursing_assistant', description: 'Nursing Assistant'),
    JobPosition.find_or_create_by!(name: 'Pharmacist', short_name: 'pharmacist', description: 'Pharmacist'),
    JobPosition.find_or_create_by!(name: 'Pharmacy Tech', short_name: 'pharmacy_tech', description: 'Pharmacy Tech'),
    JobPosition.find_or_create_by!(name: 'Researcher', short_name: 'researcher', description: 'Researcher'),
    JobPosition.find_or_create_by!(name: 'Prosthetist', short_name: 'prosthetist', description: 'Prosthetist'),
    JobPosition.find_or_create_by!(name: 'Purchasing Agent', short_name: 'purchasing_agent', description: 'Purchasing Agent'),
    JobPosition.find_or_create_by!(name: 'Dentist', short_name: 'dentist', description: 'Dentist'),
]


_clinical_conditions = [
    ClinicalCondition.find_or_create_by!(name: 'Back Pain', short_name: 'back_pain', description: 'Back pain'),
    ClinicalCondition.find_or_create_by!(name: 'Chronic Obstructive Pulmonary Disease (COPD)', short_name: 'copd', description: 'Chronic Obstructive Pulmonary Disease (COPD)'),
    ClinicalCondition.find_or_create_by!(name: 'Chronic Pain', short_name: 'chronic_pain', description: 'Chronic Pain'),
    ClinicalCondition.find_or_create_by!(name: 'Congestive Heart Failure (CHF)', short_name: 'chf', description: 'Congestive Heart Failure (CHF)'),
    ClinicalCondition.find_or_create_by!(name: 'Depression', short_name: 'depression', description: 'Depression'),
    ClinicalCondition.find_or_create_by!(name: 'Diabetes Melitus', short_name: 'diabetes_melitus', description: 'Diabetes Melitus'),
    ClinicalCondition.find_or_create_by!(name: 'Headache', short_name: 'headache', description: 'Headache'),
    ClinicalCondition.find_or_create_by!(name: 'Hearing Loss', short_name: 'hearing_loss', description: 'Hearing Loss'),
    ClinicalCondition.find_or_create_by!(name: 'Hypertension', short_name: 'hypertension', description: 'Hypertension'),
    ClinicalCondition.find_or_create_by!(name: 'Obesity', short_name: 'obesity', description: 'Obesity'),
    ClinicalCondition.find_or_create_by!(name: 'Post-Traumatic Stress Disorder', short_name: 'ptsd', description: 'Post-Traumatic Stress Disorder'),
    ClinicalCondition.find_or_create_by!(name: 'Sleep Apnea', short_name: 'sleep_apnea', description: 'Sleep Apnea'),
    ClinicalCondition.find_or_create_by!(name: 'Smoking', short_name: 'smoking', description: 'Smoking'),
    ClinicalCondition.find_or_create_by!(name: 'Suicide', short_name: 'suicide', description: 'Suicide'),
    ClinicalCondition.find_or_create_by!(name: 'Prosthetic Limbs', short_name: 'prosthetic_limbs', description: 'Prosthetic Limbs'),
    ClinicalCondition.find_or_create_by!(name: 'Sensory Aids', short_name: 'sensory_aids', description: 'Sensory Aids'),
    ClinicalCondition.find_or_create_by!(name: 'Amputation', short_name: 'amputation', description: 'Amputation'),
    ClinicalCondition.find_or_create_by!(name: 'Hospital acquired pneumonia', short_name: 'hospital_acquired_pneumonia', description: 'Hospital acquired pneumonia'),
    ClinicalCondition.find_or_create_by!(name: 'Addiction', short_name: 'addiction', description: 'Addiction'),
    ClinicalCondition.find_or_create_by!(name: 'Accidental overdose', short_name: 'accidental_overdose', description: 'Accidental overdose'),
    ClinicalCondition.find_or_create_by!(name: 'Hospital acquired pneumonia', short_name: 'hospital_acquired_pneumonia', description: 'Hospital acquired pneumonia'),
]


_ancillary_services = [
    AncillaryService.find_or_create_by!(name: 'Audiology', short_name: 'audiology', description: 'Audiology'),
    AncillaryService.find_or_create_by!(name: 'Laboratory', short_name: 'laboratory', description: 'Laboratory'),
    AncillaryService.find_or_create_by!(name: 'Occupational Therapy', short_name: 'occupational_therapy', description: 'Occupational Therapy'),
    AncillaryService.find_or_create_by!(name: 'Physical Therapy', short_name: 'physical_therapy', description: 'Physical Therapy'),
    AncillaryService.find_or_create_by!(name: 'Radiology', short_name: 'radiology', description: 'Radiology'),
    AncillaryService.find_or_create_by!(name: 'Rehabilitation & Prosthetics', short_name: 'rehabilitation_prosthetics', description: 'Rehabilitation & Prosthetics'),
    AncillaryService.find_or_create_by!(name: 'Social Work', short_name: 'social_work', description: 'Social Work'),
    AncillaryService.find_or_create_by!(name: 'Spiritual Services', short_name: 'spiritual_services', description: 'Spiritual Services'),
    AncillaryService.find_or_create_by!(name: 'Pharmacy', short_name: 'pharmacy', description: 'Pharmacy'),
]


_clinical_locations = [
    ClinicalLocation.find_or_create_by!(name: 'Alcohol and Other Drug Abuse (AODA) treatment center', short_name: 'aoda', description: 'Alcohol and Other Drug Abuse (AODA) treatment center'),
    ClinicalLocation.find_or_create_by!(name: 'Assisted Living Facility', short_name: 'assisted_living_facility', description: 'Assisted Living Facility'),
    ClinicalLocation.find_or_create_by!(name: 'Community Based Outpatient Clinic (CBOC)', short_name: 'cboc', description: 'Community Based Outpatient Clinic (CBOC)'),
    ClinicalLocation.find_or_create_by!(name: 'Community Living Centers (CLC)', short_name: 'clc', description: 'Community Living Centers (CLC)'),
    ClinicalLocation.find_or_create_by!(name: 'Home Health', short_name: 'home_health', description: 'Home Health'),
    ClinicalLocation.find_or_create_by!(name: 'Hospice Center', short_name: 'hospice_center', description: 'Hospice Center'),
    ClinicalLocation.find_or_create_by!(name: 'Inpatient Hospital', short_name: 'inpatient_hospital', description: 'Inpatient Hospital'),
    ClinicalLocation.find_or_create_by!(name: 'Outpatient Surgery Center', short_name: 'outpatient_surgery_center', description: 'Outpatient Surgery Center'),
    ClinicalLocation.find_or_create_by!(name: 'Pain Clinic', short_name: 'pain_clinic', description: 'Pain Clinic'),
    ClinicalLocation.find_or_create_by!(name: 'Skilled Nursing Facility (SNF)', short_name: 'snf', description: 'Skilled Nursing Facility (SNF)'),
]


_developing_facilities = [
    DevelopingFacilityType.find_or_create_by!(name: 'CBOC', short_name: 'cboc'),
    DevelopingFacilityType.find_or_create_by!(name: 'VA Medical Center', short_name: 'va_medical_center'),
    DevelopingFacilityType.find_or_create_by!(name: 'VA Program Office', short_name: 'va_program_office'),
    DevelopingFacilityType.find_or_create_by!(name: 'Outside of VA', short_name: 'outside_of_va'),
    DevelopingFacilityType.find_or_create_by!(name: 'Vendor', short_name: 'vendor'),
    DevelopingFacilityType.find_or_create_by!(name: 'Community Living Center (CLC)', short_name: 'clc'),
    DevelopingFacilityType.find_or_create_by!(name: 'Office of Mental Health', short_name: 'office_of_mental_health'),
]


_area_of_affects = [
    PracticeManagement.find_or_create_by!(name: 'Wait time to be seen'),
    PracticeManagement.find_or_create_by!(name: 'Doctor to patient time'),
    PracticeManagement.find_or_create_by!(name: 'Throughput'),
    PracticeManagement.find_or_create_by!(name: 'Discharge process'),
    PracticeManagement.find_or_create_by!(name: 'Discharge planning'),
    PracticeManagement.find_or_create_by!(name: 'Patient satisfaction'),
    PracticeManagement.find_or_create_by!(name: 'Provider/Staff retention'),
    PracticeManagement.find_or_create_by!(name: 'Provider/Staff satisfaction'),
    PracticeManagement.find_or_create_by!(name: 'Efficiency'),
    PracticeManagement.find_or_create_by!(name: 'Cost avoidance'),
    PracticeManagement.find_or_create_by!(name: 'Management'),
    PracticeManagement.find_or_create_by!(name: 'None')
]


_departments = [
    Department.find_or_create_by!(name: 'Admissions', short_name: 'admissions'),
    Department.find_or_create_by!(name: 'Anesthetics', short_name: 'anesthetics'),
    Department.find_or_create_by!(name: 'Center Supply', short_name: 'center_supply'),
    Department.find_or_create_by!(name: 'Chaplaincy', short_name: 'chaplaincy'),
    Department.find_or_create_by!(name: 'Coronary Care Unit', short_name: 'coronary_care_unit'),
    Department.find_or_create_by!(name: 'Critical Care', short_name: 'critical_care'),
    Department.find_or_create_by!(name: 'Diagnostic Imaging/X-ray/Radiology', short_name: 'diagnostic _imaging_x-ray_Radiology'),
    Department.find_or_create_by!(name: 'Discharge Planning', short_name: 'discharge_planning'),
    Department.find_or_create_by!(name: 'Elderly Services', short_name: 'elderly_services'),
    Department.find_or_create_by!(name: 'Emergency Services', short_name: 'emergency_services'),
    Department.find_or_create_by!(name: 'Finance Department', short_name: 'finance_department'),
    Department.find_or_create_by!(name: 'House Keeping', short_name: 'house_keeping'),
    Department.find_or_create_by!(name: 'Security', short_name: 'security'),
    Department.find_or_create_by!(name: 'Laundry', short_name: 'laundry'),
    Department.find_or_create_by!(name: 'Parking', short_name: 'parking'),
    Department.find_or_create_by!(name: 'General Surgery', short_name: 'general_surgery'),
    Department.find_or_create_by!(name: 'Occupational Health and Safety', short_name: 'occupational_health_and_safety'),
    Department.find_or_create_by!(name: 'Intensive Care Unit', short_name: 'intensive_care_unit'),
    Department.find_or_create_by!(name: 'Human Resources', short_name: 'human_resources'),
    Department.find_or_create_by!(name: 'Infection Control', short_name: 'infection_control'),
    Department.find_or_create_by!(name: 'Information Management', short_name: 'information_management'),
    Department.find_or_create_by!(name: 'Maternity', short_name: 'maternity'),
    Department.find_or_create_by!(name: 'Medical Records', short_name: 'medical_records'),
    Department.find_or_create_by!(name: 'Microbiology', short_name: 'microbiology'),
    Department.find_or_create_by!(name: 'Nutrition and Dietetics', short_name: 'nutrition_and_dietetics'),
    Department.find_or_create_by!(name: 'Patient Accounts', short_name: 'patient_accounts'),
    Department.find_or_create_by!(name: 'Patient Services', short_name: 'patient_services'),
    Department.find_or_create_by!(name: 'Pharmacy', short_name: 'pharmacy'),
    Department.find_or_create_by!(name: 'Physiotherapy', short_name: 'physiotherapy'),
    Department.find_or_create_by!(name: 'Purchasing and Supplies', short_name: 'purchasing_and_supplies'),
    Department.find_or_create_by!(name: 'Radiology', short_name: 'radiology'),
    Department.find_or_create_by!(name: 'Radiotherapy', short_name: 'radiotherapy'),
    Department.find_or_create_by!(name: 'Social Work', short_name: 'social_work'),
    Department.find_or_create_by!(name: 'None', short_name: 'none'),
    Department.find_or_create_by!(name: 'All departments equally - not a search differentiator', short_name: 'all'),
]


### USERS ###
unless Rails.env.production?
  User.create!(email: 'brad.johnson@agile6.com', password: 'Password123', password_confirmation: 'Password123', first_name: 'Brad', last_name: 'Johnson', job_title: 'Newbie', phone_number: '123-456-7890', visn: 8, bio: 'I\'m a demo. What else is there to say?', skip_va_validation: true, confirmed_at: Time.now).add_role(User::USER_ROLES[1].to_sym)
  User.create!(email: 'aurora.hay@agile6.com', password: 'Password123', password_confirmation: 'Password123', first_name: 'Aurora', last_name: 'Hampton', job_title: 'Head Honcho', phone_number: '987-654-3210', visn: 21, bio: 'Don\'t start nothin\' and there won\'t be nothin\'.', skip_va_validation: true, confirmed_at: Time.now).add_role(User::USER_ROLES[1].to_sym)
  User.create!(email: 'jake.holzhauer@agile6.com', password: 'Password123', password_confirmation: 'Password123', first_name: 'Jake', last_name: 'Holzhauer', job_title: 'Software Engineer', phone_number: '111-111-1111', visn: 16, bio: 'Living life to the fullest!', skip_va_validation: true, confirmed_at: Time.now).add_role(User::USER_ROLES[1].to_sym)
  User.create!(email: 'jackson.wilke@agile6.com', password: 'Password123', password_confirmation: 'Password123', first_name: 'Jackson', last_name: 'Wilke', job_title: 'Lead Designer', phone_number: '222-222-2222', visn: 19, bio: 'It\'s five o\'clock somewhere.', skip_va_validation: true, confirmed_at: Time.now).add_role(User::USER_ROLES[2].to_sym)
  User::USER_ROLES.each_with_index do |role, index|
    User.create!(email: "A6test#{index}@agile6.com", password: 'Password123', password_confirmation: 'Password123', first_name: "A6test#{index}", last_name: "Test", job_title: "Developer #{index}", phone_number: '333-333-3333', visn: 21, bio: "I\'m number #{index}!", skip_va_validation: true, confirmed_at: Time.now).add_role(User::USER_ROLES[index].to_sym)
  end
end

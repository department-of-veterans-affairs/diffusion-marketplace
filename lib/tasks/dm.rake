# Diffusion Marketplace related tasks

namespace :dm do
  # rails dm:db_setup
  desc 'Set up database'
  task :db_setup => :environment do
    Rake::Task['db:create'].execute
    Rake::Task['db:migrate'].execute
    Rake::Task['db:seed'].execute
  end

  # rails dm:full_import
  desc 'Set up data using the full flow of the importer'
  task :full_import => :environment do
    Rake::Task['dm:db_setup'].execute
    Rake::Task['importer:import_answers'].execute
    Rake::Task['importer:initial_featured'].execute
    Rake::Task['diffusion_history:all'].execute
    Rake::Task['milestones:milestones_transfer'].execute
  end

  # rails dm:reset_up
  desc 'Resets up database and imports all data from the full flow of the importer'
  task reset_up: :environment do
    Rake::Task['db:drop'].execute
    Rake::Task['dm:full_import'].execute
  end

  # rails dm:dummy_data
  desc 'Import dummy data'
  task :dummy_data => :environment do
    puts '==> Importing dummy data'

    dummy_data = "#{Rails.root}/tmp/practices_dummy_data.csv"

    CSV.foreach(dummy_data, headers: true) do |row|
      puts "==> Importing practice '#{row['project_name']}'"
      Practice.create!(
          name: row['project_name'],
          tagline: row['project_name'],
          date_initiated: row['start_date'],
          description: row['purpose'],
          summary: row['approach'],
          initiating_facility: row['business_office_sponsor'],
          approved: true,
          published: true
      )
    end
  end

  # rails dm:seed_practice_partners
  task seed_practice_partners: :environment do
    puts "*********** Seeding Practice Partners... **********".light_blue

    partners = [
        PracticePartner.create!(name: 'Diffusion of Excellence', short_name: '', description: 'The Diffusion of Excellence Initiative helps to identify and disseminate clinical and administrative best practices through a learning environment that empowers its top performers to apply their innovative ideas throughout the system — further establishing VA as a leader in health care, while promoting positive outcomes for Veterans.', icon: 'fas fa-heart', color: '#E4A002'),
        PracticePartner.create!(name: 'Office of Rural Health', short_name: 'ORH', description: 'Congress established the Veterans Health Administration Office of Rural Health in 2006 to conduct, coordinate, promote and disseminate research on issues that affect the nearly five million Veterans who reside in rural communities. Working through its three Veterans Rural Health Resource Centers, as well as partners from academia, state and local governments, private industry, and non-profit organizations, ORH strives to break down the barriers separating rural Veterans from quality care.', icon: 'fas fa-mountain', color: '#1CC2AE'),
        PracticePartner.create!(name: 'Health Services Research & Development', short_name: 'HSR&D', description: 'The VA Health Services Research and Development Service (HSR&D) is an integral part of VA’s quest for innovative solutions to today’s health care challenges. HSR&D supports research that encompasses all aspects of VA health care, focusing on patient care, cost, and quality. The main mission of HSR&D research is to identify, evaluate, and rapidly implement evidence-based strategies that improve the quality and safety of care delivered to Veterans.', icon: 'fas fa-microscope', color: '#9058D3'),
        # PracticePartner.create!(name: 'VHA System Redesign', short_name: 'SR', description: 'The Office of Connected Care brings VA digital technology to Veterans and health care professionals, extending access to care beyond the traditional office visit.', icon: 'fas fa-cogs', color: '#FE4497'),
        PracticePartner.create!(name: 'Office of Connected Care', short_name: 'OCC', description: 'The OCC focuses on improving health care through technology by engaging Veterans and care teams outside of traditional health care visits. By bringing together VA digital health technologies under one umbrella, the Office of Connected Care is enhancing health care coordination across VA and supporting Veterans’ participation in their own care.', icon: 'fas fa-hand-holding-heart', color: '#E52107'),
        # PracticePartner.create!(name: 'Office of Prosthetics and Rehabilitation', short_name: '', description: 'Rehabilitation and Prosthetic Services is committed to providing the highest quality, comprehensive, interdisciplinary care; the most advanced medical devices and products that are commercially available; and, promoting advancements in rehabilitative care and evidence-based treatment.', icon: 'fas fa-certificate', color: '#0076D6'),
        # PracticePartner.create!(name: 'Office of Mental Health and Suicide Prevention', short_name: 'OMHSP', description: 'For the U.S. Department of Veterans Affairs (VA), nothing is more important than supporting the health and well-being of the Nation’s Veterans and their families. A major part of that support is providing timely access to high-quality, evidence-based mental health care. VA aims to address Veterans’ needs, during Service members’ reintegration into civilian life and beyond.', icon: 'fas fa-certificate', color: '#0076D6'),
        # PracticePartner.create!(name: 'National Opioid Overdose Education Naloxone Distribution (OEND) Program Office', short_name: 'oend', description: 'Sponsored by the National Opioid Overdose Education Naloxone Distribution Program Office', icon: 'fas fa-certificate', color: '#0076D6'),
        # PracticePartner.create!(name: 'Pharmacy Benefits Management (PBM)', short_name: 'pbm', description: 'Sponsored by the Pharmacy Benefits Management (PBM)', icon: 'fas fa-certificate', color: '#0076D6'),
        # PracticePartner.create!(name: 'Academic Detailing Service', short_name: 'ads', description: 'Sponsored by the Academic Detailing Service', icon: 'fas fa-certificate', color: '#0076D6'),
        # PracticePartner.create!(name: 'National Center for Patient Safety (NCPS)', short_name: 'ncps', description: 'Sponsored by the National Center for Patient Safety (NCPS)', icon: 'fas fa-certificate', color: '#0076D6'),
        # PracticePartner.create!(name: 'VA Police', short_name: 'va_police', description: 'Sponsored by the VA Police', icon: 'fas fa-certificate', color: '#0076D6'),
        PracticePartner.create!(name: 'Veterans Experience Office', short_name: 'VEO', description: 'The mission of the VEO is to enable VA to be the leading customer service organization in government so that Veterans, their families, caregivers, and survivors choose VA. VEO implements solutions based on Veteran-centered designs and industry best practices, while aligning VA services with the Secretary’s five priorities.', icon: 'fas fa-certificate', color: '#0076D6'),
        PracticePartner.create!(name: 'Quality Enhancement Research Initiative', short_name: 'QUERI', description: 'QUERI leverages scientifically-supported quality improvement (QI) methods, paired with a deep understanding of Veterans’ preferences and needs, to implement evidence-based practices (EBPs) rapidly into routine care and improve the quality and safety of care delivered to Veterans.', icon: 'fas fa-certificate', color: '#0076D6'),
        # PracticePartner.create!(name: 'Office of Information and Technology', short_name: 'OIT', description: '', icon: 'fas fa-certificate', color: '#0076D6'),
        # PracticePartner.create!(name: 'VHA Innovators Network', short_name: 'INET', description: '', icon: 'fas fa-certificate', color: '#0076D6'),
        PracticePartner.create!(name: 'Office of Veterans Access to Care', short_name: 'OVAC', description: 'The purpose of OVAC is to grow and sustain VHA as the most accessible health care system in the U.S. by providing oversight and accountability for access improvement solutions. OVAC continues the VA mission to offer Veterans timely and quality access to care.', icon: 'fas fa-certificate', color: '#0076D6'),
    ]
    puts "*********** Completed Seeding Practice Partners! **********".green
  end

end

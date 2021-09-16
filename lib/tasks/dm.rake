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
    Rake::Task['visns:create_visns_and_transfer_data'].execute
    Rake::Task['va_facilities:create_va_facilities_and_transfer_data'].execute
    Rake::Task['visns:create_visn_liaisons_and_transfer_data'].execute
    Rake::Task['diffusion_history:all'].execute
    Rake::Task['go_fish_practices:assign_go_fish_badge'].execute
    Rake::Task['shark_tank_practices:assign_shark_tank_badge'].execute
    Rake::Task['inet_partner_practices:assign_inet_partner'].execute
    Rake::Task['categories:add_covid_cats'].execute
    Rake::Task['practice_origin_facilities:move_practice_initiating_facility'].execute
    Rake::Task['milestones:port_milestones_to_timelines'].execute
    Rake::Task['practice_multimedia:transfer_practice_impact_photos'].execute
    Rake::Task['practice_multimedia:transfer_practice_videos'].execute
    Rake::Task['documentation:port_additional_documents_to_practice_resources'].execute
    Rake::Task['documentation:port_publications_to_practice_resources'].execute
    Rake::Task['risk_and_mitigation:remove_unpaired_risks_and_mitigation'].execute
    Rake::Task['practice_editors:add_practice_owners_to_practice_editors'].execute
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
        PracticePartner.create!(name: 'Diffusion of Excellence', short_name: '', description: 'The Diffusion of Excellence Initiative helps to identify and disseminate clinical and administrative best innovations through a learning environment that empowers its top performers to apply their innovative ideas throughout the system — further establishing VA as a leader in health care, while promoting positive outcomes for Veterans.', icon: 'fas fa-heart', color: '#E4A002'),
        PracticePartner.create!(name: 'Office of Rural Health', short_name: 'ORH', description: 'Congress established the Veterans Health Administration Office of Rural Health in 2006 to conduct, coordinate, promote and disseminate research on issues that affect the nearly five million Veterans who reside in rural communities. Working through its three Veterans Rural Health Resource Centers, as well as partners from academia, state and local governments, private industry, and non-profit organizations, ORH strives to break down the barriers separating rural Veterans from quality care.', icon: 'fas fa-mountain', color: '#1CC2AE'),
        PracticePartner.create!(name: 'Health Services Research & Development', short_name: 'HSR&D', description: 'The VA Health Services Research and Development Service (HSR&D) is an integral part of VA’s quest for innovative solutions to today’s health care challenges. HSR&D supports research that encompasses all aspects of VA health care, focusing on patient care, cost, and quality. The main mission of HSR&D research is to identify, evaluate, and rapidly implement evidence-based strategies that improve the quality and safety of care delivered to Veterans.', icon: 'fas fa-microscope', color: '#9058D3'),
        PracticePartner.create!(name: 'Office of Connected Care', short_name: 'OCC', description: 'The OCC focuses on improving health care through technology by engaging Veterans and care teams outside of traditional health care visits. By bringing together VA digital health technologies under one umbrella, the Office of Connected Care is enhancing health care coordination across VA and supporting Veterans’ participation in their own care.', icon: 'fas fa-hand-holding-heart', color: '#E52107'),
        PracticePartner.create!(name: 'Veterans Experience Office', short_name: 'VEO', description: 'The mission of the VEO is to enable VA to be the leading customer service organization in government so that Veterans, their families, caregivers, and survivors choose VA. VEO implements solutions based on Veteran-centered designs and industry best innovations, while aligning VA services with the Secretary’s five priorities.', icon: 'fas fa-certificate', color: '#0076D6'),
        PracticePartner.create!(name: 'Quality Enhancement Research Initiative', short_name: 'QUERI', description: 'QUERI leverages scientifically-supported quality improvement (QI) methods, paired with a deep understanding of Veterans’ preferences and needs, to implement evidence-based practices (EBPs) rapidly into routine care and improve the quality and safety of care delivered to Veterans.', icon: 'fas fa-certificate', color: '#0076D6'),
        PracticePartner.create!(name: 'Office of Veterans Access to Care', short_name: 'OVAC', description: 'The purpose of OVAC is to grow and sustain VHA as the most accessible health care system in the U.S. by providing oversight and accountability for access improvement solutions. OVAC continues the VA mission to offer Veterans timely and quality access to care.', icon: 'fas fa-certificate', color: '#0076D6'),
    ]
    puts "*********** Completed Seeding Practice Partners! **********".green
  end

end

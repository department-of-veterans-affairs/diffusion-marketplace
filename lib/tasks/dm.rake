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
    FileUtils.rm_rf("#{Rails.root}/tmp/surveymonkey_responses")
    Rake::Task['surveymonkey:download_response_files'].execute
    Rake::Task['importer:import_answers'].execute
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

end

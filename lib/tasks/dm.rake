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

  #rails dm:reset_up
  desc 'Resets up database and imports all data from the full flow of the importer'
  task reset_up: :environment do
    Rake::Task['db:drop'].execute
    Rake::Task['dm:full_import'].execute
  end

end

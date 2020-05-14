# Categories related tasks
namespace :categories do

  # rails categories:add_covid_cats
  desc 'Add COVID related categories'
  task :add_covid_cats => :environment do
    covid_cats = ['COVID', 'Telehealth', 'Pulmonary Care', 'Environmental Services', 'Follow-up Care']

    covid_cats.each do |cat|
      if cat == 'COVID'
        Category.find_or_create_by!(name: cat, related_terms: ['COVID-19', 'Coronavirus'])
      else
        Category.find_or_create_by!(name: cat)
      end
    end
    puts "All #{covid_cats.length} COVID related categories have been added."
  end
end

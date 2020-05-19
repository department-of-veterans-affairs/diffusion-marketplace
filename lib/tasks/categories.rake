# Categories related tasks
namespace :categories do
  # rails categories:add_covid_cats
  desc 'Add COVID related categories to practices'
  task :add_covid_cats => :environment do
    covid_practices = [
      'advanced-comprehensive-diabetes-care-acdc',
      'evidence-based-tinnitus-care-for-veterans-nationwide',
      'home-based-cardiac-rehabilitation',
      'reach-va',
      'revamp-remote-veterans-apnea-management-platform',
      'national-telewound-care-practice',
      'national-telewound-care-practice',
      'telerehab-wheeled-mobility-clinic-to-cnh',
      'telesleep-home-sleep-apnea-testing-program',
      'video-blood-pressure-visits',
      'virtual-claims-clinic',
      'coatesville-vamc-hbpc-interdisciplinary-project',
      'copd-care',
      'project-happen',
      'dedicated-environmental-services-training-specialist',
      'green-gloves-program',
      'geri-vet'
    ]

    telehealth_practices = [
      'advanced-comprehensive-diabetes-care-acdc',
      'evidence-based-tinnitus-care-for-veterans-nationwide',
      'home-based-cardiac-rehabilitation',
      'reach-va',
      'revamp-remote-veterans-apnea-management-platform',
      'national-telewound-care-practice',
      'national-telewound-care-practice',
      'telerehab-wheeled-mobility-clinic-to-cnh',
      'telesleep-home-sleep-apnea-testing-program',
      'video-blood-pressure-visits',
      'virtual-claims-clinic'
    ]

    pulmonary_care_practices = [
      'coatesville-vamc-hbpc-interdisciplinary-project',
      'copd-care',
      'project-happen'
    ]

    environmental_services_practices = [
      'dedicated-environmental-services-training-specialist',
      'green-gloves-program'
    ]

    follow_up_care_practices = [
      'geri-vet'
    ]

    covid_cats = [
      Category.find_or_create_by!(name: 'COVID', related_terms: ['COVID-19', 'COVID 19', 'Coronavirus']),
      Category.find_or_create_by!(name: 'Telehealth'),
      Category.find_or_create_by!(name: 'Pulmonary Care'),
      Category.find_or_create_by!(name: 'Environmental Services'),
      Category.find_or_create_by!(name: 'Follow-up Care')
    ]

    puts "All #{covid_cats.length} COVID related categories have been added."

    covid_practices.each do |pr|
      practice = Practice.find_by(slug: pr)

      unless practice.nil?
        # add to COVID category
        CategoryPractice.find_or_create_by!(practice: practice, category: covid_cats[0])

        # add to Telehealth category
        CategoryPractice.find_or_create_by!(practice: practice, category: covid_cats[1]) if telehealth_practices.include? pr

        # add to Pulmonary Care category
        CategoryPractice.find_or_create_by!(practice: practice, category: covid_cats[2]) if pulmonary_care_practices.include? pr

        # add to Environmental Services category
        CategoryPractice.find_or_create_by!(practice: practice, category: covid_cats[3]) if environmental_services_practices.include? pr

        # add to Follow-up Care category
        CategoryPractice.find_or_create_by!(practice: practice, category: covid_cats[4]) if follow_up_care_practices.include? pr
      end
    end
    puts "#{covid_practices.length} practices have been assigned categories."
  end
end

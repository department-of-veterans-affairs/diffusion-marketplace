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

  desc 'Create parent categories'
  task :create_parent_categories => :environment do
    parent_categories = ['Clinical', 'Operational', 'Strategic']

    parent_categories.each do |pc|
      unless Category.get_category_by_name(pc).first.present?
        Category.create(name: pc)
        puts "#{pc} is now a parent category."
      end
    end
    puts "All parent categories have been successfully created!"
  end

  desc 'Assign a parent category to each existing category'
  task :assign_parent_category_to_existing_categories => :environment do
    clinical_categories = [
      'Anesthesiology',
      'Chaplain Care',
      'Continuity of Care',
      'Coordinated Care',
      'COVID-19 Testing and Screening',
      'Curbside Care',
      'Dentistry',
      'Dermatology',
      'Emergency Care',
      'Environmental Services',
      'Ethics in Health Care',
      'Geriatric Health',
      'Home Health',
      'Hospital Medicine',
      'Inpatient Care',
      'LGBT Health',
      'Medication Management',
      'Mental Health',
      'Nephrology',
      'Neurology',
      'Nursing',
      'Nutrition & Food',
      'Oncology',
      'Ophthalmology',
      'Outpatient Care',
      'Pathology',
      'Pharmacy',
      'Primary Care',
      'Prosthetic and Sensory Aids',
      'Psychiatry',
      'Pulmonary Care',
      'Radiology',
      'Rural Health',
      'Specialty Care',
      'Surgery',
      'Telehealth',
      'Urology',
      'Veteran Experience',
      'Whole Health',
      'Women\'s Health'
    ]

    operational_categories = [
      'Building Management',
      'Contracting',
      'Healthcare Administration',
      'Information Technology',
      'Logistics',
      'Veterans Benefits',
      'Workforce Development'
    ]

    strategic_categories = [
      'Access to Care',
      'Age-Friendly',
      'COVID-19',
      'Employee Experience',
      'Health Equity',
      'High Reliability',
      'Moving Forward',
      'Suicide Prevention'
    ]

    def assign_parent_cat(cat, parent_cat)
      cat_record = Category.get_category_by_name(cat).first
      if cat_record.present?
        cat_record.update_attributes(parent_category: parent_cat)
        puts "#{cat} now has a parent category of #{parent_cat.name}."
      else
        puts "#{cat} does not exist."
      end
    end

    clinical_parent_cat = Category.get_category_by_name('Clinical').first
    operational_parent_cat = Category.get_category_by_name('Operational').first
    strategic_parent_cat = Category.get_category_by_name('Strategic').first
    # assign clinical parent category to clinical categories
    clinical_categories.each do |cc|
      assign_parent_cat(cc, clinical_parent_cat)
    end
    # assign operational parent category to operational categories
    operational_categories.each do |oc|
      assign_parent_cat(oc, operational_parent_cat)
    end
    # assign strategic parent category to strategic categories
    strategic_categories.each do |sc|
      assign_parent_cat(sc, strategic_parent_cat)
    end

    puts "Existing categories have been successfully updated!"
  end

  # Instead of having an 'Other' category record, we will make it view-only in the introduction section of the practice editor
  desc "Delete 'Other' category"
  task :delete_other_category => :environment do
    other_cats = Category.get_category_by_name('Other')

    if other_cats.present?
      other_cats.each do |oc|
        oc.destroy
      end
      puts "'Other' category has been successfully deleted!"
    else
      puts "'Other' category does not exist"
    end
  end
end

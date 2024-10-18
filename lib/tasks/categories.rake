# Categories related tasks
namespace :categories do
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
        cat_record.update(parent_category: parent_cat)
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

  desc 'Add Communities categories to practices'
  task :add_communities_cats => :environment do
    community_practices = {
      'VA Immersive' => [
        'Cards for Connection',
        'Healthier Kidneys Through Your Kitchen',
        'WHoOpSafe'
      ],
      'QUERI' => [
        'Green Gloves Program',
        'GERI-VET',
        'Preoperative Frailty Screening & Prehabilitation'
      ],
      'Age-Friendly' => [
        'PRIDE In All Who Served: Reducing Healthcare Disparities for LGBT Veterans',
        'Red Coat Ambassador Program',
        'Red Coat Ambassador Program'
      ],
      'Suicide Prevention' => [
        'Transcending Self Therapy: Integrative Cognitive Behavioral Treatment',
        'Tour Of Duty',
        'Gerofit'
      ]
    }

    community_practices.each do |category_name, practice_names|
      category =  Category.find_by(name: category_name)

      if category
        practice_names.each do |practice_name|
          practice = Practice.find_by(name: practice_name)
          if practice
            CategoryPractice.find_or_create_by!(innovable: practice, category: category)
          end
        end
      end
    end
  end
end

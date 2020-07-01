namespace :departments do
  # rails departments:update_departments
  desc 'PRODUCTION DB ONLY: Associate Practices to new or renamed Departments and delete redundant Departments.'
  task :update_departments => :environment do
    # List of Departments to change Practices over to.
    # If there is more than one to change to, they are separated by a semi-colon (;)
    update_department_names = [
        {from: 'Anesthetics', to: 'Anesthesia'},
        {from: 'Center Supply', to: 'Central supply'},
        {from: 'Elderly Services', to: 'Geriatrics'},
        {from: 'Emergency Services', to: 'Emergency care'},
        {from: 'General Surgery', to: 'Surgery'},
        {from: 'House Keeping', to: 'Housekeeping'},
        {from: 'Information Management / Information Technology', to: 'Information management;Information technology'},
        {from: 'Nutrition and Dietetics', to: 'Nutrition, food, and dietary'},
        {from: 'Nutrition and Dietetics / Food Service', to: 'Nutrition, food, and dietary'},
        {from: 'Physiotherapy', to: 'Physical therapy, occupational therapy and kinesiothology'},
        {from: 'Primary Care, Geriatrics, HBPC', to: 'Primary care;Geriatrics'},
        {from: 'Radiotherapy', to: 'Radiation oncology'},
        {from: 'Social Work / Social Services', to: 'Social work;Social services'},
    ]

    update_department_names.each { |update_department|
      puts "----#{update_department[:from]}----"

      # Get the department the Practices are moving "from"
      from_department = Department.find_by(name: update_department[:from])

      # Get or create the department(s) the Practices are moving "to"
      to_departments =
          update_department[:to].split(';').map { |to_dep|
            Department.find_or_create_by!(name: to_dep)
          }

      # Get the joins table DepartmentPractices that link the Practice to the "from" department
      from_department_practices = DepartmentPractice.where(department: from_department)

      puts "FROM #{update_department[:from]} practices count: #{from_department_practices.count}"

      # For each of the DepartmentPractices...
      from_department_practices.each { |fdp|
        # For each of the "to" Departments
        to_departments.each { |to_dep|
          # Create a record joining the Practice to the new "to" Department
          DepartmentPractice.find_or_create_by!(practice_id: fdp.practice_id, department: to_dep, is_primary: fdp.is_primary)
        }

        # Destroy the link between the old "from" Department and the practice so the Department can be destroyed properly
        fdp.destroy
      }

      # Destroy the old "from" Department
      from_department.destroy! if from_department

      # This should have the same amount or more from the "from" practices count puts statement
      to_departments.each { |to_dep|
        to_department_practices = DepartmentPractice.where(department: to_dep)
        puts "TO #{to_dep.name} practices count: #{to_department_practices.count}"
      }
    }

    # delete "Navigation to these areas" Department
    navigation_to_these_areas_dep = Department.find_by(name: 'Navigation to these areas')
    if navigation_to_these_areas_dep
      navigation_to_these_areas_dep_pracs = DepartmentPractice.where(department: navigation_to_these_areas_dep)
      navigation_to_these_areas_dep_pracs.destroy_all
      navigation_to_these_areas_dep.destroy
      puts "Navigation to these areas destroyed"
    else
      puts "Navigation to these areas did not exist"
    end

  end
end
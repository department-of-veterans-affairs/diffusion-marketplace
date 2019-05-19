# A task setup for importing survey monkey questionnaire answers
namespace :importer do
  desc 'import an xlsx and create practices'
  task import_answers: :environment do |t, args|

    # TODO: pass in named arguments
    options = {}
    # OptionParser.new do |opts|
    #   opts.banner = "Usage: rails importer:import_answers [options]"
    #   opts.on("-f", "--file_path", String) {|file| options[:file] = file}
    #   opts.on('-b NUM', Integer)
    #   opts.on('-v', '--verbose')
    #   debugger
    # end.parse!

    puts "*********** Importing practices from: #{options[:file]} ***********".light_blue if options[:file].present?
    puts "!!!!!! No file path provided !!!!!!".yellow if options[:file].blank?
    puts "*********** Importing practices from: /lib/assets/Diffusion Marketplace.xlsx ***********".light_blue if options[:file].blank?
    import_file_path = options[:file].present? ? options[:file] : File.join(Rails.root, '/lib/assets/Diffusion Marketplace.xlsx')

    sheet = Roo::Excelx.new(import_file_path)
    @questions = sheet.sheet(0).row(1)
    @given_answers = sheet.sheet(0).row(2)
    last_row = sheet.last_row

    (3..last_row).each do |row_num|
      @answers = sheet.sheet(0).row(row_num)
      @respondent_id = @answers[0].to_i

      @name = @answers[@questions.index('What is the name of your practice?')]

      if @name.blank?
        puts "==> Aborting importing Respondent #{@respondent_id}'s answers - no name for the practice supplied.".red.bold
        next
      end

      puts "==> Importing Respondent: #{@respondent_id}".light_blue.on_white
      puts "==> Importing Practice: #{@name}".light_blue
      @practice = Practice.find_by_name(@name)

      if @practice.present?
        puts "This practice already exists in the system.".white.on_blue
        puts "Would you like to destroy and re-import this practice?. [Y/N]".white.on_blue
        answer = STDIN.gets.chomp
        case answer.downcase
        when 'y'
          destroy_practice
        when 'yes'
          destroy_practice
        when 'n'
          puts "Would you like to update/re-import this practice?. [Y/N]".white.on_blue
          puts "WARNING: this may duplicate files, pictures, risk and mitigation pairs, etc. to the practice that were already on there. Use wisely!".yellow
          ans = STDIN.gets.chomp
          case ans.downcase
          when 'y'
            puts "Updating/importing practice: #{@name}".light_blue
          when 'yes'
            puts "Updating/importing practice: #{@name}".light_blue
          when 'n'
            puts "Skipping practice #{@name} entirely!".yellow
            next
          when 'no'
            puts "Skipping practice #{@name} entirely!".yellow
            next
          else
            puts "Skipping practice #{@name} entirely!".yellow
            next
          end
        when 'yes'
          puts "Updating/re-importing practice: #{@name}".light_blue
        when 'n'
          puts "Updating/re-importing practice: #{@name}".light_blue
        else
          puts "Skipping practice #{@name} entirely!".yellow
          next
        end
      else
        @practice = Practice.create(name: @name)
      end


      # Basic Practice related questions first
      basic_answers
      file_uploads
      # TODO: Ask Andy if this needs to be dynamic
      @practice.approved = true
      @practice.published = true
      @practice.save!

      # sort all of the relational questions into their own methods for clarity.
      practice_partners
      va_employees
      # developing_facility_types
      # va_secretary_priorities
      # practice_managements
      categories
      # clinical_conditions
      financial_files
      job_positions
      ancillary_services
      clinical_locations
      departments
      video_files
      additional_documents
      # business_case_files
      toolkit_files
      checklist_files
      publication_files
      publications
      # badges
      implementation_timeline
      risk_mitigations
      additional_staff
      additional_resources
      required_training_staff
      costs_difficulties
      impact_photos
      domains
      practice_permissions
      timelines
      training_details
      license_required
      it_required
    end
    puts "*********** Completed Importing Practices! ***********".green
  end
end

def destroy_practice
  puts "\n Destroying and re-importing practice: #{@name}".white.on_red
  @practice.destroy
  @practice = Practice.create(name: @name)
end

def basic_answers
  puts "==> Importing Practice: #{@name} basic answers".light_blue
  question_fields = {
      # 'When was this practice initiated? If day is unknown, use the first of the month': :date_initiated,
      # The below question's text needs to be changed when a new sheet can be provided.
      "Please provide the \"facility id\" of the facility that initiated this Practice.": :initiating_facility,
      # 'Please enter an estimate in dollars of the cost avoidance per facility (Medical Center, CBOC, or applicable institution).': :impact_financial_estimate_saved,
      # 'Please enter relevant financial data regarding this practice such as ROI, a business case summary, or other financial analysis.': :impact_financial_roi,
      "Please supply an email address for this practice's support network in order to direct interested parties. (e.g. HAPPEN@va.gov)": :support_network_email,
      "Please identify where your practice falls currently in VHA’s Phase Gate Model of Innovation.": :phase_gate,
      "Do you have a link to your practice's VA Pulse Group?": :va_pulse_link,
      'How long does it usually take a group to implement your practice? How long do you expect it to take?': :implementation_time_estimate,
      'Do you have anything else you would like to share regarding your practice?': :additional_notes,
      'On the Practice page, we often use a descriptive tagline as the functional title. For example: the FLOW3 Practice is not well described by the title, and we therefor use the tagline: "Delivery of prosthetic limbs to Veterans in less than ½ the time".Please provide a 5-10 word descriptive tagline for your Practice. This will be used as the functional title.': :tagline,
      'On the Practice page, under the tagline/functional title you just provided, we would like a longer descriptive tagline to further explain your practice. For example, for FLOW3: "Enable 53% faster delivery of prosthetic limbs to Veterans. Automating the prosthetic limb procurement process to improve continuity of care for Veterans."Please provide a 1-2 line descriptive tagline for your Practice. This will be used below the functional title.': :description,
      'Please provide a 50-100 word descriptive paragraph for your Practice. ': :summary,
      # 'Please provide your best estimate rating of your Practice with regards to Cost Avoidance on a scale of 1 - 4.': :cost_savings_aggregate,
      # 'Please provide your best estimate rating of your Practice with regards to Impact on health/care experience on a scale of 1 - 4.': :veteran_satisfaction_aggregate,
      'Please provide your best estimate of the Cost to Implement your Practice on a scale of 1 - 4': :cost_to_implement_aggregate,
      'Please provide your best estimate of the Complexity of Implementation of your Practice on a scale of 1 - 4 (Complexity of getting the practice started.)': :difficulty_aggregate,
      'Please provide your best estimate of the Complexity of Maintenance and Sustainability of your Practice on a scale of 1 - 4': :sustainability_aggregate,
      'Is Information Technology (IT) required to implement the practice?': :it_required,
      'Is this practice a New Clinical Approach or New Process? Or is this practice a process change of something already being done? (Choose one of the following.)': :process,
      # 'Did your institution have to hire additional staff to implement this Practice?': :need_additional_staff,
      # 'Is there training required?': :need_training,
      'Please list who provides the training.': :training_provider,
      'Training details:': :required_training_summary,
      # 'Will a policy change be required?': :need_policy_change,
      # 'Will a new license or certification be required?': :need_new_license,
      'Please enter a 10-20 word title for the origin story of this Practice': :origin_title,
      'Please provide a 50 - 100 word paragraph sharing the story of the origin of this practice': :origin_story,
      'Number of facilities that have successfully implemented the Practice (Please enter a whole number):': :number_adopted,
      'Number of Departments required to implement the practice?': :number_departments,
      'Number of facilities that have attempted to implement the Practice and have NOT been successful (Please enter a whole number):': :number_failed,
  }
  question_fields.each do |key, value|
    @practice.send("#{value.to_sym}=", @answers[@questions.index(key.to_s)]) if value.present?
  end
  @practice.date_initiated = DateTime.strptime(@answers[@questions.index('When was this practice initiated? If day is unknown, use the first of the month'.to_s)], "%m/%d/%Y") if @answers[@questions.index('When was this practice initiated? If day is unknown, use the first of the month'.to_s)].present?
  @practice.phase_gate = @practice.phase_gate.split('.')[1].split('-')[0].squish
  @practice.save
end

def practice_partners
  puts "==> Importing Practice: #{@name} Practice Partners".light_blue
  question_fields = {
      'Which of the following statements regarding Partners apply to this Practice? (Mark all that apply)': 13
  }
  question_fields.each do |key, value|
    q_index = @questions.index(key.to_s)
    end_index = q_index + value - 1
    (q_index..end_index).each do |i|
      pp_name = @answers[i]
      next if pp_name.blank?

      if i == end_index && @given_answers[i] == 'Other (please specify) If more than one answer, please separate with a backslash ("\")'
        split_answer = pp_name.split(/\\/)
        split_answer.each do |ans|
          formatted_ans = ans.split(':')[0].squish
          practice_partner = PracticePartner.find_by(name: formatted_ans)
          practice_partner = PracticePartner.find_or_create_by(name: formatted_ans, icon: 'fas fa-circle', color: '#36383f') if practice_partner.nil?
          PracticePartnerPractice.create practice_partner: practice_partner, practice: @practice unless PracticePartnerPractice.where(practice_partner: practice_partner, practice: @practice).any?
        end
      else
        formatted_pp_name = pp_name.split(':')[0].squish
        practice_partner = PracticePartner.find_by(name: formatted_pp_name)
        practice_partner = PracticePartner.create!(name: formatted_pp_name, icon: 'fas fa-circle', color: '#36383f') if practice_partner.nil?

        PracticePartnerPractice.create practice_partner: practice_partner, practice: @practice unless PracticePartnerPractice.where(practice_partner: practice_partner, practice: @practice).any?
      end
    end
  end
end

def va_employees
  puts "==> Importing Practice: #{@name} Support Team".light_blue
  # TODO: Innovation team
  question_fields = {
      "Who are the VA employee(s) responsible for the support of this Practice? (SupportTeam)Please separate the person's Name from their Role with a backslash (\\).": 5
  }
  avatars = [
      'Please upload a headshot of Support Team Person 1',
      'Please upload a headshot of Support Team Person 2',
      'Please upload a headshot of Support Team Person 3',
      'Please upload a headshot of Support Team Person 4',
      'Please upload a headshot of Support Team Person 5',
  ]
  index = 0
  question_fields.each do |key, value|
    q_index = @questions.index(key.to_s)
    end_index = q_index + value - 1
    (q_index..end_index).each do |i|
      vae = @answers[i]
      next if vae.blank?

      vae = vae.split(/\\/)
      vae_name = vae[0]
      vae_role = vae[1]
      if @answers[@questions.index(avatars[index].to_s)].present?
        image_path = "#{Rails.root}/tmp/surveymonkey_responses/#{@respondent_id}/#{@answers[@questions.index(avatars[index].to_s)]}"
        image_file = File.new(image_path)
        va_employee = VaEmployee.find_by(name: vae_name, role: vae_role) || VaEmployee.create(name: vae_name, role: vae_role,
                                                                                              avatar: ActionDispatch::Http::UploadedFile.new(
                                                                                                  filename: File.basename(image_file),
                                                                                                  tempfile: image_file,
                                                                                                  # detect the image's mime type with MIME if you can't provide it yourself.
                                                                                                  type: MIME::Types.type_for(image_path).first.content_type
                                                                                              ))
        index += 1
      else
        va_employee = VaEmployee.find_or_create_by(name: vae_name, role: vae_role)
      end
      VaEmployeePractice.create va_employee: va_employee, practice: @practice unless VaEmployeePractice.where(va_employee: va_employee, practice: @practice).any?
    end
  end
end

# def developing_facility_types
#   puts "==> Importing Practice: #{@name} Developing Facility Types"
#   question_fields = {
#   }

#   question_fields.each do |key, value|
#     q_index = @questions.index(key.to_s)
#     end_index = q_index + value - 1
#     (q_index..end_index).each do |i|
#       answer = @answers[i]
#       next if answer.blank?

#       if i == end_index && @given_answers[i] == 'Other (please specify) If more than one answer, please separate with a backslash ("\")'
#         split_answer = answer.split(/\\/)
#         split_answer.each do |ans|
#           developing_facility = DevelopingFacilityType.find_by(name: ans) || DevelopingFacilityType.create(name: ans)
#           DevelopingFacilityTypePractice.create developing_facility_type: developing_facility, practice: @practice unless DevelopingFacilityTypePractice.where(developing_facility_type: developing_facility, practice: @practice).any?
#         end
#       else
#         developing_facility = DevelopingFacilityType.find_by(name: answer) || DevelopingFacilityType.create(name: answer)
#         DevelopingFacilityTypePractice.create developing_facility_type: developing_facility, practice: @practice unless DevelopingFacilityTypePractice.where(developing_facility_type: developing_facility, practice: @practice).any?
#       end
#     end
#   end
# end

# def va_secretary_priorities
#   puts "==> Importing Practice: #{@name} VA Secretary Priorities"
#   question_fields = {
#     "Which of the VA Secretary’s Priorities does this practice Address? (Please select all that apply.)": 7
#   }
#
#   question_fields.each do |key, value|
#     q_index = @questions.index(key.to_s)
#     end_index = q_index + value - 1
#     (q_index..end_index).each do |i|
#       answer = @answers[i]
#       next if answer.blank?
#
#       if i == end_index && @given_answers[i] == 'Other (please specify) If more than one answer, please separate with a backslash ("\")'
#         split_answer = answer.split(/\\/)
#         split_answer.each do |ans|
#           secretary_priority = VaSecretaryPriority.find_or_create_by(name: ans)
#           VaSecretaryPriorityPractice.create va_secretary_priority: secretary_priority, practice: @practice unless VaSecretaryPriorityPractice.where(va_secretary_priority: secretary_priority, practice: @practice).any?
#         end
#       else
#         secretary_priority = VaSecretaryPriority.find_or_create_by(name: answer)
#         VaSecretaryPriorityPractice.create va_secretary_priority: secretary_priority, practice: @practice unless VaSecretaryPriorityPractice.where(va_secretary_priority: secretary_priority, practice: @practice).any?
#       end
#     end
#   end
# end

# def practice_managements
#   puts "==> Importing Practice: #{@name} Practice Managements"
#   question_fields = {
#     "Which of the following areas does this practice affect? (Please select all that apply.)": 13
#   }
#
#   question_fields.each do |key, value|
#     q_index = @questions.index(key.to_s)
#     end_index = q_index + value - 1
#     (q_index..end_index).each do |i|
#       answer = @answers[i]
#       next if answer.blank?
#
#       if i == end_index && @given_answers[i] == 'Other (please specify) If more than one answer, please separate with a backslash ("\")'
#         split_answer = answer.split(/\\/)
#         split_answer.each do |ans|
#           practice_management = PracticeManagement.find_or_create_by(name: answer)
#           PracticeManagementPractice.create practice_management: practice_management, practice: @practice unless PracticeManagementPractice.where(practice_management: practice_management, practice: @practice).any?
#         end
#       else
#         practice_management = PracticeManagement.find_or_create_by(name: answer)
#         PracticeManagementPractice.create practice_management: practice_management, practice: @practice unless PracticeManagementPractice.where(practice_management: practice_management, practice: @practice).any?
#       end
#     end
#   end
# end

def categories
  puts "==> Importing Practice: #{@name} Categories".light_blue
  question_fields = {
      'What Primary care specialties does this Practice impact? Please mark all that apply.': 33,
      'What medical sub-specialties does this Practice impact? Please select all all that apply.': 23,
      'What surgical specialties does this Practice impact? Please select all all that apply.': 14,
      'What are the whole health impacts of this practice? (Please select all that apply.)': 8,
      "This question will allow the user to find your Practice by a medical complaint, clinical condition, or system of the body.\u2028\u2028 We are going to divide complaints, conditions, and systems anatomically.": 36,
      'Please enter one condition per line': 5
  }

  question_fields.each do |key, value|
    q_index = @questions.index(key.to_s)
    end_index = q_index + value - 1
    (q_index..end_index).each do |i|
      answer = @answers[i]
      next if answer.blank?

      if i == end_index && @given_answers[i] == 'Other (please specify) If more than one answer, please separate with a backslash ("\")'
        split_answer = answer.split(/\\/)
        split_answer.each do |ans|
          category = Category.find_or_create_by(name: ans)
          CategoryPractice.create category: category, practice: @practice unless CategoryPractice.where(category: category, practice: @practice).any?
        end
      else
        category = Category.find_or_create_by(name: answer)
        CategoryPractice.create category: category, practice: @practice unless CategoryPractice.where(category: category, practice: @practice).any?
      end
    end
  end
end

def clinical_conditions
  puts "==> Importing Practice: #{@name} Clinical Conditions".light_blue
  question_fields = {
      'Which of the following clinical conditions does this practice affect? (Please select all that apply.)': 16
  }

  question_fields.each do |key, value|
    q_index = @questions.index(key.to_s)
    end_index = q_index + value - 1
    (q_index..end_index).each do |i|
      answer = @answers[i]
      next if answer.blank?

      if i == end_index && @given_answers[i] == 'Other (please specify) If more than one answer, please separate with a backslash ("\")'
        split_answer = answer.split(/\\/)
        split_answer.each do |ans|
          condition = ClinicalCondition.find_or_create_by(name: ans)
          ClinicalConditionPractice.create clinical_condition: condition, practice: @practice unless ClinicalConditionPractice.where(clinical_condition: condition, practice: @practice).any?
        end
      else
        condition = ClinicalCondition.find_or_create_by(name: answer)
        ClinicalConditionPractice.create clinical_condition: condition, practice: @practice unless ClinicalConditionPractice.where(clinical_condition: condition, practice: @practice).any?
      end
    end
  end
end

def financial_files
  puts "==> Importing Practice: #{@name} Financial Files".light_blue
  question_fields = {
      "Please upload applicable financial information such as a formal business case/return on investment (ROI).": 1
  }
  question_fields.each do |key, value|
    next if @answers[@questions.index(key.to_s)].blank?
    image_path = "#{Rails.root}/tmp/surveymonkey_responses/#{@respondent_id}/#{@answers[@questions.index(key.to_s)]}"
    image_file = File.new(image_path)

    FinancialFile.create practice: @practice, attachment: ActionDispatch::Http::UploadedFile.new(
        filename: File.basename(image_file),
        tempfile: image_file,
        # detect the image's mime type with MIME if you can't provide it yourself.
        type: MIME::Types.type_for(image_path).first.content_type
    )
  end
end

def job_positions
  puts "==> Importing Practice: #{@name} Job Positions".light_blue
  question_fields = {
      "Which of the following job titles or positions does this practice impact? (Please select all that apply.)": 10
  }

  question_fields.each do |key, value|
    q_index = @questions.index(key.to_s)
    end_index = q_index + value - 1
    (q_index..end_index).each do |i|
      answer = @answers[i]
      next if answer.blank?

      if i == end_index && @given_answers[i] == 'Other (please specify) If more than one answer, please separate with a backslash ("\")'
        split_answer = answer.split(/\\/)
        split_answer.each do |ans|
          job_position = JobPosition.find_or_create_by(name: ans)
          JobPositionPractice.create job_position: job_position, practice: @practice unless JobPositionPractice.where(job_position: job_position, practice: @practice).any?
        end
      else
        job_position = JobPosition.find_or_create_by(name: answer)
        JobPositionPractice.create job_position: job_position, practice: @practice unless JobPositionPractice.where(job_position: job_position, practice: @practice).any?
      end
    end
  end
end

def ancillary_services
  puts "==> Importing Practice: #{@name} Ancillary Services".light_blue
  question_fields = {
      'Which of the following ancillary services does this practice impact? (Please select all that apply.)': 11
  }

  question_fields.each do |key, value|
    q_index = @questions.index(key.to_s)
    end_index = q_index + value - 1
    (q_index..end_index).each do |i|
      answer = @answers[i]
      next if answer.blank?

      if i == end_index && @given_answers[i] == 'Other (please specify) If more than one answer, please separate with a backslash ("\")'
        split_answer = answer.split(/\\/)
        split_answer.each do |ans|
          ancillary_service = AncillaryService.find_or_create_by(name: ans)
          AncillaryServicePractice.create ancillary_service: ancillary_service, practice: @practice unless AncillaryServicePractice.where(ancillary_service: ancillary_service, practice: @practice).any?
        end
      else
        ancillary_service = AncillaryService.find_or_create_by(name: answer)
        AncillaryServicePractice.create ancillary_service: ancillary_service, practice: @practice unless AncillaryServicePractice.where(ancillary_service: ancillary_service, practice: @practice).any?
      end
    end
  end
end

def clinical_locations
  puts "==> Importing Practice: #{@name} Clinical Locations".light_blue
  question_fields = {
      'Which of the following clinical locations does this practice impact? (Please select all that apply.)': 12
  }

  question_fields.each do |key, value|
    q_index = @questions.index(key.to_s)
    end_index = q_index + value - 1
    (q_index..end_index).each do |i|
      answer = @answers[i]
      next if answer.blank?

      if i == end_index && @given_answers[i] == 'Other (please specify) If more than one answer, please separate with a backslash ("\")'
        split_answer = answer.split(/\\/)
        split_answer.each do |ans|
          clinical_location = ClinicalLocation.find_or_create_by(name: ans)
          ClinicalLocationPractice.create clinical_location: clinical_location, practice: @practice unless ClinicalLocationPractice.where(clinical_location: clinical_location, practice: @practice).any?
        end
      else
        clinical_location = ClinicalLocation.find_or_create_by(name: answer)
        ClinicalLocationPractice.create clinical_location: clinical_location, practice: @practice unless ClinicalLocationPractice.where(clinical_location: clinical_location, practice: @practice).any?
      end
    end
  end
end

def departments
  puts "==> Importing Practice: #{@name} Departments".light_blue
  question_fields = {
      'Which departments or operational domains does this Practice impact?': 50,
  }

  question_fields.each do |key, value|
    q_index = @questions.index(key.to_s)
    end_index = q_index + value - 1
    (q_index..end_index).each do |i|
      answer = @answers[i]
      next if answer.blank?

      if i == end_index && @given_answers[i] == 'Other (please specify) If more than one answer, please separate with a backslash ("\")'
        split_answer = answer.split(/\\/)
        split_answer.each do |ans|
          department = Department.find_or_create_by(name: ans)
          DepartmentPractice.create department: department, practice: @practice unless DepartmentPractice.where(department: department, practice: @practice).any?
        end
      else
        department = Department.find_or_create_by(name: answer)
        DepartmentPractice.create department: department, practice: @practice unless DepartmentPractice.where(department: department, practice: @practice).any?
      end
    end
  end
end

def domains
  puts "==> Importing Practice: #{@name} Domains".light_blue
  question_fields = {
      'How does this practice deliver value? Please select all that apply of the five value delivery domains below:': 5,
  }

  question_fields.each do |key, value|
    q_index = @questions.index(key.to_s)
    end_index = q_index + value - 1
    (q_index..end_index).each do |i|
      answer = @answers[i]
      next if answer.blank?
      answer = answer.split('-')[0].squish
      department = Domain.find_by(name: answer)
      DomainPractice.create domain: department, practice: @practice unless DomainPractice.where(domain: department, practice: @practice).any?
    end
  end
end

def video_files
  puts "==> Importing Practice: #{@name} Video Files".light_blue
  question_fields = [
      'Do you have a short video that provides an explanation, summary, or testimonial about your practice? (Please paste YouTube url or other link)',
      'Enter title and description for video'
  ]

  # question_fields.each do |key, value|
  url_q_index = @questions.index(question_fields[0])

  url_answer = @answers[url_q_index]
  # next if answer.blank?
  return if url_answer.blank?

  title_and_description_q_index = @questions.index(question_fields[1].to_s)
  title_answer = @answers[title_and_description_q_index]
  description_answer = @answers[title_and_description_q_index + 1]

  VideoFile.create(practice: @practice, url: url_answer, title: title_answer, description: description_answer) unless VideoFile.where(url: url_answer, practice: @practice).any?
  # end
end

def additional_documents
  puts "==> Importing Practice: #{@name} Additional Documents".light_blue
  question_fields = {
      'Do you have survey results, verifiable testimonials, press releases, news articles regarding your practice that you would like to share?': :attachment,
      'Additional practice information 1': :attachment,
      'Additional practice information 2': :attachment,
  }
  question_fields.each do |key, value|
    next if @answers[@questions.index(key.to_s)].blank?
    image_path = "#{Rails.root}/tmp/surveymonkey_responses/#{@respondent_id}/#{@answers[@questions.index(key.to_s)]}"
    image_file = File.new(image_path)

    AdditionalDocument.create practice: @practice, attachment: ActionDispatch::Http::UploadedFile.new(
        filename: File.basename(image_file),
        tempfile: image_file,
        # detect the image's mime type with MIME if you can't provide it yourself.
        type: MIME::Types.type_for(image_path).first.content_type
    )
  end
end

# def business_case_files
#   puts "==> Importing Practice: #{@name} Business Case Files"
#   question_fields = {
#     'Does your practice have a formal business case?': :attachment
#   }
#   question_fields.each do |key, value|
#     next if @answers[@questions.index(key.to_s)].blank?
#     image_path = "#{Rails.root}/tmp/surveymonkey_responses/#{@respondent_id}/#{@answers[@questions.index(key.to_s)]}"
#     image_file = File.new(image_path)
#
#     BusinessCaseFile.create practice: @practice, attachment: ActionDispatch::Http::UploadedFile.new(
#                                                            filename: File.basename(image_file),
#                                                            tempfile: image_file,
#                                                            # detect the image's mime type with MIME if you can't provide it yourself.
#                                                            type: MIME::Types.type_for(image_path).first.content_type
#                                                            )
#   end
# end

def toolkit_files
  puts "==> Importing Practice: #{@name} Toolkit Files".light_blue
  question_fields = {
      'Does your practice have an implementation toolkit?': :attachment
  }
  question_fields.each do |key, value|
    next if @answers[@questions.index(key.to_s)].blank?
    image_path = "#{Rails.root}/tmp/surveymonkey_responses/#{@respondent_id}/#{@answers[@questions.index(key.to_s)]}"
    image_file = File.new(image_path)

    ToolkitFile.create practice: @practice, attachment: ActionDispatch::Http::UploadedFile.new(
        filename: File.basename(image_file),
        tempfile: image_file,
        # detect the image's mime type with MIME if you can't provide it yourself.
        type: MIME::Types.type_for(image_path).first.content_type
    )
  end
end

def checklist_files
  puts "==> Importing Practice: #{@name} Checklist Files".light_blue
  question_fields = {
      'Does your practice have a pre-implementation checklist?': :attachment
  }
  question_fields.each do |key, value|
    next if @answers[@questions.index(key.to_s)].blank?
    image_path = "#{Rails.root}/tmp/surveymonkey_responses/#{@respondent_id}/#{@answers[@questions.index(key.to_s)]}"
    image_file = File.new(image_path)

    ChecklistFile.create practice: @practice, attachment: ActionDispatch::Http::UploadedFile.new(
        filename: File.basename(image_file),
        tempfile: image_file,
        # detect the image's mime type with MIME if you can't provide it yourself.
        type: MIME::Types.type_for(image_path).first.content_type
    )
  end
end

def publication_files
  puts "==> Importing Practice: #{@name} Publication Files".light_blue
  question_fields = {
      'Does your practice have peer-reviewed publications associated with it?': :attachment,
      'Additional publication upload 1': :attachment
  }
  question_fields.each do |key, value|
    next if @answers[@questions.index(key.to_s)].blank?
    image_path = "#{Rails.root}/tmp/surveymonkey_responses/#{@respondent_id}/#{@answers[@questions.index(key.to_s)]}"
    image_file = File.new(image_path)

    PublicationFile.create practice: @practice, attachment: ActionDispatch::Http::UploadedFile.new(
        filename: File.basename(image_file),
        tempfile: image_file,
        # detect the image's mime type with MIME if you can't provide it yourself.
        type: MIME::Types.type_for(image_path).first.content_type
    )
  end
end

def publications
  puts "==> Importing Practice: #{@name} Publications".light_blue
  question_fields = {
      'Does your practice have peer-reviewed publications associated with it online? Enter url(s) if so.': 3
  }

  question_fields.each do |key, value|
    q_index = @questions.index(key.to_s)
    end_index = q_index + value - 1
    (q_index..end_index).each do |i|
      answer = @answers[i]
      next if answer.blank?

      if i == end_index && @given_answers[i] == 'Other (please specify) If more than one answer, please separate with a backslash ("\")'
        split_answer = answer.split(/\\/)
        split_answer.each do |ans|
          Publication.create(practice: @practice, link: answer) unless Publication.where(link: answer, practice: @practice).any?
        end
      else
        Publication.create(practice: @practice, link: answer) unless Publication.where(link: answer, practice: @practice).any?
      end
    end
  end
end

# def badges
#   puts "==> Importing Practice: #{@name} Badges"
#   question_fields = {
#   }

#   question_fields.each do |key, value|
#     q_index = @questions.index(key.to_s)
#     end_index = q_index + value - 1
#     (q_index..end_index).each do |i|
#       answer = @answers[i]
#       next if answer.blank?

#       if i == end_index && @given_answers[i] == 'Other (please specify) If more than one answer, please separate with a backslash ("\")'
#         split_answer = answer.split(/\\/)
#         split_answer.each do |ans|
#           badge = Badge.find_by(name: answer) || Badge.create(name: answer)
#           BadgePractice.create badge: badge, practice: @practice unless BadgePractice.where(badge: badge, practice: @practice).any?
#         end
#       else
#         badge = Badge.find_by(name: answer) || Badge.create(name: answer)
#         BadgePractice.create badge: badge, practice: @practice unless BadgePractice.where(badge: badge, practice: @practice).any?
#       end
#     end
#   end
# end

def implementation_timeline
  puts "==> Importing Practice: #{@name} Implementation Timeline".light_blue
  question_fields = {
      'Do you have an implementation timeline for your practice?': :attachment
  }
  question_fields.each do |key, value|
    next if @answers[@questions.index(key.to_s)].blank?
    image_path = "#{Rails.root}/tmp/surveymonkey_responses/#{@respondent_id}/#{@answers[@questions.index(key.to_s)]}"
    image_file = File.new(image_path)

    ImplementationTimelineFile.create practice: @practice, attachment: ActionDispatch::Http::UploadedFile.new(
        filename: File.basename(image_file),
        tempfile: image_file,
        # detect the image's mime type with MIME if you can't provide it yourself.
        type: MIME::Types.type_for(image_path).first.content_type
    )
  end
end

def risk_mitigations
  puts "==> Importing Practice: #{@name} Risks and Mitigations".light_blue
  question_fields = {
      'What is the primary risk to implementation? Please describe how you would mitigate it.': 2,
      'What is the second risk to implementation? Please describe how you would mitigate it.': 2,
      'What is the third risk to implementation? Please describe how you would mitigate it.': 2,
  }
  question_fields.each do |key, value|
    q_index = @questions.index(key.to_s)
    next if @answers[q_index].blank?

    rm = RiskMitigation.create practice: @practice


    split_risk_answer = @answers[q_index].split(/\\/)

    split_risk_answer.each do |a|
      risk = Risk.create risk_mitigation: rm, description: a
    end

    split_mitigation_answer = @answers[q_index + 1].split(/\\/)

    split_mitigation_answer.each do |a|
      mitigation = Mitigation.create risk_mitigation: rm, description: a
    end
  end
end

def additional_staff
  puts "==> Importing Practice: #{@name} Additional Staff".light_blue
  question_fields = [
      {'What job titles are required to implement this Practice?': 5},
      {'For the job titles listed, how many hours are required per week?': 5},
      {'For the job titles listed, what is the duration of the job? Please indicate the number of weeks or type in "Permanent"': 5}
  ]

  (0..4).each do |i|
    title = @answers[@questions.index(question_fields[0].keys[0].to_s) + i]
    hours_per_week = @answers[@questions.index(question_fields[1].keys[0].to_s) + i]
    duration_in_weeks = @answers[@questions.index(question_fields[2].keys[0].to_s) + i]
    next if title.blank?

    AdditionalStaff.create(practice: @practice, title: title, hours_per_week: hours_per_week, duration_in_weeks: duration_in_weeks) unless AdditionalStaff.where(title: title, hours_per_week: hours_per_week, duration_in_weeks: duration_in_weeks, practice: @practice).any?
  end
end

def additional_resources
  puts "==> Importing Practice: #{@name} Additional Resources".light_blue
  question_fields = {
      'What other resources and supplies are needed for this Practice?': 5
  }

  question_fields.each do |key, value|
    q_index = @questions.index(key.to_s)

    answer = @answers[q_index]
    next if answer.blank?

    AdditionalResource.create(practice: @practice, description: answer) unless AdditionalResource.where(description: answer, practice: @practice).any?
  end
end

def required_training_staff
  puts "==> Importing Practice: #{@name} Required Training Staff".light_blue
  question_fields = {
      'Who is required to take the training?': 5
  }

  question_fields.each do |key, value|
    q_index = @questions.index(key.to_s)

    answer = @answers[q_index]
    next if answer.blank?

    RequiredStaffTraining.create(practice: @practice, title: answer) unless RequiredStaffTraining.where(title: answer, practice: @practice).any?
  end
end

def costs_difficulties
  puts "==> Importing Practice: #{@name} Costs and Difficulties".light_blue
  question_fields = {
      'List other Costs of Implementation that are unique to your Practice.': 6
  }
  question_fields.each do |key, value|
    q_index = @questions.index(key.to_s)
    end_index = q_index + 2

    (q_index..end_index).each do |i|
      next if @answers[i].blank?

      if i == end_index && @given_answers[i] == 'Other (please specify) If more than one answer, please separate with a backslash ("\")'
        split_answer = answer.split(/\\/)
        split_answer.each do |ans|
          Cost.create practice: @practice, description: @answers[i] unless Cost.where(description: @answers[i], practice: @practice).any?
          Difficulty.create practice: @practice, description: @answers[i + 3] unless Difficulty.where(description: @answers[i + 3], practice: @practice).any?
        end
      else
        Cost.create practice: @practice, description: @answers[i] unless Cost.where(description: @answers[i], practice: @practice).any?
        Difficulty.create practice: @practice, description: @answers[i + 3] unless Difficulty.where(description: @answers[i + 3], practice: @practice).any?
      end
    end
  end
end

def impact_photos
  puts "==> Importing Practice: #{@name} Human Impact Photos".light_blue
  question_fields = [[
                         'Impact Photo 1',
                         'Please provide a title for Impact Picture 1',
                         'Please provide a brief paragraph describing the photo and the Impact.'
                     ], [
                         'Impact Photo 2',
                         'Please provide a title for Impact Picture 2',
                         'Please provide a brief paragraph describing the photo and the Impact.'
                     ], [
                         'Impact Photo 3',
                         'Please provide a title for Impact Picture 3',
                         'Please provide a brief paragraph describing the photo and the Impact.'
                     ]]
  question_fields.each_with_index do |fields, index|
    description_indices = @questions.each_index.select {|i| @questions[i] == fields[2]}
    next if @answers[@questions.index(fields[0])].blank?

    image_path = "#{Rails.root}/tmp/surveymonkey_responses/#{@respondent_id}/#{@answers[@questions.index(fields[0])]}"
    image_file = File.new(image_path)
    title = @answers[@questions.index(fields[1])]
    description = @answers[description_indices[index]]

    ImpactPhoto.create(practice: @practice, title: title, description: description, attachment: ActionDispatch::Http::UploadedFile.new(
        filename: File.basename(image_file),
        tempfile: image_file,
        # detect the image's mime type with MIME if you can't provide it yourself.
        type: MIME::Types.type_for(image_path).first.content_type
    ))
  end
end

def file_uploads
  puts "==> Importing Practice: #{@name} File Uploads".light_blue
  question_fields = {
      "Please provide a photo of the individual who initiated the practice. (This will be displayed under \"Origin of the practice\")": :origin_picture,
      'Upload a Display Image for your practice. This image will be used for the main title page and marketplace tile.': :main_display_image
  }
  question_fields.each do |key, value|
    next if @answers[@questions.index(key.to_s)].blank?

    next if @answers[@questions.index(key.to_s)].include?('.pdf')
    image_path = "#{Rails.root}/tmp/surveymonkey_responses/#{@respondent_id}/#{@answers[@questions.index(key.to_s)]}"
    image_file = File.new(image_path)

    @practice.send("#{value.to_sym}=", ActionDispatch::Http::UploadedFile.new(
        filename: File.basename(image_file),
        tempfile: image_file,
        # detect the image's mime type with MIME if you can't provide it yourself.
        type: MIME::Types.type_for(image_path).first.content_type
    ))
  end
end

def practice_permissions
  puts "==> Importing Practice: #{@name} Practice Permissions".light_blue
  question_fields = {
      "Are any permissions required for this practice? (e.g. \"Letters of Understanding,\" \"Proof of Funding,\" \"Written Permission from Department Heads,\" etc). Please list.": 4
  }

  question_fields.each do |key, value|
    q_index = @questions.index(key.to_s)
    end_index = q_index + value

    (q_index..end_index).each do |i|
      next if @answers[i].blank?
      PracticePermission.find_or_create_by!(description: @answers[i], practice: @practice)
    end
  end
end

def training_details
  puts "==> Importing Practice: #{@name} Training Details".light_blue
  question_fields = {
      "Training details:": 3
  }

  question_fields.each do |key, value|
    q_index = @questions.index(key.to_s)

    @practice.training_length = @answers[q_index]
    @practice.required_training_summary = @answers[q_index + 1]
    @practice.training_test_details = @answers[q_index + 2]
    training_test = @answers[q_index + 2]
    next if training_test.blank?
    @practice.training_test = training_test.downcase == 'yes' ? true : false
  end
  @practice.save
end

def license_required
  puts "==> Importing Practice: #{@name} License Details".light_blue
  question_fields = {
      'Will a new license or certification be required?': 1
  }
  question_fields.each do |key, value|
    next if @answers[@questions.index(key.to_s)].blank?

    answer = @answers[@questions.index(key.to_s)]

    @practice.need_new_license = true if answer.downcase == 'yes'
    @practice.need_new_license = false if answer.downcase == 'no'
    @practice.save
  end
end

def it_required
  puts "==> Importing Practice: #{@name} IT Required".light_blue
  question_fields = {
      "Is Information Technology (IT) required to implement the practice?": 1
  }

  question_fields.each do |key, value|
    next if @answers[@questions.index(key.to_s)].blank?

    answer = @answers[@questions.index(key.to_s)]

    @practice.it_required = true if answer.downcase == 'yes'
    @practice.it_required = false if answer.downcase == 'no'
    @practice.save
  end
end

def timelines
  puts "==> Importing Practice: #{@name} Timelines".light_blue
  question_fields = {
      "During the time you just listed, what are 3 to 7 milestones that should be met during implementation? Please list with the corresponding time frame.": 14
  }

  question_fields.each do |key, value|
    q_index = @questions.index(key.to_s)
    end_index = q_index + 13

    (q_index..end_index).step(2) do |i|
      next if @answers[i].blank?
      Timeline.find_or_create_by!(milestone: @answers[i], timeline: @answers[i + 1], practice: @practice)
    end
  end

end

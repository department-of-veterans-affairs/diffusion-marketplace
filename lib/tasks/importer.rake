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

    sheet = Roo::Excelx.new(File.join(Rails.root, '/lib/assets/TEST_Diffusion_Marketplace.xlsx'))
    unless Rails.env.test?
      download_response_files
      puts "*********** Importing practices from: #{options[:file]} ***********".light_blue if options[:file].present?
      puts "!!!!!! No file path provided !!!!!!".yellow if options[:file].blank?
      puts "*********** Importing practices from: /lib/assets/Diffusion_Marketplace.xlsx ***********".light_blue if options[:file].blank?
      import_file_path = options[:file].present? ? options[:file] : File.join(Rails.root, '/lib/assets/Diffusion_Marketplace.xlsx')

      sheet = Roo::Excelx.new(import_file_path)
    end
    @questions = sheet.sheet(0).row(1)
    @given_answers = sheet.sheet(0).row(2)
    last_row = sheet.last_row

    @user = User.create!(email: 'marketplace@va.gov', password: 'Password123', password_confirmation: 'Password123', confirmed_at: Time.now)

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
        unless practice.user.present?
          practice.user = @user
        end
        puts "This practice already exists in the system.".white.on_blue
        # puts "Would you like to destroy and re-import this practice?. [Y/N]".white.on_blue
        # answer = STDIN.gets.chomp
        # case answer.downcase
        #   when 'y'
        #     destroy_practice
        #   when 'yes'
        #     destroy_practice
        #   when 'n'
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
        # when 'yes'
        #   puts "Updating/re-importing practice: #{@name}".light_blue
        # when 'n'
        #   puts "Updating/re-importing practice: #{@name}".light_blue
        # else
        #   puts "Skipping practice #{@name} entirely!".yellow
        #   next
        # end
      else
        @practice = Practice.create(name: @name, user: @user)
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
      categories
      clinical_conditions
      ancillary_services
      departments
      practice_multimedia_images
      practice_multimedia_video_files
      additional_documents
      publications
      implementation_timeline
      risk_mitigations
      additional_resources
      domains
      timelines
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
      "Please supply an email address for this practice's support network in order to direct interested parties. (e.g. HAPPEN@va.gov)": :support_network_email,
      "On the Practice page, we often use a descriptive tagline as the functional title. For example: the FLOW3 Practice is not well described by the title, and we therefore use the tagline: \"Delivery of prosthetic limbs to Veterans in less than ½ the time\".Please provide a 5-10 word descriptive tagline for your Practice. This will be used as the functional title.": :tagline,
      "On the Practice page, under the tagline/functional title you just provided, we would like a longer descriptive tagline to further explain your practice. For example, for FLOW3: \"Enable 53% faster delivery of prosthetic limbs to Veterans. Automating the prosthetic limb procurement process to improve continuity of care for Veterans.\"Please provide a 1-2 line descriptive tagline for your Practice. This will be used below the functional title.": :description,
      'Please provide a 50-100 word descriptive paragraph for your Practice. ': :summary,
      'Is this practice a New Clinical Approach or New Process? Or is this practice a process change of something already being done? (Choose one of the following.)': :process,
      'Please enter a 10-20 word title for the origin story of this Practice': :origin_title,
      'Please provide a 50 - 100 word paragraph sharing the story of the origin of this practice': :origin_story,
      'Number of facilities that have successfully implemented the Practice (Please enter a whole number):': :number_adopted,
      'Number of Departments required to implement the practice?': :number_departments,
      'Number of facilities that have attempted to implement the Practice and have NOT been successful (Please enter a whole number):': :number_failed,
  }
  question_fields.each do |key, value|
    @practice.send("#{value.to_sym}=", @answers[@questions.index(key.to_s)]) if value.present?
  end
  @practice.initiating_facility = @practice.initiating_facility&.split('_')[1]
  @practice.date_initiated = DateTime.strptime(@answers[@questions.index('When was this practice initiated? If day is unknown, use the first of the month'.to_s)], "%m/%d/%Y") if @answers[@questions.index('When was this practice initiated? If day is unknown, use the first of the month'.to_s)].present?
  @practice.save
end

def practice_partners
  puts "==> Importing Practice: #{@name} Practice Partners".light_blue
  @practice.practice_partner_practices.each(&:destroy)
  question_fields = {
      'Which of the following statements regarding Partners apply to this Practice? (Mark all that apply)': 13
  }
  question_fields.each do |key, value|
    q_index = @questions.index(key.to_s)
    end_index = q_index + value - 1
    (q_index..end_index).each do |i|
      pp_name = @answers[i]
      next if pp_name.blank?

      # if i == end_index && @given_answers[i] == 'Other (please specify) If more than one answer, please separate with a backslash ("\")'
      #   split_answer = pp_name.split(/\\/)
      #   split_answer.each do |ans|
      #     formatted_ans = ans.split(':')[0].squish
      #     practice_partner = PracticePartner.find_by(name: formatted_ans)
      #     practice_partner = PracticePartner.find_or_create_by(name: formatted_ans, icon: 'fas fa-circle', color: '#36383f') if practice_partner.nil?
      #     PracticePartnerPractice.create practice_partner: practice_partner, practice: @practice unless PracticePartnerPractice.where(practice_partner: practice_partner, practice: @practice).any?
      #   end
      # else
      formatted_pp_name = pp_name.split(':')[0].squish
      practice_partner = PracticePartner.find_by(name: formatted_pp_name)
      # practice_partner = PracticePartner.create!(name: formatted_pp_name, icon: 'fas fa-circle', color: '#36383f') if practice_partner.nil?

      PracticePartnerPractice.create practice_partner: practice_partner, innovable: @practice unless PracticePartnerPractice.where(practice_partner: practice_partner, innovable: @practice).any? || practice_partner.blank?
      # end
    end
  end
end

def va_employees
  puts "==> Importing Practice: #{@name} Support Team".light_blue
  @practice.va_employee_practices.each(&:destroy)
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
      va_employee = VaEmployee.find_or_create_by(name: vae_name, role: vae_role)
      VaEmployeePractice.create va_employee: va_employee, innovable: @practice unless VaEmployeePractice.where(va_employee: va_employee, innovable: @practice).any?
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

def categories
  puts "==> Importing Practice: #{@name} Categories".light_blue
  @practice.category_practices.each(&:destroy)
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
          CategoryPractice.create category: category, innovable: @practice unless CategoryPractice.where(category: category, innovable: @practice).any?
        end
      else
        category = Category.find_or_create_by(name: answer)
        CategoryPractice.create category: category, innovable: @practice unless CategoryPractice.where(category: category, innovable: @practice).any?
      end
    end
  end
end

def clinical_conditions
  puts "==> Importing Practice: #{@name} Clinical Conditions".light_blue
  @practice.clinical_condition_practices.each(&:destroy)
  question_fields_1 = {
      'This question will allow the user to find your Practice by a medical complaint, clinical condition, or system of the body.   We are going to divide complaints, conditions, and systems anatomically.': 36
  }

  question_fields_1.each do |key, value|
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
        next if condition.name == 'None'
        ClinicalConditionPractice.create clinical_condition: condition, practice: @practice unless ClinicalConditionPractice.where(clinical_condition: condition, practice: @practice).any?
      end
    end
  end

  question_fields_2 = {
      'Please enter one condition per line': 5
  }

  question_fields_2.each do |key, value|
    q_index = @questions.index(key.to_s)
    end_index = q_index + value - 1
    (q_index..end_index).each do |i|
      answer = @answers[i]
      next if answer.blank?
      condition = ClinicalCondition.find_or_create_by(name: answer)
      ClinicalConditionPractice.create clinical_condition: condition, practice: @practice unless ClinicalConditionPractice.where(clinical_condition: condition, practice: @practice).any?

    end
  end

end

def ancillary_services
  puts "==> Importing Practice: #{@name} Ancillary Services".light_blue
  @practice.ancillary_service_practices.each(&:destroy)
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

def departments
  puts "==> Importing Practice: #{@name} Departments".light_blue
  @practice.department_practices.each(&:destroy)
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
  @practice.domain_practices.each(&:destroy)
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

def practice_multimedia_images
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
    description_indices = @questions.each_index.select { |i| @questions[i] == fields[2] }
    next if @answers[@questions.index(fields[0])].blank?

    image_path = "#{Rails.root}/tmp/surveymonkey_responses/#{@respondent_id}/#{@answers[@questions.index(fields[0])]}"
    image_file = File.new(image_path)
    title = @answers[@questions.index(fields[1])]
    description = @answers[description_indices[index]]

    prac_multimedium = PracticeMultimedium.new(
      innovable: @practice,
      resource_type: "image",
      name: description
    )

    if image_file.present? && File.exist?(image_file.path)
      prac_multimedium.attachment = image_file
    end

    if prac_multimedium.save
      puts "==> Importing Practice: #{@name} Human Practice Multimedia Image".light_blue
    else
      puts "==> Failed Importing Practice: #{@name} Human Practice Multimedia Image".yellow
    end
  end
end

def practice_multimedia_video_files
  puts "==> Importing Practice: #{@name} Video Files".light_blue
  question_fields = [
      'Do you have a short video that provides an explanation, summary, or testimonial about your practice? (Please paste YouTube url or other link)',
      'Enter title and description for video'
  ]

  url_q_index = @questions.index(question_fields[0])
  url_answer = @answers[url_q_index]
  return if url_answer.blank?

  title_and_description_q_index = @questions.index(question_fields[1].to_s)
  title_answer = @answers[title_and_description_q_index]
  description_answer = @answers[title_and_description_q_index + 1]

  prac_multimedium = PracticeMultimedium.new(innovable: @practice, resource_type: "video", name: description_answer, link_url: url_answer)
  if prac_multimedium.save
      puts "==> Importing  PracticeMultimedia Video for: #{@practice.id} - #{@practice.name}".light_blue
  else
    puts "Could not create PracticeMultimedia Video for: #{@practice.id} - #{@practice.name}".yellow
    puts "#{prac_multimedium.errors}"
  end
end

def additional_documents
  puts "==> Importing Practice: #{@name} Additional Documents".light_blue
  @practice.additional_documents.each(&:destroy)
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

def publications
  puts "==> Importing Practice: #{@name} Publications".light_blue
  @practice.publications.each(&:destroy)
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

def implementation_timeline
  puts "==> Importing Practice: #{@name} Implementation Timeline".light_blue
  @practice.implementation_timeline_files.each(&:destroy)
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
  @practice.risk_mitigations.each(&:destroy)
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

    if @answers[q_index + 1].present?
      split_mitigation_answer = @answers[q_index + 1].split(/\\/)

      split_mitigation_answer.each do |a|
        mitigation = Mitigation.create risk_mitigation: rm, description: a
      end
    end
  end
end

def additional_resources
  puts "==> Importing Practice: #{@name} Additional Resources".light_blue
  @practice.additional_resources.each(&:destroy)
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

def timelines
  puts "==> Importing Practice: #{@name} Timelines".light_blue
  @practice.timelines.each(&:destroy)
  question_fields = {
      "During the time you just listed, what are 3 to 7 milestones that should be met during implementation? Please list with the corresponding time frame. (Note: your answers to this question will build a timeline--a key portion of the practice page for your practice.)": 14
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

def signer
  Aws.config.update({
                        region: ENV['AWS_REGION'],
                        credentials: Aws::Credentials.new(ENV['S3_TEST_MARKETPLACE_ACCESS_KEY_ID'], ENV['S3_TEST_MARKETPLACE_SECRET_ACCESS_KEY'])
                    })
  @signer ||= Aws::S3::Presigner.new
end

def s3_presigned_url
  signer.presigned_url(:get_object, bucket: ENV['S3_TEST_BUCKET_NAME'] || 'test-diffusion-marketplace', key: 'surveymonkey_responses.zip')
end

def download_survey_monkey_responses_zip
  open("#{Rails.root}/tmp/surveymonkey_responses.zip", 'wb') do |file|
    file << open(s3_presigned_url).read
  end
end

def unzip_response_files
  Zip::File.open("#{Rails.root}/tmp/surveymonkey_responses.zip") do |zip_files|
    zip_files.each do |file|
      fpath = File.join("#{Rails.root}/tmp", file.name)
      file.extract(fpath)
    end
  end
end

# You can also manually put these in the tmp directory and skip this part when prompted
def download_response_files
  # save response files from S3 to the tmp directory
  # 1. download from S3
  if File.exist?("#{Rails.root}/tmp/surveymonkey_responses.zip")
    puts "The survey_monkey_responses.zip file has already been downloaded.".light_blue
    puts "Would you like to download again?. [Y/N]".white.on_blue
    ans = STDIN.gets.chomp
    case ans.downcase
    when 'y'
      puts "==> Downloading response files".light_blue
      download_survey_monkey_responses_zip
    when 'yes'
      puts "==> Downloading response files".light_blue
      download_survey_monkey_responses_zip
    when 'n'
      puts "Skipping Downloading response files".yellow
    when 'no'
      puts "Skipping Downloading response files".yellow
    else
      puts "Skipping Downloading response files".yellow
    end
  else
    puts "==> Downloading response files".light_blue
    download_survey_monkey_responses_zip
  end

  # 2. unzip file from s3
  puts "==> Unzipping response files".light_blue
  if File.exist?("#{Rails.root}/tmp/surveymonkey_responses.zip")
    if File.exist?("#{Rails.root}/tmp/surveymonkey_responses")
      puts "The survey_monkey_responses.zip file has already been unzipped.".light_blue
      puts "Would you like to extract it again?. [Y/N]".white.on_blue
      ans = STDIN.gets.chomp
      case ans.downcase
      when 'y'
        FileUtils.rm_rf("#{Rails.root}/tmp/surveymonkey_responses")
        puts "==> Unzipping response files".light_blue
        unzip_response_files
      when 'yes'
        FileUtils.rm_rf("#{Rails.root}/tmp/surveymonkey_responses")
        puts "==> Unzipping response files".light_blue
        unzip_response_files
      when 'n'
        puts "Skipping Unzipping response files".yellow
      when 'no'
        puts "Skipping Unzipping response files".yellow
      else
        puts "Skipping Unzipping response files".yellow
      end
    else
      puts "==> Unzipping response files".light_blue
      unzip_response_files
    end
  else
    # stop execution of this whole thing. the importer will fail~
    raise ResponseFilesMissingError, 'The response files are missing. Please make sure you have the correct credentials to download them or download them from a different source and place them in the tmp folder and re-run this task. Thanks!'
  end

  if ENV['AWS_ACCESS_KEY_ID'] != ENV['S3_TEST_MARKETPLACE_ACCESS_KEY_ID']
    Aws.config.update({
                          region: ENV['AWS_REGION'],
                          credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
                      })
  end
end

# define custom error class
class ResponseFilesMissingError < StandardError;
end

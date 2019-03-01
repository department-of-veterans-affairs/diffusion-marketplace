# A task setup for importing survery monkey questionairre answers
namespace :importer do
  desc 'import an xlsx and create practices'
  task import_answers: :environment do
    sheet = Roo::Excelx.new('./public/Diffusion Marketplace.xlsx')
    @questions = sheet.sheet(0).row(1)
    last_row = sheet.last_row

    (3..last_row).each do |row_num|
      @answers = sheet.sheet(0).row(row_num)
      @respondent_id = @answers[0]

      @name = @answers[@questions.index('What is the name of your practice?')]

      if @name.blank?
        puts "==> Aborting importing Respondent #{@respondent_id}'s answers - no name for the practice supplied."
        next
      end

      puts "==> Importing Respondent: #{@respondent_id}"
      puts "==> Importing Practice: #{@name}"
      @practice = Practice.find_by_name(@name) || Practice.create(name: @name)

      # Basic Practice related questions first
      basic_answers
      file_uploads
      # TODO: Ask Andy if this needs to be dynamic
      @practice.approved = true
      @practice.published = true
      @practice.save!

      # sort all of the relational questions into their own methods for clarity.
      strategic_sponsors
      va_employees
      developing_facility_types
      va_secretary_priorities
      practice_managements
      impact
      clinical_conditions
      financial_files
      job_positions
      ancillary_services
      clinical_locations
      departments
      video_files
      additional_documents
      business_case_files
      toolkit_files
      checklist_files
      publication_files
      publications
      badges
      implementation_timeline
      risk_mitigations
      additional_staff
      additional_resources
      required_training_staff
      costs_difficulties
      human_impact_photos
    end
  end
end

def basic_answers
  puts "==> Importing Practice: #{@name} basic answers"
  question_fields = {
    'When was this practice initiated?': :date_initiated,
    # The below question's text needs to be changed when a new sheet can be provided.
    'Please list the name of the facility that initiated this Practice (Medical Center, CBOC, or other facility. Type in "None" if appropriate).': :initiating_facility,
    'Please enter an estimate in dollars of the cost avoidance per facility (Medical Center, CBOC, or applicable institution).': :impact_financial_estimate_saved,
    'Please enter an estimate in dollars of the cost avoidance per veteran.': :impact_financial_per_veteran,
    'Please enter relevant financial data regarding this practice such as ROI, a business case summary, or other financial analysis.': :impact_financial_roi,
    "Please supply an email address for this practice's support network in order to direct interested parties. (e.g. HAPPEN@va.gov)": :support_network_email,
    "Please identify where your practice falls currently in VHA’s Phase Gate Model of Innovation. (Add a 10 word definition of each stage.)": :phase_gate,
    'What objective measure do you use to define a successful implementation? (For example 10 patients complete the clinical protocol.)': :successful_implementation,
    'What target measure(s) do you use to show success?': :target_measures,
    'How many did it take to be considered a successful "launch"?': :target_success,
    "Do you have a link to your practice's VA Pulse Group?": :va_pulse_link,
    'How long does it usually take a group to implement your practice? How long do you expect it to take?': :implementation_time_estimate,
    'Do you have anything else you would like to share regarding your practice?': :additional_notes,
    'On the Practice page, we often use a descriptive tagline as the functional title. For example: the FLOW3 Practice is not well described by the title, and we therefor use the tagline: "Delivery of prosthetic limbs to Veterans in less than ½ the time".Please provide a 5-10 word descriptive tagline for your Practice. This will be used as the functional title.': :tagline,
    'On the Practice page, under the tagline/functional title you just provided, we would like a longer descriptive tagline to further explain your practice. For example, for FLOW3: "Enable 53% faster delivery of prosthetic limbs to Veterans. Automating the prosthetic limb procurement process to improve continuity of care for Veterans."Please provide a 1-2 line descriptive tagline for your Practice. This will be used below the functional title.': :description,
    'Please provide a 50-100 word descriptive paragraph for your Practice. ': :summary,
    'Eventually, your Practice will be rated on Cost Avoidance, Human Impact, and Implementation Difficulty based on feedback from individuals who implement your Practice.For now, please provide your best estimate rating of your Practice with regards to Cost Avoidance on a scale of 1 - 4.': :cost_savings_aggregate,
    'Please provide your best estimate rating of your Practice with regards to Human Impact on health/care experience on a scale of 1 - 4.': :veteran_satisfaction_aggregate,
    'Based on the risks and mitigations you provided, how would you rate your Practice overall with regards to risk level?': :risk_level_aggregate,
    'Under the side navigation "Resources Required" tab, the "Cost of Resources to Implement" rating will eventually be provided by individuals who have implemented this practice.For now, please provide your best estimate of the Cost of Resources to Implement your Practice on a scale of 1 - 4': :cost_to_implement_aggregate,
    'Under the side navigation "Resources Required" tab, the "Difficulty of Implementation" rating will eventually be provided by individuals who have implemented this practice.For now, please provide your best estimate of the Difficulty of Implementation your Practice on a scale of 1 - 4': :difficulty_aggregate,
    'Will additional staff be required to implement or sustain this practice?': :need_additional_staff,
    'Is there training required?': :need_training,
    'If there is training, please list who provides the training.': :training_provider,
    'How long is the training? What is required (such as 5 20 minute videos and then take a quiz vs. attend 2 meetings)? Is there a test involved?': :required_training_summary,
    'Will a policy change be required?': :need_policy_change,
    'Will a new license or certification be required?': :need_new_license,
    'Please enter a 10-20 word title for the origin story of this Practice': :origin_title,
    'Please provide a 50 - 100 word paragraph sharing the story of the origin of this practice': :origin_story
  }
  question_fields.each do |key, value|
    # debugger if value.to_sym == :cost_savings_aggregate
    @practice.send("#{value.to_sym}=", @answers[@questions.index(key.to_s)])
  end
end

def strategic_sponsors
  puts "==> Importing Practice: #{@name} Strategic Sponsors"
  question_fields = {
    'Who are the Practice Partners responsible for this practice? (Please select all that apply.)': 10,
    'This practice was developed in which VISN? (Please select all that apply.)': 19
  }
  question_fields.each do |key, value|
    q_index = @questions.index(key.to_s)
    end_index = q_index + value - 1
    (q_index..end_index).each do |i|
      sp_name = @answers[i]
      next if sp_name.blank?

      strategic_sponsor = StrategicSponsor.find_by(name: sp_name) || StrategicSponsor.create(name: sp_name)
      StrategicSponsorPractice.create strategic_sponsor: strategic_sponsor, practice: @practice unless StrategicSponsorPractice.where(strategic_sponsor: strategic_sponsor, practice: @practice).any?
    end
  end
end

def va_employees
  puts "==> Importing Practice: #{@name} Support Team"
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

      vae = vae.split(/\\|\//)
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
        va_employee = VaEmployee.find_by(name: vae_name, role: vae_role) || VaEmployee.create(name: vae_name, role: vae_role)
      end
      VaEmployeePractice.create va_employee: va_employee, practice: @practice unless VaEmployeePractice.where(va_employee: va_employee, practice: @practice).any?
    end
  end
end

def developing_facility_types
  puts "==> Importing Practice: #{@name} Developing Facility Types"
  question_fields = {
    "Where was this practice initially developed? (Please select all that apply.)": 6
  }

  question_fields.each do |key, value|
    q_index = @questions.index(key.to_s)
    end_index = q_index + value - 1
    (q_index..end_index).each do |i|
      answer = @answers[i]
      next if answer.blank?

      developing_facility = DevelopingFacilityType.find_by(name: answer) || DevelopingFacilityType.create(name: answer)
      DevelopingFacilityTypePractice.create developing_facility_type: developing_facility, practice: @practice unless DevelopingFacilityTypePractice.where(developing_facility_type: developing_facility, practice: @practice).any?
    end
  end
end

def va_secretary_priorities
  puts "==> Importing Practice: #{@name} VA Secretary Priorities"
  question_fields = {
    "Which of the VA Secretary’s Priorities does this practice Address? (Please select all that apply.)": 7
  }

  question_fields.each do |key, value|
    q_index = @questions.index(key.to_s)
    end_index = q_index + value - 1
    (q_index..end_index).each do |i|
      answer = @answers[i]
      next if answer.blank?

      secretary_priority = VaSecretaryPriority.find_by(name: answer) || VaSecretaryPriority.create(name: answer)
      VaSecretaryPriorityPractice.create va_secretary_priority: secretary_priority, practice: @practice unless VaSecretaryPriorityPractice.where(va_secretary_priority: secretary_priority, practice: @practice).any?
    end
  end
end

def practice_managements
  puts "==> Importing Practice: #{@name} Practice Managements"
  question_fields = {
    "Which of the following areas does this practice affect? (Please select all that apply.)": 13
  }

  question_fields.each do |key, value|
    q_index = @questions.index(key.to_s)
    end_index = q_index + value - 1
    (q_index..end_index).each do |i|
      answer = @answers[i]
      next if answer.blank?

      practice_management = PracticeManagement.find_by(name: answer) || PracticeManagement.create(name: answer)
      PracticeManagementPractice.create practice_management: practice_management, practice: @practice unless PracticeManagementPractice.where(practice_management: practice_management, practice: @practice).any?
    end
  end
end

def impact
  puts "==> Importing Practice: #{@name} Impacts"
  question_fields = {
    'What are the impacts of this practice clinically? Please select all clinical domains this practice impacts.': 26,
    'Additional clinical impacts of this practice? (Please select all that apply.)': 6,
    'Which of the following operational domains does the practice impact? (Please select all that apply.)': 18,
  }

  question_fields.each do |key, value|
    q_index = @questions.index(key.to_s)
    end_index = q_index + value - 1
    (q_index..end_index).each do |i|
      answer = @answers[i]
      next if answer.blank?

      impact = Impact.find_by(name: answer) || Impact.create(name: answer)
      ImpactPractice.create impact: impact, practice: @practice unless ImpactPractice.where( impact: impact, practice: @practice).any?
    end
  end
end

def clinical_conditions
  puts "==> Importing Practice: #{@name} Clinical Conditions"
  question_fields = {
    'Which of the following clinical conditions does this practice affect? (Please select all that apply.)': 16
  }

  question_fields.each do |key, value|
    q_index = @questions.index(key.to_s)
    end_index = q_index + value - 1
    (q_index..end_index).each do |i|
      answer = @answers[i]
      next if answer.blank?

      condition = ClinicalCondition.find_by(name: answer) || ClinicalCondition.create(name: answer)
      ClinicalConditionPractice.create clinical_condition: condition, practice: @practice unless ClinicalConditionPractice.where(clinical_condition: condition, practice: @practice).any?
    end
  end
end

def financial_files
  puts "==> Importing Practice: #{@name} Financial Files"
  question_fields = {
    "Please upload applicable financial information.": 1
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
  puts "==> Importing Practice: #{@name} Job Positions"
  question_fields = {
    "Which of the following job titles or positions does this practice impact? (Please select all that apply.)": 10
  }

  question_fields.each do |key, value|
    q_index = @questions.index(key.to_s)
    end_index = q_index + value - 1
    (q_index..end_index).each do |i|
      answer = @answers[i]
      next if answer.blank?

      job_position = JobPosition.find_by(name: answer) || JobPosition.create(name: answer)
      JobPositionPractice.create job_position: job_position, practice: @practice unless JobPositionPractice.where(job_position: job_position, practice: @practice).any?
    end
  end
end

def ancillary_services
  puts "==> Importing Practice: #{@name} Ancillary Services"
  question_fields = {
    'Which of the following ancillary services does this practice impact? (Please select all that apply.)': 11
  }

  question_fields.each do |key, value|
    q_index = @questions.index(key.to_s)
    end_index = q_index + value - 1
    (q_index..end_index).each do |i|
      answer = @answers[i]
      next if answer.blank?

      ancillary_service = AncillaryService.find_by(name: answer) || AncillaryService.create(name: answer)
      AncillaryServicePractice.create ancillary_service: ancillary_service, practice: @practice unless AncillaryServicePractice.where(ancillary_service: ancillary_service, practice: @practice).any?
    end
  end
end

def clinical_locations
  puts "==> Importing Practice: #{@name} Clinical Locations"
  question_fields = {
    'Which of the following clinical locations does this practice impact? (Please select all that apply.)': 12
  }

  question_fields.each do |key, value|
    q_index = @questions.index(key.to_s)
    end_index = q_index + value - 1
    (q_index..end_index).each do |i|
      answer = @answers[i]
      next if answer.blank?

      clinical_location = ClinicalLocation.find_by(name: answer) || ClinicalLocation.create(name: answer)
      ClinicalLocationPractice.create clinical_location: clinical_location, practice: @practice unless ClinicalLocationPractice.where(clinical_location: clinical_location, practice: @practice).any?
    end
  end
end

def departments
  puts "==> Importing Practice: #{@name} Departments"
  question_fields = {
    'Which department does this primarily impact?': 2,
    'Which other department(s) does this impact? Please mark all departments that will need to have buy-in or will need to participate in implementation.': 35
  }

  question_fields.each do |key, value|
    q_index = @questions.index(key.to_s)
    end_index = q_index + value - 1
    (q_index..end_index).each do |i|
      answer = @answers[i]
      next if answer.blank?

      department = Department.find_by(name: answer) || Department.create(name: answer)
      DepartmentPractice.create department: department, practice: @practice unless DepartmentPractice.where(department: department, practice: @practice).any?
    end
  end
end

def video_files
  puts "==> Importing Practice: #{@name} Video Files"
  question_fields = {
    'Do you have a short video that provides an explanation, summary, or testimonial about your practice? (Please paste YouTube url or other link)': :url,
    'Additional Video 1 (Please paste YouTube url or other link)': :url,
    'Additional Video 2 (Please paste YouTube url or other link)': :url
  }

  question_fields.each do |key, value|
    q_index = @questions.index(key.to_s)

    answer = @answers[q_index]
    next if answer.blank?

    VideoFile.create(practice: @practice, url: answer) unless VideoFile.where(url: answer, practice: @practice).any?
  end
end

def additional_documents
  puts "==> Importing Practice: #{@name} Additional Documents"
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

def business_case_files
  puts "==> Importing Practice: #{@name} Business Case Files"
  question_fields = {
    'Does your practice have a formal business case?': :attachment
  }
  question_fields.each do |key, value|
    next if @answers[@questions.index(key.to_s)].blank?
    image_path = "#{Rails.root}/tmp/surveymonkey_responses/#{@respondent_id}/#{@answers[@questions.index(key.to_s)]}"
    image_file = File.new(image_path)

    BusinessCaseFile.create practice: @practice, attachment: ActionDispatch::Http::UploadedFile.new(
                                                           filename: File.basename(image_file),
                                                           tempfile: image_file,
                                                           # detect the image's mime type with MIME if you can't provide it yourself.
                                                           type: MIME::Types.type_for(image_path).first.content_type
                                                           )
  end
end

def toolkit_files
  puts "==> Importing Practice: #{@name} Toolkit Files"
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
  puts "==> Importing Practice: #{@name} Checklist Files"
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
  puts "==> Importing Practice: #{@name} Publication Files"
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
  puts "==> Importing Practice: #{@name} Publications"
  question_fields = {
    'Does your practice have peer-reviewed publications associated with it online? Enter url(s) if so.': 3
  }

  question_fields.each do |key, value|
    q_index = @questions.index(key.to_s)
    end_index = q_index + value - 1
    (q_index..end_index).each do |i|
      answer = @answers[i]
      next if answer.blank?

      Publication.create(practice: @practice, link: answer) unless Publication.where(link: answer, practice: @practice).any?
    end
  end
end

def badges
  puts "==> Importing Practice: #{@name} Badges"
  question_fields = {
    'Has your practice been vetted? Has the practice been reviewed and approved by any of the following groups and qualify for badging? (Please select all that apply.)': 9
  }

  question_fields.each do |key, value|
    q_index = @questions.index(key.to_s)
    end_index = q_index + value - 1
    (q_index..end_index).each do |i|
      answer = @answers[i]
      next if answer.blank?

      badge = Badge.find_by(name: answer) || Badge.create(name: answer, icon: 'fas fa-circle', color: '#585858')
      BadgePractice.create badge: badge, practice: @practice unless BadgePractice.where(badge: badge, practice: @practice).any?
    end
  end
end

def implementation_timeline
  puts "==> Importing Practice: #{@name} Implementation Timeline"
  question_fields = {
    'Do you have a diffusion timeline regarding the steps to implement your practice?': :attachment
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
  puts "==> Importing Practice: #{@name} Risks and Mitigations"
  question_fields = {
    'Under the side navigation "Risks & Mitigations" tab, the "Risk" rating will eventually be provided by individuals who have implemented this practice.What is the primary risk to implementation? Please describe how you would mitigate it.': 2,
    'What is the second risk to implementation? Please describe how you would mitigate it.': 2,
    'What is the third risk to implementation? Please describe how you would mitigate it.': 2,
  }
  question_fields.each do |key, value|
    q_index = @questions.index(key.to_s)
    next if @answers[q_index].blank?

    rm = RiskMitigation.create practice: @practice
    risk = Risk.create risk_mitigation: rm, description: @answers[q_index]
    mitigation = Mitigation.create risk_mitigation: rm, description: @answers[q_index + 1]
  end
end

def additional_staff
  puts "==> Importing Practice: #{@name} Additional Staff"
  question_fields = [
      {'For the staff members that need to be added in the previous question, what job titles are required to implement your Practice?': 5},
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
  puts "==> Importing Practice: #{@name} Additional Resources"
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
  puts "==> Importing Practice: #{@name} Required Training Staff"
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
  puts "==> Importing Practice: #{@name} Costs and Difficulties"
  question_fields = {
    'List other Costs and Difficulties of Implementation that are unique to your Practice.': 6
  }
  question_fields.each do |key, value|
    q_index = @questions.index(key.to_s)
    end_index = q_index + 2

    (q_index..end_index).each do |i|
      next if @answers[i].blank?

      Cost.create practice: @practice, description: @answers[i] unless Cost.where(description: @answers[i], practice: @practice).any?
      Difficulty.create practice: @practice, description: @answers[i + 3] unless Difficulty.where(description: @answers[i + 3], practice: @practice).any?
    end
  end
end

def human_impact_photos
  puts "==> Importing Practice: #{@name} Human Impact Photos"
  question_fields = [[
    'Human Impact Photo 1',
    'Please provide a title for Human Impact Picture 1',
    'Please provide a brief paragraph describing the photo and the Human Impact.'
  ], [
    'Human Impact Photo 2',
    'Please provide a title for Human Impact Picture 2',
    'Please provide a brief paragraph describing the photo and the Human Impact.'
  ], [
    'Human Impact Photo 3',
    'Please provide a title for Human Impact Picture 3',
    'Please provide a brief paragraph describing the photo and the Human Impact.'
  ]]
  question_fields.each do |fields|
    description_indices = @questions.each_index.select { |i| @questions[i] == fields[2] }

    next if @answers[@questions.index(fields[0])].blank?

    image_path = "#{Rails.root}/tmp/surveymonkey_responses/#{@respondent_id}/#{@answers[@questions.index(key.to_s)]}"
    image_file = File.new(image_path)
    title = @answers[@questions.index(fields[1])]
    description = @answers[@questions.index(description_indices[i])]

    HumanImpactPhoto.create(practice: @practice, title: title, description: description, attachment: ActionDispatch::Http::UploadedFile.new(
                            filename: File.basename(image_file),
                            tempfile: image_file,
                            # detect the image's mime type with MIME if you can't provide it yourself.
                            type: MIME::Types.type_for(image_path).first.content_type
                           ))
  end
end

def file_uploads
  puts "==> Importing Practice: #{@name} File Uploads"
  question_fields = {
    'Under the side navigation "Origin of this practice" tab, please provide a photo of the individual who initiated the practice.': :origin_picture,
    'Upload a Display Image for your practice. This image will be used for the main title page and marketplace tile.': :main_display_image
  }
  question_fields.each do |key, value|
    next if @answers[@questions.index(key.to_s)].blank?

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

# Rake task to download files from our SurveyMonkey practice submission form
# Run with: bin/rails surveymonkey:download_response_files

namespace :surveymonkey do

  # rails surveymonkey:download_response_files
  desc 'Downloads response files'
  task :download_response_files => :environment do

    require 'surveymonkey'
    require 'mechanize'

    # Questions in the form:
    #   page / question id / question heading
    questions = [
      [4, 226709158, "Please upload applicable financial information."],
      [4, 226724568, "Upload a Display Image for your practice. This image will be used for the main title page and marketplace tile."],
      [4, 226730310, "Do you have survey results, verifiable testimonials, press releases, news articles regarding your practice that you would like to share?"],
      [4, 226730361, "Additional practice information 1"],
      [4, 226730732, "Additional practice information 2"],
      [4, 226731325, "Does your practice have a formal business case?"],
      [4, 226731349, "Does your practice have an implementation toolkit?"],
      [4, 227449385, "Does your practice have a pre-implementation checklist?*"],
      [4, 226731863, "Does your practice have peer-reviewed publications associated with it?"],
      [4, 226732296, "Additional publication upload 1"],
      [4, 226738172, "Do you have an implementation timeline for your practice?"],
      [2, 227451866, "Please provide a photo of the individual who initiated the practice. (This will be displayed under \"Origin of the practice\")"],
      [2, 226726658, "Impact Photo 1"],
      [2, 226726701, "Impact Photo 2"],
      [2, 226726752, "Impact Photo 3"],
      [2, 227470937, "Please upload a headshot of Support Team Person 1"],
      [2, 227470976, "Please upload a headshot of Support Team Person 2"],
      [2, 227471097, "Please upload a headshot of Support Team Person 3"],
      [2, 227471145, "Please upload a headshot of Support Team Person 4"],
      [2, 227471236, "Please upload a headshot of Support Team Person 5"]
    ]

    # Set the file download path
    download_dir = Dir.pwd + '/tmp/surveymonkey_responses/'

    # Delete SurveyMonkey tmp dir before starting
    FileUtils.rm_rf(download_dir)

    # Log into SurveyMonkey
    puts "==> Logging into SurveyMonkey"
    agent = Mechanize.new

    registered_devices_cookies = [
        {name: 'ep201', value: ENV['SURVEY_MONKEY_EP201']},
        {name: 'ep202', value: ENV['SURVEY_MONKEY_EP202']},
        {name: 'ep203', value: ENV['SURVEY_MONKEY_EP203']}
    ]

    registered_devices_cookies.each { |c|
      cookie = Mechanize::Cookie.new(c[:name], c[:value])
      cookie.domain = '.surveymonkey.com'
      cookie.expires = '2019-11-04T04:04:32.306Z'
      cookie.path = '/'
      agent.cookie_jar.add(cookie)
    }

    page = agent.get 'https://www.surveymonkey.com/user/sign-in'
    form = page.form
    username = form.field_with name: 'username'
    password = form.field_with name: 'password'
    username.value = ENV['SURVEY_MONKEY_USERNAME']
    password.value = ENV['SURVEY_MONKEY_PASSWORD']
    agent.submit(form)

    # Get the URL of the file provided in the answer
    def get_download_url(response, page, question_id)
      # Find the answer to the question, based on page and question ID
      answer = response['pages'][page]['questions'].find { |q| q['id'] == question_id.to_s }

      # If there's no answer (uploaded file) to the question, it will be `nil`
      if answer then answer['answers'][0]['download_url'] end
    end

    # Create the SurveyMonkey API client and get survey responses
    puts "==> Getting survey responses"
    client = SurveyMonkeyApi::Client.new
    survey_responses = client.responses_with_details(167278708, {per_page: 100})

    # Download files for each respondent
    survey_responses['data'].each do |response|
      puts "==> Downloading files for Respondent #{response['id']}"

      # Create the respondent directory to put downloaded files
      respondent_dir = download_dir + response['id']
      FileUtils.mkdir_p respondent_dir

      # Download files for each question with files as answers
      questions.each do |q|
        print " - Downloading \"#{q[2]}\"..."
        url = get_download_url(response, q[0], q[1])

        # If the URL is good, download the file
        if url
          puts " - Saving \"#{q[2]}\"..."
          file = agent.get(url)
          file.save(respondent_dir + '/' + URI.decode(file.filename))
        end

        puts "done"
      end
    end

    puts '***** Completed downloading survey response files *****'

  end
end

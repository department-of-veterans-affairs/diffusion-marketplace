# Rake task to download files from our SurveyMonkey practice submission form
# Run with: bin/rails surveymonkey:download_response_files

namespace :surveymonkey do
  desc 'Downloads response files'
  task :download_response_files => :environment do

    require 'surveymonkey'
    require 'mechanize'

    # Questions in the form:
    #   page / question id / question heading
    questions = [
      [1, 226709158, "Please upload applicable financial information."],
      [2, 226724568, "Upload a Display Image for your practice. This image will be used for the main title page and marketplace tile."],
      [2, 226730310, "Do you have survey results, verifiable testimonials, press releases, news articles regarding your practice that you would like to share?"],
      [2, 226730361, "Additional practice information 1"],
      [2, 226730732, "Additional practice information 2"],
      [2, 226731325, "Does your practice have a formal business case?"],
      [2, 226731349, "Does your practice have an implementation toolkit?"],
      [2, 227449385, "Does your practice have a pre-implementation checklist?*"],
      [2, 226731863, "Does your practice have peer-reviewed publications associated with it?"],
      [2, 226732296, "Additional publication upload 1"],
      [2, 226738172, "Do you have a diffusion timeline regarding the steps to implement your practice?"],
      [3, 227451866, "Under the side navigation \"Origin of this practice\" tab, please provide a photo of the individual who initiated the practice"],
      [3, 226726658, "Human Impact Photo 1"],
      [3, 226726701, "Human Impact Photo 2"],
      [3, 226726752, "Human Impact Photo 3"],
      [3, 227470937, "Please upload a headshot of Support Team Person 1"],
      [3, 227470976, "Please upload a headshot of Support Team Person 2"],
      [3, 227471097, "Please upload a headshot of Support Team Person 3"],
      [3, 227471145, "Please upload a headshot of Support Team Person 4"],
      [3, 227471236, "Please upload a headshot of Support Team Person 5"]
    ]

    # Set the file download path
    download_dir = Dir.pwd + '/tmp/surveymonkey_responses/'

    # Delete SurveyMonkey tmp dir before starting
    FileUtils.rm_rf(download_dir)

    # Log into SurveyMonkey
    puts "==> Logging into SurveyMonkey"
    agent = Mechanize.new
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
    survey_responses = client.responses_with_details(167278708)

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
          file = agent.get(url)
          file.save(respondent_dir + '/' + file.filename)
        end

        puts "done"
      end
    end

  end
end

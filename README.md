# Diffusion Marketplace
[![CircleCI](https://circleci.com/gh/agilesix/diffusion-marketplace.svg?style=svg)](https://circleci.com/gh/agilesix/diffusion-marketplace)

### Environments:
| Environment  | url  |
|---|---|
| development  | http://localhost:3200  |  
| ftl staging  | http://va-diffusion-marketplace-staging.efgnfj8pjn.us-west-2.elasticbeanstalk.com/  |  
| ftl production | https://marketplace.vaftl.us |
| vaec staging | https://staging.marketplace.va.gov |
| vaec production | https://marketplace.va.gov |
### Custom Rails Tasks:
| Task command  | description  |
|---|---|
| `rails dm:db_setup` |  Set up database. Runs `rails db:create` `rails db:migrate` `rails db:seed`  |  
| `rails dm:full_import` | Set up data using the full flow of the importer  |  
| `rails dm:reset_up` | Re-sets up database and imports all data from the full flow of the importer  |  
| `rails importer:import_answers` | import an xlsx and create practices  | 
| `rails importer:initial_featured` | sets up the "original" featured practices to show up on the landing page - depends on spreadsheet being imported | 
| `rails surveymonkey:download_response_files` | Rake task to download files from our SurveyMonkey practice submission form  | 
| `rails diffusion_history:all`| Imports all of the diffusion history we have so far for practices - used to populate the geolocation feature (Practice <-> Facility mappings) |
#### Ruby version

- `ruby 2.6.3`

- `rails ~> 5.2.1`

#### System dependencies

- `ruby 2.6.3`

- `bundler`

- `nodejs`

- `postgresql`

- ImageMagick 7+

#### Configuration

Check out `database.yml` to change the `username`/`password` for the database user. 
Be sure to create that user/role in the local postgres instance

#### Development Environment Variables

- run `figaro install` to get the "application.yml" file in your config folder

Please ask an engineer on the team for credentials to various APIs that we use.

```
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_REGION
S3_BUCKET_NAME

MAILER_SENDER

SURVEY_MONKEY_TOKEN
SURVEY_MONKEY_USERNAME
SURVEY_MONKEY_PASSWORD
SURVEY_MONKEY_EP201
SURVEY_MONKEY_EP202
SURVEY_MONKEY_EP203

GA_TRACKING_ID  # (prod only)
GOOGLE_API_KEY

# Optional
SESSION_REMEMBER_FOR_IN_DAYS # how long to remember the user for if they check the "Remember me" checkbox. default is 1 day
SESSION_TIMEOUT_IN_MINUTES # without checking the checkbox, how long the user's session stays alive if they are active. default is 15 minutes
```  

#### Database creation

- `rails db:create`

#### Database initialization

- `rails db:seed`

#### How to run the test suite

- `rspec`

[Here are our builds on CircleCi](https://circleci.com/gh/agilesix/diffusion-marketplace/tree/master)

## Development Environment Setup Instructions

### Pre-requisites
* all system dependencies have been met
* command line interface such as `bash`
* (if applicable) postgresql has a `dm` user and role, and this user can create databases

### Set up
#### Within the command line:

1. Clone this repository 

    `git clone https://github.com/agilesix/diffusion-marketplace.git`

2. Change directory into the newly created project directory
    
    `cd diffusion-marketplace`

3. Install project dependencies

    `bundle install`

4. Create the database

    `rails db:create`

5. Spin up the sever

    `rails s`

6. In a browser, browse to `http://localhost:3200` to make sure everything built correctly.


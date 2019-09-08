# Diffusion Marketplace
[![CircleCI](https://circleci.com/gh/agilesix/diffusion-marketplace.svg?style=svg)](https://circleci.com/gh/agilesix/diffusion-marketplace)

### Environments:
| Environment  | url  |
|---|---|
| development  | http://localhost:3200  |  
| staging  | http://va-diffusion-marketplace-staging.efgnfj8pjn.us-west-2.elasticbeanstalk.com/  |  
| ftl production | https://marketplace.vaftl.us |
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

- `rails 5.2.1`

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

GA_TRACKING_ID (prod only)

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

## Infrastructure  

This application is hosted on Amazon Web Services (AWS) Elastic Beanstalk (EB)
and Relational Database Services (RDS). 

To recreate our environment easily, 
we use Terraform to create our infrastructure.

### Terraform sets up:
1. an Elastic Beanstalk Application that uses Multi-container Docker
2. an Elastic Beanstalk Environment within the created application from step 1
3. a Postgresql database within RDS

### Pre-requisites
- AWS Account with EB permissions and credentials stored in `~/.aws/credentials` file
- terraform (`brew install terraform` for mac users)
- please check out the `terraform/variables.tf` file to update any variables such as the database user

### Set up
1. `terraform init`

2. `terraform plan -out plan.tfplan` 

    >This step will ask for a database password that is used
     to set up the database and whether the database should be publicly accessible
     or not (enter `true` or `false`). Use a strong
     password for the database password. 

3. `terraform apply plan.tfplan`

Once this is complete, terraform will output information about what was created
such as the database instance address and the EB DNS, of which you should be able to browse to!

#### Note:
> You may need to open port 5432 on the default security group in AWS in order for 
the postgres instance to work

### Teardown
`terraform destroy` 

## Deployment Instructions

This application uses Docker with docker-compose to build the application.
The deploy script builds and deploys the Docker image(s).

### Pre-requisites
- Docker/docker-compose
- awscli

### Manually deploy
#### Pre-requisites
- AWS environment variables set up: AWS_ACCOUNT_ID AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY
- <sha> commit sha (can get from git)
- <aws-region> aws region (e.g. us-west-2)
- <application-name> name of application that matches the EB application created (va-diffusion-marketplace)
- <application-environment> name of environment that matches the EB environment created within the application (staging/production)

`./scripts/deploy.sh <application-name> <application-environment-name> <aws-region> <sha>`

e.g.

`./scripts/deploy.sh va-diffusion-marketplace staging us-west-2 abd6bed7af25731713a5330aeabcbd37d8125990`

if the AWS environment variables are not set up:

```bash
AWS_ACCOUNT_ID=XX677677XXXX \
AWS_ACCESS_KEY_ID=AKIAIXEXIX5JW5XM6XXX \
AWS_SECRET_ACCESS_KEY=XXXxmxxXlxxbA3vgOxxxxCk+uXXXXOrdmpC/oXxx \
./scripts/deploy.sh va-diffusion-marketplace va-diffusion-marketplace-staging us-west-2 abd6bed7af25731713a5330aeabcbd37d8125990
```

if nothing is provided, the deploy script will ask for the essential variables that it needs and you can provide them interactively. 

## Changelog for releases
We use the [git-release-notes](https://github.com/ariatemplates/git-release-notes) library to track our changes for production builds. 

### Please only run this on the `production` branch

Requires: 
- npm (NodeJS)

1. First, install `git-release-notes` via `npm`: ```
                                                npm install -g git-release-notes
                                                ```

2. Make sure you are in the project folder

3. Find the two git commit sha1s you would like to record the changes from - referred to as `<from sha1>` and `<to sha1>` below

4. Run the `git-release-notes` command using the two git sha1s you want the changelog to record

```
git-release-notes <from sha1>..<to sha1> markdown > changelog.md
```
5. Push the updates to `changelog.md` to the `production` branch

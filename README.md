# Diffusion Marketplace

### Environments:
| Environment  | url  |
|---|---|
| development  | http://localhost:3200  |  
| staging  | http://va-diffusion-marketplace-staging.efgnfj8pjn.us-west-2.elasticbeanstalk.com/  |  

### Custom Rails Tasks:
| Task command  | description  |
|---|---|
| `rails dm:db_setup` |  Set up database |  
| `rails dm:full_import` | Set up data using the full flow of the importer  |  
| `rails dm:reset_up` | Re-sets up database and imports all data from the full flow of the importer  |  
| `rails importer:import_answers` | import an xlsx and create practices  | 
| `rails surveymonkey:download_response_files` | Rake task to download files from our SurveyMonkey practice submission form  | 

#### Ruby version

- `ruby 2.5.3`

- `rails 5.2.1`

#### System dependencies

- `ruby 2.5.3`

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

`./scripts/deploy.sh <application-name> <application-environment> <aws-region> <sha>`

e.g.

`./scripts/deploy.sh va-diffusion-marketplace staging us-west-2 abd6bed7af25731713a5330aeabcbd37d8125990`

if the AWS environment variables are not set up:

```bash
AWS_ACCOUNT_ID=XX677677XXXX \
AWS_ACCESS_KEY_ID=AKIAIXEXIX5JW5XM6XXX \
AWS_SECRET_ACCESS_KEY=XXXxmxxXlxxbA3vgOxxxxCk+uXXXXOrdmpC/oXxx \
./scripts/deploy.sh va-diffusion-marketplace staging us-west-2 abd6bed7af25731713a5330aeabcbd37d8125990
```

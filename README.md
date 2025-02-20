# Diffusion Marketplace

### Environments:
| Environment  | url  |
|---|---|
| development  | http://localhost:3200  |
| vaec development | https://dev.marketplace.va.gov |
| vaec staging | https://staging.marketplace.va.gov |
| vaec production | https://marketplace.va.gov |
### Custom Rails Tasks:
| Task command  | description  |
|---|---|
| `rails dm:db_setup` |  Set up database. Runs `rails db:create` `rails db:migrate` `rails db:seed`  |
| `rails dm:full_import` | Set up data using the full flow of the importer  |
| `rails dm:reset_up` | Re-sets up database and imports all data from the full flow of the importer  |
| `rails importer:import_answers` | import an xlsx and create practices  |
| `rails surveymonkey:download_response_files` (DEPRECATED) | Rake task to download files from our SurveyMonkey practice submission form. **Do not use this anymore. Ever.**  |
| `rails visns:create_visns_and_transfer_data` | Creates new VISN records based on the data from the "practice_origin_lookup.json" file
| `rails va_facilities:create_or_update_va_facilities` | Creates or updates VA facility records based on the data from the "va_facilities.json" file
| `rails diffusion_history:all`| Imports all of the diffusion history we have so far for practices - used to populate the geolocation feature (Practice <-> Facility mappings) |
| `rails milestones:milestones_transfer` | Transfers all of the original timeline entry milestones to the new milestone model  |
| `rails inet_partner_practices:assign_inet_partner` | Assigns the iNET practice partner to practices that have iNET as a partner  |
| `rails practice_origin_facilities:move_practice_initiating_facility` | Moves practice initiating facilities to the practice_origin_facilities table  |
| `rails port_milestones_to_timelines:port_milestones_to_timelines` | Ports data from Milestone table description field to Timelines.milestone field.  |
| `rails documentation:port_additional_documents_to_practice_resources ` | Ports additional documents to practice_resources
| `rails documentation:port_publications_to_practice_resources` | Ports publications (links) to practice_resources
| `rails risk_and_mitigation:remove_unpaired_risks_and_mitigation` | Removes risks without a corresponding mitigation AND removes mitigations without a corresponding risk.
| `rails practice_editors:add_practice_owners_to_practice_editors` | Adds each practice owner to the practice editors list of their corresponding practice
| `rails va_facilities:fix_data_va_facilities` | updates bad data in the va_facilities table (complexity field: 'fy17_parent_station_complexity_level')
| `rails practice_partners:apply_is_major_flag_to_partners` | Creates/updates certain flagship practice partners and applies the 'is_major' flag to them
| `rails practice_partners:add_new_practice_partners` | Adds new practice partners to the DB based on a spreadsheet provided in March 2022
#### Ruby version

- `ruby 3.3.6`

- `rails ~> 7.0`

#### System dependencies

- `ruby 3.3.6`
  - Linux-based install `rvm` (Ruby Version Manager) http://rvm.io/
  - `ruby -v`
- `bundler`
  - `gem install bundler`
- `node 22`
  - https://nodejs.org/en/
  - `node -v`
- `postgresql` https://www.postgresql.org/download/
- ImageMagick 7+ https://www.imagemagick.org/script/download.php
  - `identify --version`
- redis
  - OSX: if you have Homebrew: `brew install redis`
  - Windows: https://github.com/dmajkic/redis/downloads
  - ubuntu: https://tecadmin.net/install-redis-ubuntu/
    - you probably don't need the php extension

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

GA_TRACKING_ID  # (prod only)
GOOGLE_API_KEY

# For the importer to download the practice files and pictures
S3_TEST_MARKETPLACE_ACCESS_KEY_ID
S3_TEST_MARKETPLACE_SECRET_ACCESS_KEY
S3_TEST_BUCKET # Optional

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

## Initial data - Bulk Importer
#### pre-requisites:
Environment Variables
```.yaml
AWS_REGION
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
S3_BUCKET_NAME
S3_TEST_BUCKET_NAME
S3_TEST_MARKETPLACE_ACCESS_KEY_ID
S3_TEST_MARKETPLACE_SECRET_ACCESS_KEY
```
### Order of operations for running DM Specific rake tasks to set up data
1. Run `rails dm:full_import`

This will run:
1. `rails dm:db_setup` - sets up the db with `rails db:create db:migrate db:seed`
2. `rails importer:import_answers` - imports the initial practice data the Diffusion Marketplace team collected via Survey Monkey, images and all~
4. `rails visns:create_visns_and_transfer_data` - Creates new VISN records based on the data from the "practice_origin_lookup.json" file
5. `rails va_facilities:create_or_update_va_facilities` - Creates or updates VA facility records based on the data from the "va_facilities.json" file
7. `rails diffusion_history:all` - set up the initial diffusion history for the first five practices. Individual commands can be found here:  `lib/tasks/diffusion_history.rake`
10. `rails inet_partner_practices:assign_inet_partner` - assigns the iNET practice partner to practices that have iNET as a partner
12. `rails practice_origin_facilities:move_practice_initiating_facility` - moves practice initiating facilities to the practice_origin_facilities table
15. `rails practice_editors:add_practice_owners_to_practice_editors` - Adds each practice owner to the practice editors list of their corresponding practice
16. `rails va_facilities:fix_data_va_facilities` - updates bad data in the va_facilities table (complexity field: 'fy17_parent_station_complextity_level')
17. `rails practice_partners:apply_is_major_flag_to_partners` - Creates/updates certain flagship practice partners and applies the 'is_major' flag to them
18. `rails practice_partners:add_new_practice_partners` - Adds new practice partners to the DB based on a spreadsheet provided in March 2022

To reset all of the data and do the process all over again, run:
```bash
rails dm:reset_up
```

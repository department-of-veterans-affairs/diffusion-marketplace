# Diffusion Marketplace

#### Ruby version

- `ruby 2.5.3`

- `rails 5.2.1`

#### System dependencies

- `ruby 2.5.3`

- `bundler`

- `nodejs`

- `postgresql`

#### Configuration

Check out `database.yml` to change the `username`/`password` for the database user. 
Be sure to create that user/role in the local postgres instance

#### Database creation

- `rails db:create`

#### Database initialization

- `rails db:seed`

#### How to run the test suite

- `rspec`

#### Services (job queues, cache servers, search engines, etc.)

- `coming soon`

#### Deployment instructions

- `coming soon`

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

6. In a browser, browse to `http://localhost:3000` to make sure everything built correctly.

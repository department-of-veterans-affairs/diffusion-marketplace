variable "profile" {
  default = "default"
  description = "Name of your profile inside ~/.aws/credentials"
}

variable "application_name" {
  default = "va-diffusion-marketplace"
  description = "Name of your application"
}

variable "application_rails_env" {
  default = "production"
  description = "The value of RAILS_ENV"
}

variable "application_description" {
  default = "A pretty awesome application"
  description = "The Diffusion Marketplace supports a high reliability and learning organization by diffusing best practices."
}

variable "application_environment" {
  default = "production"
  description = "Deployment stage e.g. 'staging', 'production', 'test', 'integration'"
}

variable "application_s3_bucket_name" {
  default     = "va-diffusion-marketplace-prod"
  description = "Name of the S3 bucket"
}

variable "application_aws_access_key_id" {
  description = "S3 bucket AWS user's access key id"
}

variable "application_aws_secret_access_key" {
  description = "S3 bucket AWS user's secret access key"
}

variable "application_aws_region" {
  default     = "us-west-2"
  description = "S3 bucket region"
}

variable "region" {
  default     = "us-west-2"
  description = "Defines where your app should be deployed"
}

variable "solution_stack_name" {
  default     = "64bit Amazon Linux 2018.03 v2.13.0 running Multi-container Docker 18.06.1-ce (Generic)"
  description = "Defines the stack"
}

variable "max_autoscaling_size" {
  default     = "2"
  description = "Defines how many instances can be in an autoscaling group at a time"
}

variable "instance_type" {
  default     = "t2.micro"
  description = "Defines how what type of instance(s) should be created"
}

variable "env_default_key" {
  default     = "DEFAULT_ENV_%d"
  description = "Default ENV variable key for Elastic Beanstalk `aws:elasticbeanstalk:application:environment` setting"
}

variable "env_default_value" {
  default     = "UNSET"
  description = "Default ENV variable value for Elastic Beanstalk `aws:elasticbeanstalk:application:environment` setting"
}

## DB ##

variable "db_name" {
  default = "vadiffusionmarketplaceproduction"
  description = "Name of the database and the database's user. Must begin with a letter and contain only alphanumeric characters."
}

variable "db_engine" {
  default     = "postgres"
  description = "The database engine"
}

variable "db_engine_version" {
  default     = "10.6"
  description = "Version number of the database engine to be used for this instance."
}

variable "db_password" {
  description = "Password for the database. Only printable ASCII characters besides '/', '@', '\"', ' ' may be used."
}

variable "db_port" {
  default     = "5432"
  description = "Port for the database"
}

variable "db_instance_class" {
  default     = "db.t2.micro"
  description = "Choose the DB instance class that allocates the computational, network, and memory capacity required by planned workload of this DB instance."
}

variable "db_allocated_storage" {
  default     = 20
  description = "(Minimum: 20 GiB, Maximum: 32768 GiB) Higher allocated storage may improve IOPS performance."
}

variable "db_family" {
  default     = "postgres10"
  description = "Database family"
}

variable "db_major_engine_version" {
  default     = "10.6"
  description = "Database major engine version"
}

variable "db_publicly_accessible" {
  description = "Availablity for the database. Should it be public?"
}

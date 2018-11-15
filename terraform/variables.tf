variable "profile" {
  default = "default"
  description = "Name of your profile inside ~/.aws/credentials"
}

variable "application_name" {
  default = "va-diffusion-marketplace"
  description = "Name of your application"
}

variable "application_description" {
  default = "A pretty awesome application"
  description = "Sample application based on Elastic Beanstalk & Docker"
}

variable "application_environment" {
  default = "staging"
  description = "Deployment stage e.g. 'staging', 'production', 'test', 'integration'"
}

variable "region" {
  default     = "us-west-2"
  description = "Defines where your app should be deployed"
}

variable "solution_stack_name" {
  default     = "arn:aws:elasticbeanstalk:us-west-2::platform/Multi-container Docker running on 64bit Amazon Linux/2.11.4"
  description = "Defines the stack"
}

variable "max_autoscaling_size" {
  default     = "1"
  description = "Defines how many instances can be in an autoscaling group at a time"
}

variable "instance_type" {
  default     = "t2.micro"
  description = "Defines how what type of instance(s) should be created"
}

## DB ##

variable "db_engine" {
  default     = "PostgreSQL"
  description = "The database engine"
}

variable "db_engine_version" {
  default     = "10.1-R1"
  description = "Version number of the database engine to be used for this instance."
}

variable "db_password" {
  description = "Password for the database"
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
  default     = "postgres10.1-R1"
  description = "Database family"
}

variable "db_major_engine_version" {
  default     = "10.1-R1"
  description = "Database major engine version"
}

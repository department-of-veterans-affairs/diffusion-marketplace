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
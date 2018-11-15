##############################################################
# Data sources to get VPC, subnets and security group details
##############################################################
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = "${data.aws_vpc.default.id}"
}

data "aws_security_group" "default" {
  vpc_id = "${data.aws_vpc.default.id}"
  name   = "default"
}

#####
# DB
#####
module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "1.22.0"

  identifier = "${var.application_name}-${var.application_environment}"

  engine            = "${var.db_engine}"
  engine_version    = "${var.db_engine_version}"
  instance_class    = "${var.db_instance_class}"
  allocated_storage = "${var.db_allocated_storage}"
  storage_encrypted = false

  # kms_key_id        = "arm:aws:kms:<region>:<account id>:key/<kms key id>"
  name = "${var.db_name}"

  # NOTE: Do NOT use 'user' as the value for 'username' as it throws:
  # "Error creating DB Instance: InvalidParameterValue: MasterUsername
  # user cannot be used as it is a reserved word used by the engine"
  username = "${var.db_name}"

  password = "${var.db_password}"
  port     = "${var.db_port}"

  vpc_security_group_ids = ["${data.aws_security_group.default.id}"]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # disable backups to create DB faster
  backup_retention_period = 0

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  # DB subnet group
  subnet_ids = ["${data.aws_subnet_ids.all.ids}"]

  # DB parameter group
  family = "${var.db_family}"

  # DB option group
  major_engine_version = "${var.db_major_engine_version}"

  # Snapshot name upon DB deletion
  final_snapshot_identifier = "${var.application_name}-${var.application_environment}-snapshot"

  # Database Deletion Protection
  deletion_protection = true
}
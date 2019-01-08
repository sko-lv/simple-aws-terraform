provider "aws" {
    region = "us-east-1"
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
}

resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name = "terraform-state-lock-dynamo"
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20
 
  attribute {
    name = "LockID"
    type = "S"
  }
 
  tags {
    Name = "DynamoDB Terraform State Lock Table"
  }
}

resource "random_pet" "s3b" {
}

resource "aws_s3_bucket" "b" {
  bucket = "${random_pet.s3b.id}"
  acl    = "private"
  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_route53_zone" "test_zone" {
    name = "test.zone_name"
    vpc {
        vpc_id = "${var.vpc_id}"
    }
}
resource "aws_route53_record" "test_record" {
    zone_id = "${aws_route53_zone.test_zone.zone_id}"
    name = "sub.test.zone_name"
    type = "CNAME"
    ttl = "30"
    records = [
        "${var.zone_record}"
    ]
}

resource "aws_instance" "test_instance" {
    ami = "${var.ami_id}"
    instance_type = "${var.aws_instance_type}"

    vpc_security_group_ids = ["${aws_security_group.allow_all.id}",]
    key_name = "1"
    ebs_block_device {
        device_name = "/dev/sdb"
        volume_type = "standard"
        volume_size = "10"
    }
    tags = {
        Name = "terraform-task"
        Terraform = "Task"
    }
}

resource "aws_eip" "lb" {
    instance = "${aws_instance.test_instance.id}"
    vpc = true
}


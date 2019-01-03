provider "aws" {
    region = "us-east-1"
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"

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
    prefix_list_ids = ["pl-12c4e678"]
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

    vpc_security_group_ids = ["sg-0c8282abe6121302e","sg-08668f6a0cb9950de"]
    key_name = "1"
    subnet_id = "subnet-0c2cc732acd373275"
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

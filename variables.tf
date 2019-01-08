variable "vpc_id" {
 default = "vpc-8352e5f9"
}
variable "zone_record" {
 default = "test.zone_name"
}
variable "ami_id" {
 default = "ami-009d6802948d06e52"
}

variable "aws_access_key" {
}
variable "aws_secret_key" {
}
variable "aws_instance_type" {
 default = "t2.micro"
}

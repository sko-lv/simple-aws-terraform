terraform {
 backend "s3" {
 encrypt = true
 bucket = "s3tfstate"
# dynamodb_table = "terraform-state-lock-dynamo"
 region = "us-east-1"
 key = "tfstate/lock.tf"
 }
}

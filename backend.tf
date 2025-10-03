terraform {
  backend "s3" {
    bucket         = "prod-terraform-state"
    key            = "infra/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}

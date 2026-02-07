terraform {
  backend "s3" {
    bucket         = "vaultedkube-terraform-state"
    key            = "vaultedkube/networking/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "vaultedkube-terraform-lock"
    encrypt        = true
  }
}

# Run: terraform init -backend=false && terraform test
mock_provider "aws" {
  mock_data "aws_availability_zones" {
    defaults = { names = ["us-east-1a", "us-east-1b", "us-east-1c"] }
  }
}

variables {
  name = "test"
  env  = "dev"
  cidr = "10.10.0.0/16"
}

run "subnets_are_derived_from_cidr" {
  command = plan
  assert {
    condition     = output.private_subnet_cidrs[0] == "10.10.0.0/20"
    error_message = "first private subnet should be 10.10.0.0/20"
  }
  assert {
    condition     = length(output.private_subnet_cidrs) == 3
    error_message = "expected 3 private subnets"
  }
}

run "rejects_invalid_env" {
  command = plan
  variables { env = "qa" }
  expect_failures = [var.env]
}

run "rejects_small_cidr" {
  command = plan
  variables { cidr = "10.10.0.0/24" }
  expect_failures = [var.cidr]
}

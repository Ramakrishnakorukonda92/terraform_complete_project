provider "aws" {
  region = "us-east-1"
  assume_role {
    session_name = "terraform"
  }
  default_tags {
    tags = {
    }
  }
}

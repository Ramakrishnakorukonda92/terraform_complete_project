terraform {
    backend "s3" {
        key = "sample/state.tfstate"
        region = "us-east-1"
        encrypt = false
        bucket = "559954683639.my-state-bucket"
        # role_arn = ""
    }
}

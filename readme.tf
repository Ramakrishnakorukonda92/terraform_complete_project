get the thumbprint for https://token.actions.githubusercontent.com in IAM
comment backend.tf
then execute terraform init locally
terraform plan
terraform apply
then
un comment backend.tf
add s3 bucket name in backend.tf
terraform init
type yes
then push code to github
run the workflow


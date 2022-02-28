resource "aws_iam_service_linked_role" "autoscaling" {
  aws_service_name = "autoscaling.amazonaws.com"
  description      = "this is the rule"
  custom_suffix    = "${random_pet.server.id}-something-new-man"

  # provisioner "local-exec" {
  #     command = "Start-Sleep -s 5"
  # }  
}

output "service_linked_role_arn" {
  value = aws_iam_service_linked_role.autoscaling.arn
}

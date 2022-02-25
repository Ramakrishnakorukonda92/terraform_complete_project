resource "random_pet" "server" {
  length = 2
}
resource "aws_sns_topic" "user_updates" {
  name = "user-updates-topic-sample-one-two-three-${random_pet.server.id}"
}

resource "aws_sns_topic_subscription" "user_updates_sqs_target" {
  topic_arn = aws_sns_topic.user_updates.arn
  protocol  = "email"
  endpoint  = "kuntrapakam.rohith92@gmail.com"
}

resource "aws_autoscaling_notification" "example_notifications" {
  group_names = [
    module.autoscaling.autoscaling_group_name
  ]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR"
  ]
  topic_arn = aws_sns_topic.user_updates.arn
}
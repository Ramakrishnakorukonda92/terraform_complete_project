resource "aws_autoscaling_policy" "high_cpu" {
  name                   = "high_cpu"
  scaling_adjustment     = 4
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = module.autoscaling.autoscaling_group_name
}

resource "aws_cloudwatch_metric_alarm" "app1_asg_cwa_cpu" {
  alarm_name          = "App1-ASG-CWA-CPUUtilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "10"

  dimensions = {
    AutoScalingGroupName = module.autoscaling.autoscaling_group_name
  }

  alarm_description = "this metric monitors ec2 cpu utilizations and triggers"

  ok_actions = [aws_sns_topic.user_updates.arn]
  alarm_actions = [
    aws_autoscaling_policy.high_cpu.arn,
    aws_sns_topic.user_updates.arn
  ]
}
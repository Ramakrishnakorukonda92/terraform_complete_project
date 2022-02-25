resource "aws_cloudwatch_metric_alarm" "alb_2xx" {
  alarm_name          = "alb-200-success"
  comparison_operator = "GreaterThanThreshold"
  datapoints_to_alarm = "2"
  evaluation_periods  = "3"
  metric_name         = "HTTPCode_Target_2XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = "120"
  statistic           = "Sum"
  threshold           = "5"
  treat_missing_data  = "missing"

  dimensions = {
    LoadBalancer = module.alb.lb_arn_suffix
  }
  alarm_description = "hi"
  ok_actions        = [aws_sns_topic.user_updates.arn]
  alarm_actions     = [aws_sns_topic.user_updates.arn]
}
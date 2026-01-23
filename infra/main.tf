resource "aws_sns_topic" "alerts" {
  name = "apprunner-mini-alerts"
}

resource "aws_cloudwatch_metric_alarm" "active_instances_zero" {
  alarm_name        = "apprunner-mini-active-instances-zero"
  alarm_description = "AppRunnerでのデプロイに失敗した際のアラート"

  comparison_operator = "LessThanOrEqualToThreshold"
  threshold           = 0
  evaluation_periods  = 1
  datapoints_to_alarm = 1
  period              = 60
  statistic           = "Minimum"
  namespace           = "AWS/AppRunner"
  metric_name         = "ActiveInstances"

  dimensions = {
    ServiceName = "apprunner-mini"
    ServiceID   = "fbc3f8bb35614f39ab71295cc6ab2385"
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
  ok_actions    = [aws_sns_topic.alerts.arn]
}

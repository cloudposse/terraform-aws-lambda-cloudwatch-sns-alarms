locals {
  thresholds = {
    ErrorsThreshold    = "${max(var.errors_threshold, 0)}"
    ThrottlesThreshold = "${max(var.throttles_threshold, 0)}"
    DurationThreshold  = "${min(max(var.duration_threshold, 0), var.function_timeout)}"
  }

  alert_for     = "lambda"
  sns_topic_arn = "${var.sns_topic_arn == "" ? aws_sns_topic.default.arn : var.sns_topic_arn }"
  endpoints = "${distinct(compact(concat(list(local.sns_topic_arn), var.additional_endpoint_arns)))}"
}

## Units: Count
## Measures the number of invocations that failed due to errors in the function (response code 4XX). 
## This replaces the deprecated ErrorCount metric. Failed invocations may trigger a 
## retry attempt that succeeds. This includes:
## - Handled exceptions (for example, context.fail(error))
## - Unhandled exceptions causing the code to exit
## - Out of memory exceptions
## - Timeouts
## - Permissions errors
## This does not include invocations that fail due to invocation rates exceeding default concurrent 
## limits (error code 429) or failures due to internal service errors (error code 500).
resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  alarm_name          = "lambda_errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = "60"
  statistic           = "Sum"
  threshold           = "${local.thresholds["ErrorsThreshold"]}"
  alarm_description   = "Lambda function is erroring on invocation"
  alarm_actions       = ["${local.endpoints}"]
  ok_actions          = ["${local.endpoints}"]

  dimensions {
    FunctionName       = "${var.function_name}"
    Alias              = "${var.alias_name}"
    Version            = "${var.function_version}"
    "Executed Version" = "${var.executed_version}"
    Resource           = "${var.function_resource}"
  }
}

## Units: Count
## Measures the number of Lambda function invocation attempts that were throttled 
## due to invocation rates exceeding the customer’s concurrent limits (error code 429). 
## Failed invocations may trigger a retry attempt that succeeds.
resource "aws_cloudwatch_metric_alarm" "lambda_throttles" {
  alarm_name          = "lambda_throttles"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "Throttles"
  namespace           = "AWS/Lambda"
  period              = "60"
  statistic           = "Sum"
  threshold           = "${local.thresholds["ThrottlesThreshold"]}"
  alarm_description   = "Average number of throttled invocations higher than threshold"
  alarm_actions       = ["${local.endpoints}"]
  ok_actions          = ["${local.endpoints}"]

  dimensions {
    FunctionName       = "${var.function_name}"
    Alias              = "${var.alias_name}"
    Version            = "${var.function_version}"
    "Executed Version" = "${var.executed_version}"
    Resource           = "${var.function_resource}"
  }
}

## Units: Milliseconds
##  Measures the elapsed wall clock time from when the function code starts executing 
## as a result of an invocation to when it stops executing. This replaces the deprecated 
## Latency metric. The maximum data point value possible is the function timeout configuration. 
## The billed duration will be rounded up to the nearest 100 millisecond. Note that AWS Lambda 
## only sends these metrics to CloudWatch if they have a nonzero value.
resource "aws_cloudwatch_metric_alarm" "lambda_duration" {
  alarm_name          = "duration_too_high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "Duration"
  namespace           = "AWS/Lambda"
  period              = "60"
  statistic           = "Average"
  threshold           = "${local.thresholds["DurationThreshold"]}"
  alarm_description   = "Average database storage burst balance over last 10 minutes too low, expect a significant performance drop soon"
  alarm_actions       = ["${local.endpoints}"]
  ok_actions          = ["${local.endpoints}"]

  dimensions {
    FunctionName       = "${var.function_name}"
    Alias              = "${var.alias_name}"
    Version            = "${var.function_version}"
    "Executed Version" = "${var.executed_version}"
    Resource           = "${var.function_resource}"
  }
}

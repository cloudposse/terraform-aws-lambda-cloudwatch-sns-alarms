variable "function_name" {
  type        = "string"
  description = "Lambda function name"
}

variable "alias_name" {
  type        = "string"
  description = "The function alias to create an alarm for"
  default     = ""
}

variable "function_version" {
  type        = "string"
  description = "The function version to create an alarm for"
  default     = ""
}

variable "executed_version" {
  type        = "string"
  description = "The executed version of the function alias"
  default     = ""
}

variable "function_resource" {
  type        = "string"
  description = "The function version or alias to filter by"
  default     = ""
}

variable "additional_endpoint_arns" {
  description = "Any alert endpoints, such as autoscaling, or app escaling endpoint arns that will respond to an alert"
  default = []
  type = "list"
}

variable "sns_topic_arn" {
  description = "An SNS topic ARN that has already been created. Its policy must already allow access from CloudWatch Alarms, or set `add_sns_policy` to `true`"
  default     = ""
  type        = "string"
}

variable "add_sns_policy" {
  description = "Attach a policy that allows the notifications through to the SNS topic endpoint"
  default     = "false"
  type        = "string"
}

variable "function_timeout" {
  description = "The timeout value given to the lambda function in milliseconds"
  default     = "300000"

  # Max timeout 300 seconds
}

variable "errors_threshold" {
  type        = "string"
  description = "Number of errors acceptable for a function per minute"
  default     = "0"
}

variable "duration_threshold" {
  type        = "string"
  description = "A duration threshold in milliseconds that the function should complete within"
  default     = "20000"

  # Default 20 seconds
}

variable "throttles_threshold" {
  type        = "string"
  description = "Amount of throttling that is acceptable for a function"
  default     = "0"
}

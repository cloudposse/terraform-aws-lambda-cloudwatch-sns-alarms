# terraform-aws-lambda-cloudwatch-alarms
Terraform module for creating a set of Lambda alarms and outputting to an endpoint

Errors/Invocations Ratio

When calculating the error rate on Lambda function invocations, it’s important to distinguish between an invocation request and an actual invocation. It is possible for the error rate to exceed the number of billed Lambda function invocations. Lambda reports an invocation metric only if the Lambda function code is executed. If the invocation request yields a throttling or other initialization error that prevents the Lambda function code from being invoked, Lambda will report an error, but it does not log an invocation metric.

- Lambda emits `Invocations=1` when the function is executed. If the Lambda function is not executed, nothing is emitted.
- Lambda emits a data point for Errors for each invoke request. `Errors=0` means that there is no function execution error. `Errors=1` means that there is a function execution error.
- Lambda emits a data point for Throttles for each invoke request. `Throttles=0` means there is no invocation throttle. `Throttles=1` means there is an invocation throttle.


| Dimension         | Description                                                                                   |
|-------------------|-----------------------------------------------------------------------------------------------|
| FunctionName      | Filters the metric data by Lambda function.                                                   |
| Resource          | Filters the metric data by Lambda function resource, such as function version or alias.       |
| Version           | Filters the data you request for a Lambda version.                                            |
| Alias             | Filters the data you request for a Lambda alias.                                              |
| Executed Version  | Filters the metric data by Lambda function versions. This only applies to alias invocations.  |
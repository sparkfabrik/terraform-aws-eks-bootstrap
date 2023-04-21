# EKS CloudWatch integration

This module installs the CloudWatch Agent as DaemonSet inside an EKS cluster. The agent will automatically collect and send to CloudWatch the cluster metrics about performance and resource consumption, available in the "Container Insights" section. See https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Container-Insights-setup-metrics.html

Optionally, you can also enable Flunt-Bit logs collector that will capture application logs and send them to CloudWatch. Use the `fluent_bit_enable_logs_collection` variable to enable or disable the feature. See https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Container-Insights-setup-logs-FluentBit.html

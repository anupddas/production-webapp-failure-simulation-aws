# IAM Role & Policy Configuration

## Overview

This project uses an IAM Role to securely grant permissions to the EC2 instance without using access keys.

The role allows the EC2 instance to send logs and metrics to Amazon CloudWatch.

---

## IAM Role Details

* **Role Name:** EC2-CloudWatch-Role
* **Trusted Entity:** EC2 (Elastic Compute Cloud)
* **Use Case:** Allows EC2 to interact with AWS services securely

---

## Attached Policy

### CloudWatchAgentServerPolicy

This AWS-managed policy provides permissions required for the CloudWatch agent to:

* Publish metrics to CloudWatch
* Push logs to CloudWatch Logs
* Describe EC2 resources


### Policy Permissions (Simplified)

Below is a simplified representation of the permissions included in the policy:

```json
{
  "Effect": "Allow",
  "Action": [
    "cloudwatch:PutMetricData",
    "logs:PutLogEvents",
    "logs:CreateLogStream",
    "logs:CreateLogGroup",
    "ec2:DescribeInstances"
  ],
  "Resource": "*"
}
```

### Role Attachment

The IAM Role is attached directly to the EC2 instance:

EC2 → Actions → Security → Modify IAM Role → Attach `EC2-CloudWatch-Role`

---

## Failure Simulation (IAM Misconfiguration)

### Scenario

The CloudWatchAgentServerPolicy is removed from the IAM Role.

#### Impact

* EC2 instance cannot send logs or metrics to CloudWatch
* Monitoring and observability break
* No visibility into system performance

#### Troubleshooting Steps

1. We need to verify IAM Role is attached to EC2:

   * EC2 Dashboard → Instance → Security Tab

2. We will check attached policies:

   * IAM → Roles → EC2-CloudWatch-Role

3. We have to identify missing permissions:

   * Look for CloudWatchAgentServerPolicy

#### Resolution

Reattach the required policy:

IAM → Roles → EC2-CloudWatch-Role → Add Permissions → Attach Policy → Select `CloudWatchAgentServerPolicy`

---

## Best Practices

* We should use IAM Roles instead of access keys
* We need to follow the principle of least privilege
* We should regularly audit attached policies
* We must avoid using wildcard (*) permissions in production

---

## Key Takeaway

IAM misconfigurations can silently break monitoring systems.
Proper role management ensures secure and reliable communication between AWS services.

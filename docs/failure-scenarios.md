# Failure Scenarios & Troubleshooting Guide

This document outlines real-world failure scenarios simulated in this project, along with step-by-step debugging and resolution strategies.

---

## Overview

The purpose of these scenarios is to:

* Simulate common production issues
* Practice structured debugging
* Understand AWS infrastructure behavior
* Build a troubleshooting mindset

---

# Scenario 1 — Cannot SSH into EC2

### Problem

Unable to connect to EC2 instance via SSH.

```bash
ssh -i key.pem ec2-user@<PUBLIC-IP>
```

### Error:

```
Connection timed out
```

### Root Cause

* Missing or incorrect **Security Group rule**
* SSH (Port 22) not allowed

### Debugging Steps

1. We will first check if EC2 instance is running
2. Next, we need to verify public IP
3. We will inspect Security Group inbound rules:

   * SSH (Port 22) must be allowed
   * Source should be our IP

### Fix

1. We have go to EC2 → Security Groups
2. Edit Inbound Rules
3. Add:

```
Type: SSH
Port: 22
Source: My IP
```

4. Save and retry SSH

### Outcome

SSH access restored successfully.

---

# Scenario 2 — Website Not Loading

### Problem

Web application not accessible via browser.

```
http://<PUBLIC-IP>
```

### Root Cause

* Nginx service stopped or crashed

### Debugging Steps

1. We first need to verify whether EC2 is running or not.
2. We also check Security Group (HTTP allowed?)
3. We will SSH into instance
4. Next, check Nginx status:

```bash
sudo systemctl status nginx
```

### Observation

```
inactive (dead)
```

### Fix

Restart Nginx:

```bash
sudo systemctl start nginx
sudo systemctl enable nginx
```

### Outcome

Website becomes accessible again.

---

# Scenario 3 — IAM Permission Denied

### Problem

EC2 instance unable to send logs/metrics to CloudWatch.

### Root Cause

* IAM role missing required policy

### Debugging Steps

1. We will go to IAM → Roles
2. We have to check attached policies
3. We need to verify if `CloudWatchAgentServerPolicy` exists

### Observation

* Required policy not attached

### Fix

1. Attach policy:

```
CloudWatchAgentServerPolicy
```

2. Save changes

### Outcome

CloudWatch metrics and logs resume.

---

# Scenario 4 — High CPU Utilization

### Problem

CPU usage spikes abnormally.

### Root Cause

* High resource-consuming process

### Debugging Steps

1. We can monitor via CloudWatch (CPU > 70%)
2. If the CPU load is more than the predefined threshold, we have SSH into instance
3. Once connected, we will run the following command:

```bash
top
```

### Observation

```
process  → consuming high CPU
```

### Fix

Kill process:

```bash
pkill process
```

### Outcome

CPU usage returns to normal.

---

# Scenario 5 — Nginx Crash (Self-Healing Test)

### Problem

Nginx service stops unexpectedly.

### Root Cause

* Manual or unexpected service failure

### Debugging Steps

1. First we stop Nginx manually:

```bash
sudo systemctl stop nginx
```

2. Then we will bbserve system behavior

### Fix (Automatic)

* systemd detects failure
* Restarts Nginx automatically

Check status:

```bash
sudo systemctl status nginx
```

### Outcome

Service auto-recovers without manual intervention.

---

# Scenario 6 — Health Check Failure (Cron Recovery)

### Problem

Website returns non-200 response.

### Root Cause

* Application failure or service downtime

### Debugging Steps

1. We need to write a health check script that runs with a specified time period.
2. Script checks HTTP response:

```bash
curl http://localhost
```

### Observation

* Status != 200

### Fix (Automatic)

* Script triggers:

```bash
sudo systemctl restart nginx
```

### Outcome

Application recovers automatically.

---

# Scenario 7 — Instance Failure (Auto Scaling)

### Problem

One EC2 instance terminates unexpectedly.

### Root Cause

* Instance failure or manual termination

### Debugging Steps

1. We need to check Auto Scaling Group (ASG)
2. We also observe instance count drop

### Fix (Automatic)

* The ASG launches new instance
* The Elastic Load Balancer routes traffic to healthy instances

### Outcome

System remains available with no downtime.

---

# Key Learnings

* Security Groups control network access
* IAM controls permissions
* systemd enables service-level self-healing
* Cron jobs provide backup recovery
* CloudWatch enables monitoring & alerting
* Auto Scaling ensures infrastructure resilience

---

# Conclusion

This project demonstrates real-world production failures and recovery strategies, helping build strong debugging skills and a practical understanding of AWS infrastructure.

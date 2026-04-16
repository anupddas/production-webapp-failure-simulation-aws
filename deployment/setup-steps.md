# AWS Production Failure Lab — Setup Guide

This document provides step-by-step instructions to deploy the **Production Web App with Real Failure Simulation** on AWS.

---

## 1. Launch EC2 Instance (Initial Setup)

1. Go to AWS Console → EC2 → Launch Instance

2. Configure:

   * AMI: Amazon Linux 2023
   * Instance Type: t3.micro
   * Key Pair: Create and download `.pem` file

3. Network Settings:

   * Allow SSH (Port 22) → My IP
   * Allow HTTP (Port 80) → Anywhere
   * Allow HTTPS (Port 443) → Anywhere

4. Launch instance


## 2. Connect to EC2

```bash
chmod 400 your-key.pem
ssh -i your-key.pem ec2-user@<PUBLIC-IP>
```


## 3. Install and Configure Nginx

```bash
sudo dnf update -y
sudo dnf install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
```

Test in browser:

```
http://<PUBLIC-IP>
```


## 4. Configure Monitoring

* Go to CloudWatch → Metrics
* View EC2 CPU Utilization
* Create alarm:

  * Threshold: CPU > 70%


## 5. Attach IAM Role

1. Go to IAM → Roles → Create Role
2. Select EC2
3. Attach policy: `CloudWatchAgentServerPolicy`
4. Attach role to EC2 instance


## 6. Configure Security Group

Ensure inbound rules:

* SSH (22) → My IP
* HTTP (80) → Anywhere
* HTTPS (443) → Anywhere

## 7. Simulate Failures

### Scenario 1 — SSH Failure

* Remove SSH rule → Connection fails
* Re-add rule → Fix

### Scenario 2 — Website Down

```bash
sudo systemctl stop nginx
sudo systemctl start nginx
```

### Scenario 3 — IAM Permission Error

* Remove IAM policy → Monitoring fails
* Reattach policy → Fix

### Scenario 4 — High CPU

```bash
yes > /dev/null
pkill yes
```

## 8. Enable Self-Healing (systemd)

```bash
sudo systemctl edit nginx
```

Add:

```
[Service]
Restart=always
RestartSec=3
StartLimitIntervalSec=60
StartLimitBurst=5
```

Reload:

```bash
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl restart nginx
```

## 9. Advanced Self-Healing (Cron + Script)

1. Create script:

```bash
nano /home/ec2-user/health_check.sh
```

2. Add logic to check HTTP status and restart Nginx

3. Schedule cron job:

```bash
crontab -e
```

```
*/2 * * * * /home/ec2-user/health_check.sh
```

## 10. Load Balancer Setup

1. Go to EC2 → Load Balancers → Create
2. Choose Application Load Balancer
3. Configure:

   * Internet-facing
   * HTTP (Port 80)
4. Create Target Group
5. Register instances


## 11. Auto Scaling Group

1. Create Launch Template

   * Add `launch-template-userdata.sh` script
2. Create Auto Scaling Group:

   * Desired: 2
   * Min: 1
   * Max: 2
3. Attach to Load Balancer

## 12. Test High Availability

* Open Load Balancer DNS
* Refresh → different instances respond
* Terminate one instance → auto replacement

## 13. Cost Optimization

* Stop EC2 when not in use
* Avoid NAT Gateway
* Use t2.micro / t3.micro
* Delete resources after project

Estimated Cost:

* EC2: $6–8/month
* CloudWatch: $1–2/month
* Load Balancer (optional): $5–7/month


## 14. Cleanup

After testing:

* Delete Auto Scaling Group
* Delete Load Balancer
* Terminate EC2 instances
* Remove unused resources

---

## Outcome

You have successfully built:

* A production-like web application
* Failure simulation scenarios
* Self-healing mechanisms
* Scalable architecture using Auto Scaling and Load Balancer

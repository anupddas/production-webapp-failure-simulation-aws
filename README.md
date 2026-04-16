# Production Web App with Real Failure Simulation with AWS

## Overview

This project demonstrates the design, deployment, and management of a production-like web application on Amazon Web Services (AWS) with a strong focus on failure simulation, troubleshooting, and self-healing mechanisms.

A simple application is hosted on Amazon EC2 instances running Nginx and is exposed to the internet via an Application Load Balancer. The infrastructure incorporates monitoring, automated recovery, and high availability using Auto Scaling Groups.

The primary objective of this project is to gain hands-on experience in identifying, diagnosing, and resolving real-world production failures.


## Key Features

* Deployment of a web application using **EC2** and **Nginx**
* Secure configuration using **IAM roles** and **Security Groups**
* Monitoring and alerting using **CloudWatch**
* Simulation of real-world failure scenarios:
  * SSH access failure
  * Web server downtime
  * IAM permission issues
  * High CPU utilization
* Implementation of self-healing mechanisms:
  * systemd-based service restart
  * Cron-based health check automation
* High availability architecture using:
  * **Application Load Balancer**
  * **Auto Scaling Group** across multiple Availability Zones


## Architecture

The system follows a highly available and fault-tolerant architecture:

> User → Application Load Balancer → EC2 Instances (Nginx) → Auto Scaling Group

* The Load Balancer distributes incoming traffic across multiple EC2 instances.
* Auto Scaling Group ensures instance availability and replaces failed instances automatically.
* Each instance runs Nginx and serves a basic web page.
* Monitoring is handled using CloudWatch.

---

## Technologies Used

* Amazon EC2 (Linux)
* Nginx Web Server
* AWS IAM (Roles and Policies)
* AWS Security Groups
* Amazon CloudWatch (Metrics and Alarms)
* Application Load Balancer
* Auto Scaling Group
* Linux systemd
* Cron jobs

---

## Project Structure

```
aws-production-failure-lab/
│
├── README.md
├── LICENSE
│
├── docs/
│   ├── architecture-diagram.png
│   ├── failure-scenarios.md
│   ├── troubleshooting-guide.md
│
├── scripts/
│   ├── install_nginx.sh
│   ├── health_check.sh
│   ├── load_test.sh
│
├── screenshots/
│   ├── ec2-setup.png
│   ├── nginx-running.png
│   ├── cloudwatch-alarm.png
│   ├── asg-loadbalancer.png
│
├── configs/
│   ├── systemd-nginx-override
|   |   ├── systemd-nginx-override.sh
|   |   ├── usage.sh
|   |
│   ├── security-group-rules.md
│   ├── iam-role-policy.md
│
└── deployment/
    ├── launch-template-userdata.sh
    ├── setup-steps.md
```

---

## Setup Instructions

### 1. Launch EC2 Instance

* Used Amazon Linux 2023 AMI
* Selected **t3.micro** instance type
* Configured Security Group:
  * Allowing SSH (Port 22) from your IP
  * Allowing HTTP (Port 80) from anywhere
  * Allowing HTTPS (Port 443) from anywhere

### 2. Connect to Instance

```
chmod 400 your-key.pem
ssh -i your-key.pem ec2-user@<public-ip>
```

### 3. Install and Start Nginx

```
sudo dnf update -y
sudo dnf install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
```

### 4. Access Application

Open in browser:

```
http://<public-ip>
```

**Note**: To save cost, we keep the instances stopped. As a result the 'public-ip' is changed everytime the instances are started.

---

## Failure Scenarios

### Scenario 1: SSH Access Failure

* Cause: Security Group misconfiguration
* Resolution: Re-enable inbound rule for port 22

### Scenario 2: Website Not Loading

* Cause: Nginx service stopped
* Resolution: Restart Nginx using systemctl

### Scenario 3: IAM Permission Denied

* Cause: Missing IAM policy
* Resolution: Reattach required policy to EC2 role

### Scenario 4: High CPU Utilization

* Cause: Artificial load generation
* Resolution: Identify and terminate high CPU processes

---

## Self-Healing Mechanisms

### systemd Auto-Restart

Configured Nginx to automatically restart on failure using systemd service overrides.

### Health Check Script with Cron

A custom script checks HTTP response status and restarts Nginx if necessary.

```
*/2 * * * * /home/ec2-user/health_check.sh
```

---

## High Availability Setup

### Application Load Balancer

* Distributes incoming traffic across EC2 instances
* Performs health checks

### Auto Scaling Group

* Maintains desired number of instances
* Automatically replaces failed instances
* Ensures fault tolerance across multiple Availability Zones

---

## Monitoring and Alerts

* CloudWatch metrics used for CPU monitoring
* Alarm configured for high CPU utilization
* Provides visibility into system performance and health

---

## Cost Optimization

* Used t3.micro instances
* Stopped instances when not in use
* Avoided NAT Gateway and unnecessary services
* Deleted unused resources after completion

Estimated monthly cost: Upto 10 USD depending on usage

---

## Learning Outcomes

* Practical experience with AWS infrastructure deployment
* Understanding of failure scenarios in production systems
* Hands-on troubleshooting and debugging skills
* Implementation of self-healing mechanisms
* Design of highly available and fault-tolerant architecture
* Cost-aware cloud resource management

---

## License

This project is licensed under the MIT License.

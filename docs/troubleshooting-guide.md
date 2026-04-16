# Troubleshooting Guide

This guide provides a structured approach to diagnosing and resolving issues in the Production Web App with Real Failure Simulation with AWS.

---

# Debugging Philosophy

When something breaks, we will follow this order:

> **1. Infrastructure → 2. Network → 3. Service → 4. Permissions → 5. Performance**

We will never guess. We will always isolate the layer first.

---

# Step-by-Step Troubleshooting Framework

### Check Infrastructure (EC2)

We neeed to ensure the instance is running. To do this:

* We need to go to AWS Console → EC2 → Instances
* We need to verify:

  * Instance State = **Running**
  * Status Checks = **3/3 passed**

### Check Network (Security Groups)

It is also required to verify inbound rules.

#### Required Rules:

| Protocol | Port | Source    |
| -------- | ---- | --------- |
| SSH      | 22   | My IP     |
| HTTP     | 80   | 0.0.0.0/0 |

#### Note:

During this project I was connected to the network via mobile hotspot. Using "My IP" while on a mobile hotspot is a common way to quickly secure an instance, but it does come with a specific technical hurdle we should be aware of. Almost every mobile service providers use Dynamic IP addressing. This means the public IP address assigned to our phone (and subsequently our computer via hotspot) changes frequently—often every time we toggle Airplane Mode, restart our phone, or even when the lease expires naturally. When we select "My IP" in the AWS Security Group settings, AWS detects our current public IPv4 address and creates an inbound rule specifically for that single address. As a AWS will drop the connection in future because the Security Group is still looking for THAT SPECIFIC ADDRESS. We will see a "Connection Timeout" error. 

There is a solution to this problem. We have to first log into the AWS Management Console, navigate to EC2 > Security Groups, and edit the inbound rules. We have delete the old "My IP" rule and add a new one, selecting "My IP" again to grab our current address.

If we get the AWS CLI configured on our computer, we can script the update so we don't have to log into the console every time. We can also use the browser-based terminal in the AWS Console. This doesn't require us to open port 22 to our specific IP, as it uses AWS’s internal IP ranges to connect.

#### Best Practices for Security

While it might be tempting to set the source to 0.0.0.0/0 (Anywhere) to avoid this hassle, we will not do this. Opening port 22 to the entire internet invites brute-force attacks within minutes. Using a VPN with a static IP or utilizing **AWS Systems Manager (SSM) Session Manager** is the professional way to handle SSH. Session Manager allows you to connect to your instance via the command line without opening any inbound ports at all.

### Check Connectivity

Test SSH:

```bash id="ts1"
ssh -i key.pem ec2-user@<PUBLIC-IP>
```

If it fails:

* We will check key permissions (`chmod 400`)
* We need to verify public IP
* Then, check Security Group

### Check Application (Nginx)

We alos have verify service status:

```bash id="ts2"
sudo systemctl status nginx
```

#### Common States:

* `active (running)` → OK
* `inactive (dead)` → Needs restart

#### Restart Service (if needed)

```bash id="ts3"
sudo systemctl restart nginx
```

Enable auto-start:

```bash id="ts4"
sudo systemctl enable nginx
```

### Check Logs

We will view service logs using the following command:

```bash id="ts5"
journalctl -u nginx -f
```

We alos havew to check system logs:

```bash id="ts6"
sudo tail -f /var/log/messages
```

### Verify Website

At last, We will open the website in browser:

```id="ts7"
http://<PUBLIC-IP>
```

---

# IAM Troubleshooting

### Problem

AWS service access not working

### Check IAM Role

* We will go to IAM → Roles
* We need to verify role attached to EC2

#### Required Policy

```id="ts8"
CloudWatchAgentServerPolicy
```

#### Tip

If something works locally but not with AWS services → it's usually **IAM issue**

---

# Performance Troubleshooting

### High CPU Usage

### Check processes:

```bash id="ts9"
top
```

### Common Cause:

```id="ts10"
processName → high CPU usage
```

#### Fix:

```bash id="ts11"
pkill processName
```

#### Cloud Monitoring

We will use:

* CloudWatch → CPU Utilization
* Alarm triggers if threshold exceeded

---

# Self-Healing Verification

### systemd Check

```bash id="ts12"
sudo systemctl status nginx
```

### Cron Job Check

```bash id="ts13"
crontab -l
```

### Health Logs

```bash id="ts14"
cat /home/ec2-user/health.log
```

---

# Load Balancer Troubleshooting

### Problem

Website not loading via Load Balancer DNS

---

### Check:

We need to verify the following in sequence:
1. Target Group Health
2. Instance Status
3. Security Group (Port 80 open)

---

### Fix:

* We have to ensure instances are **healthy**
* We will restart Nginx if needed
* We have to Verify health check path:

```id="ts15"
/
```

---

# Auto Scaling Issues

### Problem

Instances not launching or replacing

### Check:

We need to verify the following in sequence:
* Launch Template configuration
* Subnet selection (must be multiple AZs)
* Desired capacity

### Fix:

* Correct template settings
* We have to ensure valid AMI and instance type

---

# Quick Troubleshooting Cheat Sheet

| Issue           | Likely Cause     | Fix             |
| --------------- | ---------------- | --------------- |
| SSH not working | Security Group   | Open port 22    |
| Website down    | Nginx stopped    | Restart service |
| No logs/metrics | IAM issue        | Attach policy   |
| High CPU        | Bad process      | Kill process    |
| ALB not working | Target unhealthy | Fix Nginx       |

---

# Tips

* We should always check **smallest layer first**
* We should not change multiple things at once
* We will use logs — they tell the truth
* We must think in layers (Network → App → AWS)

---

# Conclusion

This troubleshooting approach ensures systematic debugging of real-world production issues across infrastructure, networking, application, and AWS service layers.

# Security Group Rules – AWS Production Failure Lab

This document outlines the security group configurations used in the **Production Web App with Failure Simulation** project.

---

## Overview

Security Groups in AWS act as **virtual firewalls** that control inbound and outbound traffic to EC2 instances.

This project follows the principle of:

> **Least Privilege Access** – Only allow necessary traffic, block everything else.

---

## Inbound Rules Configuration

| Type  | Protocol | Port | Source    | Purpose                     |
| ----- | -------- | ---- | --------- | --------------------------- |
| SSH   | TCP      | 22   | My IP     | Secure remote access to EC2 |
| HTTP  | TCP      | 80   | 0.0.0.0/0 | Allow public web traffic    |
| HTTPS | TCP      | 443  | 0.0.0.0/0 | Future secure web traffic   |

---

## Outbound Rules Configuration

| Type        | Protocol | Port Range | Destination | Purpose                                |
| ----------- | -------- | ---------- | ----------- | -------------------------------------- |
| All Traffic | All      | All        | 0.0.0.0/0   | Allow EC2 to communicate with internet |

---

## Key Security Decisions

### 1. Restricted SSH Access

* SSH access is limited to **My IP only**
* Prevents unauthorized login attempts from the internet

### 2. Public Web Access

* HTTP (80) and HTTPS (443) are open to all users
* Required for serving web application traffic

### 3. No Unnecessary Open Ports

* Avoided using:

  * All Traffic (0.0.0.0/0)
  * Custom wide port ranges

## Failure Simulation Scenarios

### Scenario: SSH Access Failure

**Cause:**

* SSH rule (port 22) removed from security group

**Impact:**

* Unable to connect to EC2 instance via SSH

**Fix:**

* Re-add SSH rule with correct source (My IP)

---

### Scenario: Website Not Accessible

**Cause:**

* HTTP (port 80) rule removed

**Impact:**

* Browser cannot load website

**Fix:**

* Re-enable HTTP access from 0.0.0.0/0

---

## Best Practices Followed

* Principle of Least Privilege
* Minimal open ports
* Explicit rule definitions
* No wildcard access for SSH
* Separation of concerns (SSH vs Web traffic)

---

## Common Mistakes to Avoid

* Opening SSH to:

  * 0.0.0.0/0 (security risk)
* Allowing all traffic inbound
* Forgetting to enable HTTP/HTTPS
* Misconfiguring source IP ranges

---

## Summary

This configuration ensures:

* Secure administrative access
* Public availability of web application
* Protection against unauthorized access

---

## Real-World Relevance

These security practices are used in:

* Production web applications
* Cloud-native architectures
* DevOps and SRE environments

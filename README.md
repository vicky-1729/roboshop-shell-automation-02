# roboshop-shell-automation-03

This repository provides a comprehensive, production-ready automation solution for deploying the [RoboShop](https://roboshop.tcloudguru.in/) e-commerce microservices application using Bash shell scripts. The project is designed for modularity, maintainability, and ease of use, following best practices such as the DRY (Don't Repeat Yourself) principle, centralized logging, and systemd integration.

---

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Features](#features)
- [Supported Components](#supported-components)
- [Prerequisites](#prerequisites)
- [Setup & Usage](#setup--usage)
- [Service Scripts Explained](#service-scripts-explained)
- [Systemd Integration](#systemd-integration)
- [Configuration Files](#configuration-files)
- [Logging](#logging)
- [Troubleshooting & Debugging](#troubleshooting--debugging)
- [Security Considerations](#security-considerations)
- [Contributing](#contributing)
- [License](#license)

---

## Overview

**roboshop-shell-automation-03** automates the installation, configuration, and management of all RoboShop microservices and their dependencies. Each service is managed as a systemd unit, ensuring reliable startup, logging, and monitoring. The scripts are idempotent and can be safely re-run.

---

## Architecture

RoboShop is a microservices-based e-commerce platform. Each service is independently deployable and communicates over APIs. The architecture includes:

- **Frontend**: Nginx serving static content and acting as a reverse proxy.
- **Backend Services**: Node.js, Java, Python, and Go-based microservices.
- **Databases & Messaging**: MongoDB, MySQL, Redis, RabbitMQ.
- **Systemd**: Used for service management and monitoring.

![Roboshop 3 Tier Architecture](https://github.com/user-attachments/assets/ef7d3589-8118-4b91-b62b-a4c912762706)

---

## Project Structure

```
roboshop-shell-automation-03/
├── cart.sh
├── catalogue.sh
├── common_script.sh
├── dispatch.sh
├── frontend.sh
├── mongodb.sh
├── mysql.sh
├── payment.sh
├── rabbitMQ.sh
├── README.md
├── redis.sh
├── roboshop_server.sh
├── shipping.sh
├── user.sh
├── repo_config/
│   ├── mongo.repo
│   ├── nginx.conf
│   └── rabbitmq.repo
└── service/
    ├── cart.service
    ├── catalogue.service
    ├── dispatch.service
    ├── payment.service
    ├── shipping.service
    └── user.service
```

---

## Features

- **One-command setup** for each service.
- **Reusable logic** via `common_script.sh` (functions for validation, logging, user checks, etc.).
- **Centralized logging** to `/var/log/roboshop-logs/`.
- **Systemd integration** for service management (`start`, `stop`, `restart`, `status`).
- **Idempotent scripts**: safe to run multiple times.
- **Environment variable support** for easy configuration.
- **Automated repo configuration** for MongoDB, RabbitMQ, etc.
- **Automated user and directory management** for security and isolation.
- **Health checks** and validation after each step.

---

## Supported Components

| Service     | Language | Dependencies      | Database/Queue |
|-------------|----------|------------------|---------------|
| Frontend    | Nginx    | Nginx            | -             |
| Catalogue   | Node.js  | Node.js, npm     | MongoDB       |
| Cart        | Node.js  | Node.js, npm     | Redis         |
| User        | Node.js  | Node.js, npm     | MongoDB       |
| Shipping    | Java     | Maven, Java      | MySQL         |
| Payment     | Python   | Python3, pip     | RabbitMQ      |
| Dispatch    | Go       | Go               | -             |
| MongoDB     | -        | MongoDB repo     | -             |
| MySQL       | -        | MySQL repo       | -             |
| Redis       | -        | Redis repo       | -             |
| RabbitMQ    | -        | RabbitMQ repo    | -             |

---

## Prerequisites

- **OS**: RHEL/CentOS 8 or compatible Linux distribution
- **Privileges**: Root or sudo access
- **Network**: Internet access for package downloads
- **Tools**: `dnf`, `curl`, `wget`, `tar`, `systemctl`

---

## Setup & Usage

### 1. Clone the Repository

```bash
git clone https://github.com/<your-username>/roboshop-shell-automation-03.git
cd roboshop-shell-automation-03
```

### 2. Run Service Scripts

Run each script as root or with sudo, on the appropriate server:

```bash
sudo bash mongodb.sh
sudo bash redis.sh
sudo bash rabbitMQ.sh
sudo bash mysql.sh
sudo bash catalogue.sh
sudo bash cart.sh
sudo bash user.sh
sudo bash shipping.sh
sudo bash payment.sh
sudo bash dispatch.sh
sudo bash frontend.sh
```

> **Tip:** Run database/message queue scripts first, then backend services, then frontend.

### 3. Check Service Status

```bash
sudo systemctl status catalogue
sudo systemctl status cart
# ...and so on for each service
```

### 4. Access the Application

- **Frontend:** http://<frontend-server-ip>/
- **APIs:** Proxied via Nginx as per `nginx.conf`

---

## Service Scripts Explained

Each `*.sh` script performs:

- **Root user check**: Exits if not run as root.
- **Logging setup**: Logs all output to `/var/log/roboshop-logs/<service>.log`.
- **Dependency installation**: Installs required packages (Node.js, Python, Java, etc.).
- **User and directory setup**: Creates a dedicated user and app directory.
- **App download and extraction**: Downloads the latest code from the RoboShop artifact repo.
- **Dependency installation**: Installs app dependencies (npm, pip, maven, etc.).
- **Systemd service setup**: Copies and enables the relevant `.service` file.
- **Configuration**: Sets environment variables and config files as needed.
- **Health check**: Validates service startup and logs status.

---

## Systemd Integration

- Each service has a corresponding `.service` file in `service/`.
- Scripts copy these files to `/etc/systemd/system/` and enable them.
- Services are managed using standard systemd commands:
  ```bash
  sudo systemctl start <service>
  sudo systemctl stop <service>
  sudo systemctl restart <service>
  sudo systemctl status <service>
  ```

---

## Configuration Files

- **`repo_config/mongo.repo`**: YUM repo for MongoDB.
- **`repo_config/nginx.conf`**: Nginx config for static content and API proxying.
- **`repo_config/rabbitmq.repo`**: YUM repo for RabbitMQ.

Update these files as needed for your environment.

---

## Logging

- All script output is logged to `/var/log/roboshop-logs/<service>.log`.
- Systemd logs are available via `journalctl -u <service>`.
- Review logs for troubleshooting and auditing.

---

## Troubleshooting & Debugging

- **Service not running?**
  - Check logs in `/var/log/roboshop-logs/` and with `journalctl -u <service>`.
- **Port not listening?**
  - Ensure the app listens on `0.0.0.0` and firewall/security group allows the port.
- **Database connection errors?**
  - Verify DB host, port, credentials, and network connectivity.
- **Permission denied?**
  - Run scripts with `sudo` or as root.
- **Firewall issues?**
  - Use `firewall-cmd` or `iptables` to open required ports.
- **Health check failed?**
  - Check service logs and validate environment variables.

---

## Security Considerations

- **Run scripts as root only when necessary.**
- **Do not expose database/message queue ports to the public internet.**
- **Use strong passwords for all database and service users.**
- **Review and restrict firewall/security group rules.**
- **Keep your system and packages updated.**

---
# Roboshop-Shell-Automation Output

This file showcases the output and screenshots from the Roboshop Shell Automation project, demonstrating successful deployments, service status, and UI views.

---

<img width="1440" alt="image" src="https://github.com/user-attachments/assets/c7c9de5b-e84f-4d02-97dd-4fd3bbf4f733" />

![image](https://github.com/user-attachments/assets/083562e6-f939-4902-bdce-6b2ef51c993e)
![image](https://github.com/user-attachments/assets/e0e3b5a5-6ad6-410f-96d2-57794669186a)
![image](https://github.com/user-attachments/assets/06947771-18ce-4acb-88ac-3bfe3f83d01b)
![image](https://github.com/user-attachments/assets/cc68091e-a9cc-45ed-9f44-0615d9827593)
![image](https://github.com/user-attachments/assets/92e1f45d-6eb8-4719-a61b-442e23536e38)
![image](https://github.com/user-attachments/assets/72b540f7-3fc9-42e6-aec1-cab2c9361b27)
![image](https://github.com/user-attachments/assets/d82de33f-c045-497c-9820-a07222c697e4)
![image](https://github.com/user-attachments/assets/f64813ab-8200-46de-9fad-776b1dd71897)

---
## Contributing

Contributions are welcome! Please:

- Fork the repo and create a feature branch.
- Follow shell scripting best practices.
- Keep scripts modular and DRY.
- Submit a pull request with a clear description.

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

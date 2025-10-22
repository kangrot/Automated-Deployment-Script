🚀 Automated Dockerized Application Deployment Script (deploy.sh)
## 📖 Overview

This project provides a **robust, production-grade Bash script** that automates the setup, deployment, and configuration of a **Dockerized application** on a remote Linux server.

The script handles:

* Repository cloning and validation
* Remote server provisioning (Docker, Docker Compose, Nginx installation)
* Container deployment and reverse proxy setup
* Logging, error handling, and idempotency (safe re-runs)

It is designed to **simulate real-world DevOps workflows**, emphasizing automation, reliability, and reusability.

---

## 🧩 Features

* Securely authenticates with GitHub using a Personal Access Token (PAT)
* Automatically clones or updates repositories
* Installs and configures Docker, Docker Compose, and Nginx on a remote host
* Deploys containers and sets up Nginx reverse proxy for HTTP forwarding
* Logs all actions with timestamps for easy debugging
* Includes error handling, validation, and idempotent logic (safe re-run)
* Optional cleanup flag (`--cleanup`) for tearing down previous deployments

---

## 🧰 Prerequisites

Before running the script, ensure you have:

* A Linux operating system (Ubuntu/Debian recommended)
* Bash version 4 or higher
* Git installed locally
* SSH access to a remote Linux server
* A GitHub Personal Access Token (PAT) with `repo` access
* Internet connectivity between your local machine and the remote server

---

## ⚙️ Script Parameters

You will be prompted for the following parameters:

* **Git Repository URL** – e.g. `https://github.com/username/app.git`
* **Personal Access Token (PAT)** – your GitHub token for authentication
* **Branch Name** – defaults to `main` if not provided
* **SSH Username** – the username for your remote server
* **Server IP Address** – the public IP of your remote host
* **SSH Key Path** – path to your private SSH key, e.g. `~/.ssh/id_rsa`
* **Application Port** – the internal port your app runs on, e.g. `5000`

---

## 🧠 Script Workflow

### 1. Collect and Validate Parameters

Prompts for required input and validates that no critical fields are empty. Defaults to `main` branch if none is specified.

### 2. Clone Repository

Authenticates with GitHub using the PAT, clones the repository, and switches to the correct branch.
If the project folder already exists, it pulls the latest changes instead.
Verifies the presence of a `Dockerfile` or `docker-compose.yml`.

### 3. Establish SSH Connection

Checks that the remote server is reachable via SSH and validates the SSH key provided.
Performs a test connection before proceeding.

### 4. Prepare Remote Environment

On the remote server:

* Updates system packages
* Installs Docker, Docker Compose, and Nginx if missing
* Adds the user to the Docker group
* Enables and starts Docker and Nginx services
* Confirms installation versions

### 5. Deploy Application

* Transfers project files to the remote server (via `scp` or `rsync`)
* Builds and runs Docker containers using either `docker build` or `docker-compose up -d`
* Checks container health and logs
* Verifies that the app is accessible on the specified port

### 6. Configure Nginx Reverse Proxy

* Dynamically creates or updates an Nginx configuration file
* Forwards HTTP traffic from port 80 to the app’s internal container port
* Tests and reloads Nginx configuration
* (Optional) Placeholder for SSL setup with Certbot or a self-signed certificate

### 7. Validate Deployment

* Confirms that Docker is running
* Checks that the container is active and healthy
* Tests Nginx proxying using `curl` or `wget` locally and remotely

### 8. Logging and Error Handling

* All actions are logged in a file named `deploy_YYYYMMDD.log`
* Errors are trapped with `trap` and automatically logged before exiting
* Each stage has clear success or failure messages

### 9. Idempotency and Cleanup

* The script can safely be re-run without breaking existing deployments
* Existing containers are stopped and replaced cleanly
* Duplicate Docker networks or Nginx configs are prevented
* Includes an optional `--cleanup` flag to remove all deployed resources

---

## 🪄 Example Usage

**To deploy an application:**

```bash
chmod +x deploy.sh
./deploy.sh
```

You’ll be prompted to enter details like the Git repository URL, PAT, SSH details, and application port.

**To clean up an existing deployment:**

```bash
./deploy.sh --cleanup
```

This stops and removes containers, images, and Nginx configurations created by the script.

---

## 🧾 Example Log Output

```
[2025-10-18 12:42:19] Starting Deployment Script
[2025-10-18 12:42:25] Validating repository URL...
[2025-10-18 12:42:31] Cloning https://github.com/username/app.git
[2025-10-18 12:43:02] SSH connection established to 54.203.12.45
[2025-10-18 12:44:10] Docker and Nginx installed successfully
[2025-10-18 12:45:01] Application deployed and accessible at http://54.203.12.45
```

---

## 🧩 File Structure

```
.
├── deploy.sh                # Main deployment script
├── README.md                # Documentation
└── deploy_2025-10-19.log    # Example log file (auto-generated)
```

---

## 🧰 Tools Used

* Bash – main scripting language
* Git – version control and repo management
* Docker – containerization platform
* Docker Compose – multi-container orchestration
* Nginx – reverse proxy and load balancer
* SSH – secure remote access
* tee – used for logging

---

## ⚠️ Error Handling and Exit Codes

* Exit Code 1 – General error
* Exit Code 2 – Invalid user input
* Exit Code 3 – SSH connection failed
* Exit Code 4 – Docker or Nginx installation error
* Exit Code 5 – Deployment failure

All errors are written to the timestamped log file for troubleshooting.

---

## 🧹 Cleanup Behavior

When the `--cleanup` flag is used:

* Stops and removes running containers
* Deletes container images and volumes
* Removes Nginx configurations created by this script

---


---

## 📄 License

This project is released under the **MIT License**.
You are free to modify and reuse this project for learning or deployment purposes.




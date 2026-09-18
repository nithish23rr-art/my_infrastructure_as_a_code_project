# Infrastructure as Code — AWS EC2 + Ansible Nginx Deployment

This project provisions an AWS EC2 instance using **Terraform** and configures it as an **Nginx web server** using **Ansible**.

## 🏗️ Architecture

1. **Terraform** (`IAC_main.tf`) provisions a `t2.micro` EC2 instance on AWS (`ap-southeast-2` region).
2. **Ansible** (`Ansible/`) connects to the provisioned instance over SSH and installs/configures Nginx.

## 📁 Project Structure

```
.
├── IAC_main.tf              # Terraform config — provisions the EC2 instance
├── terraform.tfstate        # Terraform state (do NOT commit — see Security Notes)
├── terraform.tfstate.backup # Terraform state backup (do NOT commit)
├── Ansible/
│   ├── inventory            # Ansible inventory — target host details
│   ├── main.yaml             # Basic playbook: install & start nginx
│   └── moster.yaml           # Extended playbook: creates app user, installs packages, deploys index page
└── .gitignore
```

## ✅ Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) installed
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/index.html) installed
- An AWS account with credentials configured (`aws configure`)
- An existing AWS EC2 key pair (referenced as `key_name` in `IAC_main.tf`)

## 🚀 Usage

### 1. Provision infrastructure with Terraform

```bash
terraform init
terraform plan
terraform apply
```

This creates one EC2 instance (`t2.micro`) tagged `nitish-web-server`.

### 2. Update the Ansible inventory

Edit `Ansible/inventory` with the public IP of the instance Terraform just created, and point `ansible_ssh_private_key_file` to your **local, private** key file (see Security Notes below).

### 3. Run the Ansible playbook

```bash
cd Ansible
ansible-playbook -i inventory moster.yaml
```

This installs Nginx, creates a `deployer` system user, and deploys a simple HTML index page.

## ⚠️ Security Notes — please read before pushing this repo

A few things in this project should **never** be committed to a public (or even private) GitHub repo:

- **`Ansible/nithish2580.pem` and `.Downloadsnithish2580.pem`** — these are real SSH **private keys**. Anyone with this file can log into your EC2 instance. If this repo has already been pushed to GitHub with these files in it:
  1. **Rotate the key immediately** — delete/replace the AWS key pair and reissue a new one.
  2. Remove the `.pem` files from git history entirely (not just delete + commit — use `git filter-repo` or the BFG Repo-Cleaner, since old commits still contain them).
  3. Add `*.pem` to `.gitignore` going forward.
- **`terraform.tfstate` / `terraform.tfstate.backup`** — these can contain sensitive resource details (IPs, IDs, sometimes secrets). Add them to `.gitignore` and consider using [remote state](https://developer.hashicorp.com/terraform/language/state/remote) (e.g., an S3 backend) instead.

## 📝 Notes

- `main.yaml` has a YAML indentation issue on the `stop and disable nginx` task (missing space after `-`) — `moster.yaml` is the cleaner, working playbook and is recommended for actual use.

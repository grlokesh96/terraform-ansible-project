# Terraform + Ansible + GitHub Actions Project

## Objective
Provision infrastructure using Terraform:
- 1 Ansible Master EC2
- 4 Worker EC2 Instances

Configure servers using Ansible:
- Install Nginx
- Install Python3
- Enable Nginx Service

Automate everything using GitHub Actions.

## Workflow
```
Developer Push
    ↓
GitHub Actions
    ↓
Terraform Apply
    ↓
AWS EC2 Creation
    ↓
Dynamic Inventory Generation
    ↓
Ansible Playbook Execution
    ↓
Nginx + Python Installed
```

## Tools Used
- AWS EC2
- Terraform
- Ansible
- GitHub Actions
- Linux
- SSH

## Prerequisites
- AWS Account with appropriate IAM permissions
- GitHub repository secrets configured (see below)
- Terraform >= 1.0
- Ansible >= 2.9

## GitHub Secrets Required
Configure the following secrets in your GitHub repository (`Settings` → `Secrets and variables` → `Actions`):

| Secret | Description |
|--------|-------------|
| `AWS_ACCESS_KEY_ID` | AWS access key for Terraform |
| `AWS_SECRET_ACCESS_KEY` | AWS secret key for Terraform |
| `SSH_PRIVATE_KEY` | Private SSH key for EC2 access (PEM format) |

## Deployment

### Local Development
```bash
git clone <repo>
cd terraform-ansible-project

# Terraform
cd terraform
terraform init
terraform apply

# Verify with Ansible
cd ../ansible
ansible all -m ping
ansible-playbook playbook.yml
```

### CI/CD Pipeline
The GitHub Actions workflow automatically:
1. Runs on push to `main` branch
2. Validates and applies Terraform
3. Generates dynamic Ansible inventory
4. Executes Ansible playbook
5. Performs smoke tests

Access the deployed application:
```
http://<master-public-ip>
```
You should see the Nginx welcome page.

## Project Structure
```
.
├── .github/workflows/
│   └── terraform-ansible.yaml    # CI/CD pipeline
├── ansible/
│   ├── ansible.cfg
│   ├── inventory.ini             # Generated dynamically
│   └── playbook.yml
├── terraform/
│   ├── main.tf
│   ├── outputs.tf
│   ├── provider.tf
│   ├── terraform.tfvars
│   └── variables.tf
└── README.md
```

## Best Practices Implemented
- ✅ Secrets managed via GitHub Actions (never hardcoded)
- ✅ SSH keys handled securely with proper permissions
- ✅ Terraform state management via remote backend (recommended)
- ✅ Idempotent Ansible playbooks
- ✅ Concurrency control to prevent race conditions
- ✅ Artifact upload for Terraform plans
- ✅ Comprehensive error handling and retries
- ✅ Smoke tests for deployment validation

## Security Notes
- Never commit AWS credentials or SSH keys to the repository
- Use least-privilege IAM policies for CI/CD
- Enable GitHub branch protection rules
- Consider using OIDC for AWS authentication instead of long-lived keys

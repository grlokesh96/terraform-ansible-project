# Stage-by-Stage CI/CD Pipeline Rewrite

This document describes the **completely rewritten** GitHub Actions workflow with clear, numbered stages following DevOps best practices.

---

## Pipeline Overview

**File**: `.github/workflows/terraform-ansible.yaml`

**Triggers**:
- Push to `main`
- Manual dispatch (`workflow_dispatch`)

**Key Improvements**:
- Separate jobs for Terraform and Ansible (better isolation & parallelism)
- Proper caching for Terraform & Ansible
- Modern AWS OIDC-ready structure
- Comprehensive validation + security checks
- Clear numbered stages with comments
- Artifact management for plans and logs
- Idempotent and retry-safe design

---

## Job 1: `terraform`

### Stage 1: Checkout & Setup
```yaml
- Checkout repository
- Configure AWS credentials (with OIDC support commented)
- Setup Terraform (v1.9+)
- Setup TFLint + Checkov (security scanning)
```

### Stage 2: Validation
```yaml
- terraform fmt -check -recursive
- terraform init
- terraform validate
- tflint
- checkov -d terraform --framework terraform
```

### Stage 3: Planning & Artifact
```yaml
- terraform plan -out=tfplan
- Upload tfplan as artifact (retention 30 days)
- Upload plan summary as PR comment (optional)
```

### Stage 4: Apply (only on main + manual approval gate possible)
```yaml
- terraform apply -auto-approve tfplan
- Upload outputs as artifact
```

---

## Job 2: `ansible` (needs: terraform)

### Stage 1: Setup Environment
```yaml
- Download Terraform outputs artifact
- Install Ansible + dependencies
- Configure SSH key from secrets
- Setup dynamic inventory from Terraform outputs
```

### Stage 2: Connectivity & Validation
```yaml
- ansible all -m ping
- ansible-inventory --graph
```

### Stage 3: Configuration Management
```yaml
- ansible-playbook playbook.yml --diff -v
```

### Stage 4: Post-Deployment Verification
```yaml
- Smoke test: curl http://master-ip (HTTP 200)
- Optional: Run Ansible molecule tests or InSpec
```

---

## Security & Best Practices Applied

| Practice                    | Implementation                              |
|----------------------------|---------------------------------------------|
| Least privilege            | `contents: read`, `id-token: write`         |
| Secret handling            | Never logged, masked IPs                    |
| Concurrency control        | `cancel-in-progress: true`                  |
| State safety               | S3 backend recommended (commented)          |
| IaC quality                | fmt + validate + tflint + checkov           |
| Artifact retention         | tfplan + outputs stored 30 days             |
| SSH key security           | 600 permissions, never echoed               |
| Idempotency                | Ansible handlers + Terraform state          |

---

## How to Use the New Pipeline

1. Push to `main` → full pipeline runs
2. Review Terraform plan artifact before apply
3. Ansible runs only after successful Terraform job
4. All secrets are injected via GitHub Actions (never in repo)

This rewrite replaces the previous monolithic single-job workflow with a clean, maintainable, stage-by-stage design.

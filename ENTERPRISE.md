# Enterprise-Level Infrastructure as Code Platform

This repository now follows **enterprise-grade DevOps standards** suitable for production use at scale.

---

## Enterprise Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                    GitHub Actions CI/CD                         │
├──────────────────────┬──────────────────────┬───────────────────┤
│   Reusable Workflows │   Reusable Workflows │  Reusable Workflows│
│   (terraform/)       │   (ansible/)         │  (security/)       │
├──────────────────────┴──────────────────────┴───────────────────┤
│                        Environments                             │
│   dev/    │   staging/    │   prod/    │   (isolated state)     │
├─────────────────────────────────────────────────────────────────┤
│              Security & Governance Layer                        │
│  Checkov • Trivy • TFLint • OPA/Gatekeeper • Infracost          │
├─────────────────────────────────────────────────────────────────┤
│                    State & Secrets                              │
│     S3 + DynamoDB (Terraform)  •  GitHub Secrets / Vault        │
└─────────────────────────────────────────────────────────────────┘
```

---

## Key Enterprise Features Implemented

### 1. Reusable Workflows (DRY principle)
- `.github/workflows/reusable-terraform.yaml`
- `.github/workflows/reusable-ansible.yaml`
- `.github/workflows/reusable-security-scan.yaml`

### 2. Multi-Environment Support
- `environments/dev/`, `environments/staging/`, `environments/prod/`
- Separate Terraform state per environment
- Environment-specific variable files

### 3. Advanced Security
- OIDC authentication for AWS (no long-lived keys)
- Trivy + Checkov + TFLint + OPA policy checks
- Secret scanning with `trufflehog`
- Signed commits & branch protection ready

### 4. Cost & Quality Gates
- **Infracost** for cost estimation on every PR
- Terraform plan + cost comment on PRs
- Required approvals for production

### 5. Testing & Validation
- Ansible Molecule tests (structure ready)
- Terraform validation + security scanning
- Smoke tests + health checks post-deployment

### 6. Observability & Audit
- Terraform plan artifacts retained 90 days
- Structured logging and step summaries
- Clear stage-by-stage pipeline with enterprise naming

---

## Folder Structure (Enterprise)

```
.
├── .github/
│   ├── workflows/
│   │   ├── reusable-terraform.yaml
│   │   ├── reusable-ansible.yaml
│   │   ├── reusable-security-scan.yaml
│   │   └── deploy.yaml                 # Main caller workflow
│   └── CODEOWNERS
├── environments/
│   ├── dev/
│   ├── staging/
│   └── prod/
├── terraform/
│   ├── modules/
│   └── shared/
├── ansible/
│   ├── roles/
│   └── molecule/
├── policies/
│   └── opa/
├── .trivyignore
├── infracost.yml
└── README.md
```

---

## How to Use (Enterprise Flow)

1. **PR to any environment branch** → runs reusable security + terraform workflows
2. **Infracost** comments cost impact
3. **Manual approval** required for `prod`
4. **OIDC** assumes role instead of using access keys
5. **State** stored in S3 with locking

This setup is production-ready for mid-to-large organizations.

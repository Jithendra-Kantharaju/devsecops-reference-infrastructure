# DevSecOps Reference Infrastructure

A **production-grade DevSecOps implementation** on AWS EKS demonstrating 8 core security, compliance, and operational practices with full CI/CD automation.

## 🎯 Overview

This project showcases a complete DevSecOps architecture with:
- **Automated CI/CD Pipeline** (GitHub Actions + Argo CD)
- **Security Scanning** at multiple layers (Trivy, OPA, Falco)
- **Infrastructure as Code** (Terraform + Kubernetes)
- **Secret Management** (HashiCorp Vault)
- **Observability** (OpenTelemetry, Jaeger, Datadog)
- **Audit Logging** (CloudTrail)
- **Cost Management** (FinOps)

---

## ✅ 8 Features Verification

| # | Feature | Status | Evidence |
|---|---------|--------|----------|
| 1 | **Argo CD GitOps** | ✅ VERIFIED | Automated deployment syncing |
| 2 | **CloudTrail Audit** | ✅ VERIFIED | All AWS API calls logged |
| 3 | **Network Policies** | ✅ VERIFIED | Kubernetes network segmentation |
| 4 | **OPA/Conftest** | ✅ VERIFIED | 117 policy tests passed |
| 5 | **Vault Secrets** | ✅ VERIFIED | Secret management working |
| 6 | **Falco Runtime** | ✅ VERIFIED | Container anomaly detection |
| 7 | **Datadog OTel** | ✅ VERIFIED | Observability infrastructure ready |
| 8 | **FinOps Cost** | ✅ VERIFIED | AWS cost tracking operational |

---

## 🏗️ Architecture Diagram

![DevSecOps Architecture](https://raw.githubusercontent.com/Jithendra-Kantharaju/devsecops-reference-infrastructure/main/docs/images/Architecture_image.png)

**Architecture Overview:**

The diagram illustrates the complete DevSecOps flow:

1. **Developer Workflow** → Code pushed to GitHub
2. **GitHub Actions Pipeline** → 8 automated security and build jobs
3. **Container Registry** → Images pushed to GHCR
4. **Argo CD** → GitOps controller syncs manifests
5. **EKS Cluster** → 5 namespaces with security controls
6. **AWS Services** → IAM, CloudTrail, Cost Explorer
7. **End User** → Application accessible via LoadBalancer

---

## 📊 Deployment Verification Screenshots

### 1. Application Running Successfully

![Application](https://raw.githubusercontent.com/Jithendra-Kantharaju/devsecops-reference-infrastructure/main/docs/images/Application.png)

**Status:** ✅ Application deployed and running
- Tic-Tac-Toe game playable at `localhost:8080`
- React frontend working correctly
- Score tracking operational
- Game history maintained

---

### 2. Argo CD GitOps Synchronization

![Argo CD](https://raw.githubusercontent.com/Jithendra-Kantharaju/devsecops-reference-infrastructure/main/docs/images/Argocd.png)

**Verification Command:**
```bash
kubectl -n argocd get application tic-tac-toe
```

**Status:** ✅ Synced & Healthy
- Application automatically deployed from git
- Continuous sync enabled
- Zero manual kubectl commands needed

---

### 3. AWS EKS Cluster Status

![AWS EKS](https://raw.githubusercontent.com/Jithendra-Kantharaju/devsecops-reference-infrastructure/main/docs/images/AWS_EKS.png)

**Verification Command:**
```bash
aws eks describe-cluster --name devsecops --query 'cluster.[name,status,version,platformVersion]'
```

**Status:** ✅ Fully Operational
- Cluster Name: `devsecops`
- Status: `ACTIVE`
- Kubernetes Version: `1.34`
- Platform Version: `eks.23`
- 2x t3.medium nodes running

---

### 4. AWS CloudTrail Audit Logging

![Cost-Ops](https://raw.githubusercontent.com/Jithendra-Kantharaju/devsecops-reference-infrastructure/main/docs/images/Cost-Ops.png)

**Verification Command:**
```bash
aws cloudtrail lookup-events --max-results 5 --output table
```

**Status:** ✅ Audit Logging Operational
- Events logged:
  - `DescribeInstanceStatus` (AutoScaling)
  - `GetCallerIdentity` (Boto)
  - `DescribeInstances` (boto)
- All API calls tracked with timestamps
- Full compliance trail maintained

---

### 5. Deployment Status & Replicas

![Deployment Status](https://raw.githubusercontent.com/Jithendra-Kantharaju/devsecops-reference-infrastructure/main/docs/images/Deployment_Status.png)

**Verification Command:**
```bash
kubectl get deployments,pods,svc -n default
```

**Status:** ✅ All Resources Running
- Deployment: 3/3 replicas
- All pods in `Running` state
- Services configured and active:
  - `service/kubernetes` (ClusterIP: 10.100.0.1)
  - `service/tic-tac-toe` (ClusterIP: 10.100.223.250)
  - Ingress with LoadBalancer exposed

---

### 6. Falco Runtime Security

![Falco](https://raw.githubusercontent.com/Jithendra-Kantharaju/devsecops-reference-infrastructure/main/docs/images/Falco.png)

**Verification Command:**
```bash
kubectl -n falco logs ds/falco | grep -i "unexpected process" | tail -5
```

**Status:** ✅ Runtime Monitoring Active
- Detects unexpected processes
- Alert: "Unexpected Process In App Container"
- Container: `tic-tac-toe-5d96f98f49-g2sbp`
- User: `nginx`
- Real-time anomaly detection operational

---

### 7. GitHub Actions CI/CD Pipeline

![GitOps](https://raw.githubusercontent.com/Jithendra-Kantharaju/devsecops-reference-infrastructure/main/docs/images/GitOps.png)

**Status:** ✅ All 8 Jobs Passing
- Security Scanning ✅ (18s)
- Lint & Test ✅ (18s)
- OPA / Conftest ✅ (4s)
- Infrastructure Audit ✅ (8s)
- FinOps Cost Analysis ✅ (8s)
- Build ✅ (24s)
- Docker Build & Scan ✅ (1m 16s)
- Update Deployment Image ✅ (7s)

**Total Pipeline Time:** ~2m 20s
**Success Rate:** 100%

---

### 8. Jaeger Distributed Tracing

![Jaeger](https://raw.githubusercontent.com/Jithendra-Kantharaju/devsecops-reference-infrastructure/main/docs/images/Jaeger.png)

**Verification Command:**
```bash
kubectl port-forward -n datadog svc/jaeger 16686:16686
# Open: http://localhost:16686
```

**Status:** ✅ Tracing Infrastructure Ready
- Service: `jaeger-all-in-one`
- 10+ Traces collected
- Latency analysis: 65µs to 1.35ms
- Distributed tracing operational
- Span visualization available

---

### 9. Kubernetes Resources Overview

![K8s Resources](https://raw.githubusercontent.com/Jithendra-Kantharaju/devsecops-reference-infrastructure/main/docs/images/K8s_Resources.png)

**Verification Command:**
```bash
kubectl get all -n default -o wide
```

**Status:** ✅ All Resources Healthy
- Deployment: `tic-tac-toe` (3 replicas, 3 ready)
- Pods: All running on cluster nodes
- Services: ClusterIP and Ingress operational
- Age: 4-5 hours running stable

---

### 10. Network Policies Enforcement

![Network Policies](https://raw.githubusercontent.com/Jithendra-Kantharaju/devsecops-reference-infrastructure/main/docs/images/Networkpolices.png)

**Verification Command:**
```bash
kubectl get networkpolicies -n default
kubectl describe networkpolicy deny-all-traffic
```

**Status:** ✅ Network Segmentation Active
Three policies enforced:
- `deny-all-traffic`: Blocks all traffic by default
- `allow-tic-tac-toe-ingress`: Allows traffic from Ingress
- `allow-tic-tac-toe-egress`: Allows DNS and external services

**Security Impact:**
- Even if container is compromised, no lateral movement possible
- Only whitelisted traffic flows

---

### 11. OPA/Conftest Policy Validation

![OPA-Conftest](https://raw.githubusercontent.com/Jithendra-Kantharaju/devsecops-reference-infrastructure/main/docs/images/OPA-Conftest.png)

**Verification Command:**
```bash
conftest test kubernetes/*.yaml -p kubernetes/policies/
```

**Status:** ✅ All Policy Tests Passing
- Total Tests: 117
- Passed: 117 ✅
- Failed: 0
- Exceptions: 0

**Policies Enforced:**
- ✅ No root containers
- ✅ Read-only root filesystem
- ✅ Resource limits defined
- ✅ Health probes configured
- ✅ Security context hardened

---

### 12. Vault Secret Management

![Vault Status](https://raw.githubusercontent.com/Jithendra-Kantharaju/devsecops-reference-infrastructure/main/docs/images/vault-status.png)

**Verification Command:**
```bash
kubectl -n vault exec vault-0 -- vault kv get secret/tic-tac-toe/config
```

**Status:** ✅ Secrets Management Operational
- Secret Path: `secret/data/tic-tac-toe/config`
- Keys stored:
  - `datadog-api-key`: `demo123`
  - `app-config`: `enabled`
- Created: `2026-06-06T23:47:32Z`
- Version: 2
- Auto-injection configured

**Security Features:**
- Secrets never in git or environment
- Automatic rotation enabled
- Per-pod authentication
- Complete audit trail

---

## 🚀 Quick Start

### Prerequisites

```bash
# AWS CLI configured
aws --version

# kubectl installed
kubectl version --client

# eksctl installed
eksctl version

# Terraform installed
terraform version
```

### Deploy Infrastructure

```bash
# 1. Clone repository
git clone https://github.com/Jithendra-Kantharaju/devsecops-reference-infrastructure.git
cd devsecops-reference-infrastructure

# 2. Deploy Terraform infrastructure
cd infrastructure
terraform init
terraform apply

# 3. Create EKS cluster
eksctl create cluster --name devsecops --region us-east-1 --nodes 2 --node-type t3.medium

# 4. Install platform add-ons
kubectl apply -f kubernetes/vault/
kubectl apply -f kubernetes/falco/
kubectl apply -f kubernetes/datadog/

# 5. Deploy Argo CD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -f argocd/application.yaml

# 6. Verify deployment
kubectl -n argocd get application tic-tac-toe
# Expected: Synced & Healthy

# 7. Access application
kubectl port-forward svc/tic-tac-toe 8080:80
# Open: http://localhost:8080
```

---

## 📊 Component Details

### CI/CD Pipeline (GitHub Actions - 8 Jobs)

| Job | Purpose | Tools | Time |
|-----|---------|-------|------|
| 1 | Security Scanning | Trivy SARIF | ~18s |
| 2 | Lint & Test | ESLint + Vitest | ~18s |
| 3 | Policy Validation | OPA/Conftest | ~4s |
| 4 | Application Build | TypeScript + Vite | ~24s |
| 5 | Container Build | Docker + GHCR | ~1m 16s |
| 6 | Infrastructure Audit | CloudTrail | ~8s |
| 7 | FinOps Analysis | Cost Explorer | ~8s |
| 8 | Update Manifests | Image bump | ~7s |

**Total:** ~2m 20s per build

### Kubernetes Platform Add-ons

| Namespace | Component | Purpose | Status |
|-----------|-----------|---------|--------|
| DEFAULT | Tic-Tac-Toe App | React application (3 replicas) | ✅ Running |
| ARGOCD | Argo CD | GitOps continuous deployment | ✅ Synced |
| VAULT | Vault + Agent Injector | Secret management & injection | ✅ Active |
| DATADOG | OTel Collector, Jaeger | Distributed tracing | ✅ Collecting |
| FALCO | Falco DaemonSet | Runtime security monitoring | ✅ Monitoring |

### AWS Services

| Service | Purpose | Status |
|---------|---------|--------|
| IAM OIDC Provider | GitHub Actions auth | ✅ Configured |
| CloudTrail | Audit logging to S3 | ✅ Active |
| Cost Explorer | FinOps tracking | ✅ Tracking |

---

## 🔐 Security Features

✅ **Network Policies**: Default deny + allow ingress/egress rules
✅ **RBAC**: ServiceAccount + Role-based access control
✅ **Secret Management**: Vault with automatic injection
✅ **Runtime Security**: Falco anomaly detection
✅ **Container Scanning**: Trivy vulnerability scans
✅ **Policy Enforcement**: OPA/Conftest validation
✅ **Audit Logging**: CloudTrail for compliance

---

## 📈 Observability Stack

- **Traces**: OpenTelemetry → Jaeger for distributed tracing
- **Metrics**: Datadog Agent for resource monitoring
- **Logs**: CloudWatch + Datadog for centralized logging
- **Cost**: AWS Cost Explorer for FinOps analysis

---

## 💾 Repository Structure

```
.
├── docs/
│   ├── images/
│   │   ├── Architecture_image.png
│   │   ├── Application.png
│   │   ├── Argocd.png
│   │   ├── AWS_EKS.png
│   │   ├── Cost-Ops.png
│   │   ├── Deployment_Status.png
│   │   ├── Falco.png
│   │   ├── GitOps.png
│   │   ├── Jaeger.png
│   │   ├── K8s_Resources.png
│   │   ├── Networkpolices.png
│   │   ├── OPA-Conftest.png
│   │   └── vault-status.png
│   ├── PROJECT-DOCUMENTATION.md    # Detailed technical documentation
│   └── SCREENSHOTS-GUIDE.md         # Guide for adding screenshots
├── .github/workflows/               # CI/CD Pipeline
├── infrastructure/                  # Terraform Infrastructure as Code
├── kubernetes/                      # Kubernetes manifests
│   ├── deployment-secure.yaml
│   ├── network-policy.yaml
│   ├── vault/
│   ├── falco/
│   └── datadog/
├── argocd/
│   └── application.yaml            # Argo CD GitOps application
├── src/                             # React application source
│   ├── telemetry/                  # OpenTelemetry instrumentation
│   └── utils/
└── README.md                        # This file
```

---

## 📚 Documentation

For comprehensive explanation of architecture, implementation details, and interview preparation:

- **[docs/PROJECT-DOCUMENTATION.md](docs/PROJECT-DOCUMENTATION.md)** - Deep technical documentation with 10 interview Q&A
- **[docs/SCREENSHOTS-GUIDE.md](docs/SCREENSHOTS-GUIDE.md)** - Guide for properly adding screenshots to GitHub

---

## 🧹 Cleanup

```bash
# Delete EKS cluster (saves ~$20/day)
eksctl delete cluster --name devsecops --region us-east-1

# Destroy Terraform resources
cd infrastructure
terraform destroy -auto-approve
```

---

## 💰 Cost Analysis

### Monthly Breakdown (Running 24/7)

```
EKS Control Plane:          $73/month
EC2 Nodes (2x t3.medium):  $292/month
Load Balancer:              $16/month
Data Transfer:              $30-50/month
CloudTrail:                 $5/month
S3 Storage:                 $1/month
                            ─────────────────
TOTAL:                      ~$420/month
```

### Cost Optimization

- ✅ Use spot instances (-70% on compute)
- ✅ Reserved instances (-30%)
- ✅ Schedule shutdown at night (-50%)
- ✅ Right-sizing with AWS Compute Optimizer

---

## 📈 Key Metrics

- **Pipeline Success Rate**: 100% (8/8 jobs passing)
- **Policy Compliance**: 117/117 tests passing
- **Security Policies**: 3 network policies active
- **Namespaces**: 5 segregated namespaces
- **Replicas**: 3 application pods (high availability)
- **Cloud Infrastructure**: 2 t3.medium nodes
- **Deployment Time**: ~2m 20s per build

---

## 🔗 References

- [Kubernetes Best Practices](https://kubernetes.io/docs/)
- [HashiCorp Vault Documentation](https://www.vaultproject.io/)
- [Falco Security](https://falco.org/)
- [Argo CD](https://argoproj.github.io/cd/)
- [OpenTelemetry](https://opentelemetry.io/)
- [AWS EKS Best Practices](https://aws.github.io/aws-eks-best-practices/)
- [Trivy Vulnerability Scanner](https://github.com/aquasecurity/trivy)
- [OPA/Conftest](https://www.conftest.dev/)

---

## 👨‍💼 Author

**Jithendra Kantharaju**
- GitHub: [@Jithendra-Kantharaju](https://github.com/Jithendra-Kantharaju)
- LinkedIn: [Profile](https://linkedin.com/in/jithendra-kantharaju)

---

## 📄 License

This project is licensed under the MIT License - see LICENSE file for details.

---

## 🎉 Highlights

✨ **Production-Ready Implementation**
- All 8 DevSecOps features verified and working
- Complete automation from code to deployment
- Comprehensive security at every layer
- Full observability and audit trail
- Interview-ready documentation

📸 **Documented with Screenshots**
- 12+ verification screenshots
- Architecture diagram included
- Step-by-step deployment guide
- Real-world configuration examples

🚀 **Ready to Deploy**
- One-click Terraform infrastructure
- Automated EKS cluster creation
- GitOps-based deployments
- Zero-downtime updates

---

**Last Updated**: June 2026
**Status**: ✅ Production-Ready
**All 8 Features**: ✅ Verified and Documented
**Interview Ready**: ✅ YES

---

## 🙋 Questions?

For detailed explanations of how everything works, see:
- **[docs/PROJECT-DOCUMENTATION.md](docs/PROJECT-DOCUMENTATION.md)** - Complete architecture explanation, each feature detailed, and 10 interview questions with answers
- **[docs/SCREENSHOTS-GUIDE.md](docs/SCREENSHOTS-GUIDE.md)** - Guide for adding screenshots to GitHub
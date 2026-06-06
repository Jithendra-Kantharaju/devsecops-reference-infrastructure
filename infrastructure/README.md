# Infrastructure (Terraform)

Creates the AWS resources the CI/CD pipeline assumes exist:

- GitHub Actions OIDC provider + a least-privilege role (`iam-oidc.tf`)
- A multi-region CloudTrail trail + its S3 bucket (`cloudtrail.tf`)

```bash
cd infrastructure
terraform init
terraform apply -var="github_repo=OWNER/REPO"
# copy the github_actions_role_arn output into the AWS_ROLE_ARN repo secret
```

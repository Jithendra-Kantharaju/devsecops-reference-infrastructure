variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "github_repo" {
  description = "owner/repo allowed to assume the CI role via OIDC"
  type        = string
  default     = "Jithendra-Kantharaju/devsecops-reference-infrastructure"
}

variable "trail_name" {
  type    = string
  default = "tic-tac-toe-trail"
}

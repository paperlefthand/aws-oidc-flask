variable "aws_region" {
  description = "AWS region to deploy the infrastructure"
  type        = string
  default     = "ap-northeast-1"
}

variable "project" {
  description = "project id"
  type        = string
  default     = "oauth-flask"
}

variable "profile" {
  type     = string
  nullable = false
}





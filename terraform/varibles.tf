
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "AWS EC2 key pair name"
  type        = string
}

variable "worker_count" {
  description = "Number of Ansible worker nodes"
  type        = number
  default     = 2
}

variable "allowed_ssh_cidr" {
  description = "Allowed SSH source CIDR"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "instance_type" {
  description = "Instance type for VPN Box"
  type        = string
  default     = "t2.micro"
}

variable "ssh_keypair_name" {
  description = "SSH keypair name for the VPN instance"
}

variable "ssh_keypair_file_location" {
  description = "The local location of the SSH keypair"
}

variable "whitelisted_cidrs" {
  description = "List of allows IP CIDRs that can access Pritunl over HTTPs and SSH"
  type        = list(string)
}

variable "vpc_id" {
  description = "Which VPC VPN server will be created in"
}

variable "public_subnet_id" {
  description = "One of the public subnet id for the VPN instance"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "resource_name_prefix" {
  description = "All the resources will be prefixed with the value of this variable"
  default     = "pritunl"
}

variable "internal_cidrs" {
  description = "[List] IP CIDRs to whitelist in the pritunl's security group"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

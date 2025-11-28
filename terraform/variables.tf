variable "instance_id" {
  description = "enter ec2id"
  type        = string
}

variable "instance_az" {
  description = "enter the az"
  type        = string
}

variable "ebs_size_gb" {
  description = "EBS size in GB"
  type        = number
  default     = 1
}

variable "ebs_device_name" {
  description = "Device name to attach (maps to /dev/nvmeXn1 internally)"
  type        = string
  default     = "/dev/xvdb"
}
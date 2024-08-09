variable "listen_port" {
  type        = string
  default     = "443"
  description = "Port for the listener."
}

variable "target_port" {
  type        = string
  default     = "443"
  description = "Port for the target group."
}

variable "cluster_name" {
    description = "Name of the cluster."
}

variable "node_count" {
  type        = number
  description = "Number of nodes in the cluster."
}

variable "node_ids" {
  description = "List of node instance IDs."
}

variable "arn" {
  description = "LB-specific ARN"
}

variable "vpc_id" {
  description = "VPC ID"
}

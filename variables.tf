variable "input_tags" {
  description = "Map of tags to apply to resources"
  type        = map(string)
  default = {
    Developer   = "StratusGrid"
    Provisioner = "Terraform"
  }
}

variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
}

variable "workgroup_name" {
  description = "Name of the workgroup to use for the query and query results"
  type        = string
}

variable "database_name" {
  description = "Name of the database to use for the table creation"
  type        = string
}

variable "partition_table" {
  description = "Whether or not to create table partitioning. Recommended for large ALB sets"
  type        = bool
  default     = true
}

variable "query_name" {
  description = "Optionally provide a name for the saved query that creates the table"
  type        = string
  default     = ""
}

variable "table_name" {
  description = "Optionally provide a name for the table"
  type        = string
  default     = ""
}

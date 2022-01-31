variable "organization" {
  type        = string
  description = "The name for the organisation"
}

variable "project_name" {
  type        = string
  description = "Name of the Project"
}

variable "project_owner" {
  type        = string
  description = "Name of the Project Owner, For Example Jason Man or Guild-Hashicorp"
}

variable "project_contact_email" {
  type        = string
  description = "Email address to contact if there are questions"
}

variable "admin_member_emails" {
  type        = list(string)
  description = "A list of email addresses for users who should have admin rights on all workspaces"
}

variable "write_member_emails" {
  type        = list(string)
  description = "A list of email addresses for users who should have write rights on all workspaces"
  default     = []
}

variable "plan_member_emails" {
  type        = list(string)
  description = "A list of email addresses for users who should have plan rights on all workspaces"
  default     = []
}

variable "read_member_emails" {
  type        = list(string)
  description = "A list of email addresses for users who should have read rights on all workspaces"
  default     = []
}

variable "workspaces" {
  type = list(object({
    name              = string
    description       = string
    terraform_version = string
  }))
  description = "A list of Workspace objects to create"
}

locals {
  description_base = <<EOH
Project: ${var.project_name}
Owner: ${var.project_owner}
Email: ${var.project_contact_email}
    EOH
  admin_team_name  = "${var.project_name}-admin"
  write_team_name  = "${var.project_name}-write"
  plan_team_name   = "${var.project_name}-plan"
  read_team_name   = "${var.project_name}-read"

  admin_members = toset(var.admin_member_emails)
  write_members = toset(var.write_member_emails)
  plan_members  = toset(var.plan_member_emails)
  read_members  = toset(var.read_member_emails)

  formatted_project_name = replace(replace(var.project_name, "/[^a-zA-Z\\d\\-]/", "*"), "/[^a-zA-Z\\d\\-]+/", "-")

}

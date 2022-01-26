variable "name" {
  type        = string
  description = "The name for the organisation"
}

variable "project" {
  type = object({
    project_name          = string
    project_owner         = string
    project_contact_email = string
    admin_members         = list(string)
    write_members         = list(string)
    plan_members          = list(string)
    read_members          = list(string)
    workspaces = list(object({
      name              = string
      description       = string
      terraform_version = string
    }))
  })
}

locals {
  description_base = <<EOH
Project: ${var.project.project_name}
Owner: ${var.project.project_owner}
Email: ${var.project.project_contact_email}
    EOH
  admin_team_name  = "${var.project.project_name}-admin"
  write_team_name  = "${var.project.project_name}-write"
  plan_team_name   = "${var.project.project_name}-plan"
  read_team_name   = "${var.project.project_name}-read"

  admin_members = toset(var.project.admin_members)
  write_members = toset(var.project.write_members)
  plan_members  = toset(var.project.plan_members)
  read_members  = toset(var.project.read_members)

  formatted_project_name = replace(replace(var.project.project_name, "/[^a-zA-Z\\d\\-]/", "*"), "/[^a-zA-Z\\d\\-]+/", "-")

}

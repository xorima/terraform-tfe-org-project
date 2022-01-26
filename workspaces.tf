module "tag_project_name" {
  source       = "Xorima/tag-formatter/tfe"
  version      = "1.0.0"
  input_string = var.project.project_name
}
module "tag_project_owner" {
  source       = "Xorima/tag-formatter/tfe"
  version      = "1.0.0"
  input_string = var.project.project_owner
}

resource "tfe_workspace" "workspace" {
  for_each          = { for workspace in var.project.workspaces : workspace.name => workspace }
  name              = lower("${local.formatted_project_name}-${each.value.name}")
  organization      = var.name
  tag_names         = [lower("project:${module.tag_project_name.string}"), lower("owner:${module.tag_project_owner.string}")]
  description       = "${local.description_base}${each.value.description}"
  terraform_version = each.value.terraform_version
}

resource "tfe_team_access" "admin_access" {
  for_each     = tfe_workspace.workspace
  access       = "admin"
  team_id      = tfe_team.admin.id
  workspace_id = tfe_workspace.workspace[each.key].id
}
resource "tfe_team_access" "write_access" {
  for_each     = tfe_workspace.workspace
  access       = "write"
  team_id      = tfe_team.write[0].id
  workspace_id = tfe_workspace.workspace[each.key].id
}
resource "tfe_team_access" "plan_access" {
  for_each     = tfe_workspace.workspace
  access       = "plan"
  team_id      = tfe_team.plan[0].id
  workspace_id = tfe_workspace.workspace[each.key].id
}

resource "tfe_team_access" "read_access" {
  for_each     = tfe_workspace.workspace
  access       = "read"
  team_id      = tfe_team.read[0].id
  workspace_id = tfe_workspace.workspace[each.key].id
}
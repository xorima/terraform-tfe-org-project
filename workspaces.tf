module "tag_project_name" {
  source       = "Xorima/tag-formatter/tfe"
  version      = "1.0.0"
  input_string = var.project_name
}
module "tag_project_owner" {
  source       = "Xorima/tag-formatter/tfe"
  version      = "1.0.0"
  input_string = var.project_owner
}

resource "tfe_workspace" "workspace" {
  for_each          = { for workspace in var.workspaces : workspace.name => workspace }
  name              = lower("${local.formatted_project_name}-${each.value.name}")
  organization      = var.organization
  tag_names         = [lower("project:${module.tag_project_name.string}"), lower("owner:${module.tag_project_owner.string}")]
  description       = "${local.description_base}${each.value.description}"
  terraform_version = each.value.terraform_version
  lifecycle {
    ignore_changes = [
      remote_state_consumer_ids, trigger_prefixes, working_directory, vcs_repo
    ]
  }
}

resource "tfe_team_access" "admin_access" {
  for_each     = tfe_workspace.workspace
  access       = "admin"
  team_id      = tfe_team.admin.id
  workspace_id = tfe_workspace.workspace[each.key].id
}
resource "tfe_team_access" "write_access" {
  # Foreach logic exists to ensure we only try to do this if we have users to add. If we do not do this we get empty tuple errors
  for_each     = { for workspace in tfe_workspace.workspace : workspace.name => workspace if length(var.write_member_emails) != 0}
  access       = "write"
  team_id      = tfe_team.write[0].id
  workspace_id = each.value.id
}
resource "tfe_team_access" "plan_access" {
  for_each     = { for workspace in tfe_workspace.workspace : workspace.name => workspace if length(var.plan_member_emails) != 0}
  access       = "plan"
  team_id      = tfe_team.plan[0].id
  workspace_id = each.value.id
}

resource "tfe_team_access" "read_access" {
  for_each     = { for workspace in tfe_workspace.workspace : workspace.name => workspace if length(var.read_member_emails) != 0}
  access       = "read"
  team_id      = tfe_team.read[0].id
  workspace_id = each.value.id
}

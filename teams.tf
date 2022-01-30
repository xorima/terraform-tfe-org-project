# There must always be an admin team, even if it is empty
resource "tfe_team" "admin" {
  name         = local.admin_team_name
  organization = var.organization
}

data "tfe_organization_membership" "admin_team_member" {
  for_each     = local.admin_members
  organization = var.organization
  email        = each.key
}

resource "tfe_team_organization_member" "admin_team_members" {
  for_each                   = data.tfe_organization_membership.admin_team_member
  team_id                    = tfe_team.admin.id
  organization_membership_id = each.value.id
}

# Only create additional permission teams if required
resource "tfe_team" "write" {
  count        = length(local.write_members) == 0 ? 0 : 1
  name         = local.write_team_name
  organization = var.organization
}
data "tfe_organization_membership" "write_team_member" {
  for_each     = local.write_members
  organization = var.organization
  email        = each.key
}
resource "tfe_team_organization_member" "write_team_member" {
  for_each                   = data.tfe_organization_membership.write_team_member
  team_id                    = tfe_team.write[0].id
  organization_membership_id = each.value.id
}

resource "tfe_team" "plan" {
  count        = length(var.plan_member_emails) == 0 ? 0 : 1
  name         = local.plan_team_name
  organization = var.organization
}
data "tfe_organization_membership" "plan_team_member" {
  for_each     = local.plan_members
  organization = var.organization
  email        = each.key
}

resource "tfe_team_organization_member" "plan_team_member" {
  for_each                   = data.tfe_organization_membership.plan_team_member
  team_id                    = tfe_team.plan[0].id
  organization_membership_id = each.value.id
}


resource "tfe_team" "read" {
  count        = length(var.read_member_emails) == 0 ? 0 : 1
  name         = local.read_team_name
  organization = var.organization
}
data "tfe_organization_membership" "read_team_member" {
  for_each     = local.read_members
  organization = var.organization
  email        = each.key
}

resource "tfe_team_organization_member" "read_team_member" {
  for_each                   = data.tfe_organization_membership.read_team_member
  team_id                    = tfe_team.read[0].id
  organization_membership_id = each.value.id
}

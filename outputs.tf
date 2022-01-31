output "workspaces" {
  value = { for k, v in tfe_workspace.workspace : k => v }
}

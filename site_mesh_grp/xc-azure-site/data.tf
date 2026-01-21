# Read outputs from azure-infrastructure workspace
data "terraform_remote_state" "azure_infra" {
  backend = "remote"

  config = {
    organization = "jeremieonk"

    workspaces = {
      name = "azure_autos"
    }
  }
}

# Also read AWS infrastructure for tunnel config
data "terraform_remote_state" "aws_infra" {
  backend = "remote"

  config = {
    organization = "jeremieonk"

    workspaces = {
      name = "titas"
    }
  }
}

# Read outputs from aws-infrastructure workspace
data "terraform_remote_state" "aws_infra" {
  backend = "remote"

  config = {
    organization = "jeremieonk" # 
    workspaces = {
      name = "titas"
    }
  }
}

# Also read Azure infrastructure if you need it for tunnel config
data "terraform_remote_state" "azure_infra" {
  backend = "remote"

  config = {
    organization = "jeremieonk"

    workspaces = {
      name = "azure_autos"
    }
  }
}

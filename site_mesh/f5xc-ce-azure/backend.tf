terraform {
  backend "remote" {
    organization = "jeremieonk"

    workspaces {
      name = "azure_autos"
    }
  }
}

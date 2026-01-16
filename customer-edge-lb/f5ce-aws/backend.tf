terraform {
  backend "remote" {
    organization = "jeremieonk"

    workspaces {
      name = "titas"
    }
  }
}

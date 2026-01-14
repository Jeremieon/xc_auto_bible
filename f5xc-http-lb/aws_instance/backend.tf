terraform {
  backend "remote" {
    organization = "jeremieonk"

    workspaces {
      name = "xc_auto_bible"
    }
  }
}

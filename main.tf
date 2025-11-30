terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = ">= 2.0.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.0.0"
    }
  }
}

provider "local" {}
provider "null" {}

resource "null_resource" "create_network" {
  provisioner "local-exec" {
    command     = "bash scripts/create_network.sh"
    interpreter = ["/bin/bash", "-c"]
  }
}

resource "null_resource" "deploy_podman" {
  depends_on = [null_resource.create_network]

  provisioner "local-exec" {
    command     = "bash scripts/deploy.sh"
    interpreter = ["/bin/bash", "-c"]
  }
}

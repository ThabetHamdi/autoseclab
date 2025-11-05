terraform {
required_providers {
local = {
source = "hashicorp/local"
version = ">= 2.0.0"
}
}
}


provider "local" {}


resource "local_file" "create_network" {
content = file("scripts/create_network.sh")
filename = "${path.module}/scripts/create_network.sh"
}


resource "null_resource" "deploy_podman" {
provisioner "local-exec" {
command = "bash scripts/deploy.sh"
interpreter = ["/bin/bash","-c"]
}
}

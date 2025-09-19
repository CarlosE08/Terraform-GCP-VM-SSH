variable "project" {}
variable "region" {}
variable "zone" {}

variable "machine_type" {
  type    = string
  default = "e2-micro" # Ver tipos de máquinas en https://cloud.google.com/compute/docs/machine-types
}

variable "image" {
  type    = string
  default = "debian-cloud/debian-11" # Formato: "project/image-family" (Ver https://cloud.google.com/compute/docs/images)
}

variable "ssh_key_path" {
  type    = string
  default = "./.SSH/prueba.pub" # Ruta a la llave pública SSH (Ver instrucciones en main.tf)
}

variable "common_tags" {
  type = map(string)
  default = {
    "owner"    = "Carlos Escobar"
    "project"  = "prueba-ssh"
    "customer" = "Forticus"
  }
}
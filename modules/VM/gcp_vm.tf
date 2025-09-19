
# Regla de firewall para permitir SSH sólo desde tu IP
resource "google_compute_firewall" "ssh_personal" {
  name    = "ssh-solo-carlos"
  network = var.vpc_name # Cambiar a var

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["187.190.205.0/32"] # Reemplaza con la IP desde la que te conectarás
  direction     = "INGRESS"
  target_tags   = ["ssh-access"]
}

# Instancia en la subred pública y la ip fija:
resource "google_compute_instance" "vm_publica" {
  name         = "vm-publica"
  machine_type = var.machine_type
  zone         = var.zone

  tags = ["publica", "ssh-access"]

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    subnetwork = var.public_subnet_id
    access_config {
      nat_ip = var.static_ip
    }
  }

  metadata = {
    ssh-keys = "carlos:${file(var.ssh_key_path)}"
  }
}

# Conectarse a la VM (dentro de la tarjeta que contiene la llave SSH privada): ssh -i prueba carlos@ip_publica
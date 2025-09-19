
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


# Regla de firewall: permitir ICMP (ping) SOLO desde la VM pública
resource "google_compute_firewall" "allow_icmp_from_public" {
  name    = "icmp-desde-publica"
  network = var.vpc_name

  allow {
    protocol = "icmp"
  }

  # Solo permite ping de instancias con el tag "publica"
  source_tags = ["publica"]
  target_tags = ["privada"]
  direction   = "INGRESS"
}

# Instancia privada en la subred privada
resource "google_compute_instance" "vm_privada" {
  name         = "vm-privada"
  machine_type = var.machine_type
  zone         = var.zone

  tags = ["privada"]

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    subnetwork = var.private_subnet_id # No se define access_config → sin IP pública
  }

  metadata = {
    ssh-keys = "carlos:${file(var.ssh_key_path)}"
  }
}

output "vm_privada_internal_ip" {
  description = "Dirección IP interna de la VM privada"
  value       = google_compute_instance.vm_privada.network_interface[0].network_ip
}

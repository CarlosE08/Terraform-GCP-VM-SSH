resource "google_compute_network" "vpc_demo" {
  name                    = "vpc-demo"
  auto_create_subnetworks = false
  description             = "VPC personalizada para demo"
}

# Subred privada
resource "google_compute_subnetwork" "subnet_privada" {
  name          = "subnet-privada"
  ip_cidr_range = "10.10.2.0/24"
  region        = var.region
  network       = google_compute_network.vpc_demo.id
}

# Subred pública
resource "google_compute_subnetwork" "subnet_publica" {
  name          = "subnet-publica"
  ip_cidr_range = "10.10.1.0/24"
  region        = var.region
  network       = google_compute_network.vpc_demo.id
}

# Ruta a Internet, SOLO para instancias con tag "publica"
resource "google_compute_route" "ruta_internet" {
  name             = "ruta-internet"
  network          = google_compute_network.vpc_demo.name
  dest_range       = "0.0.0.0/0"
  next_hop_gateway = "default-internet-gateway"
  priority         = 1000
  tags             = ["publica"]
}

# Dirección IP fija para recursos públicos
resource "google_compute_address" "static_ip" {
  name   = "mi-ip-fija"
  region = var.region
}

# Router para Cloud NAT
resource "google_compute_router" "router_nat" {
  name    = "router-nat"
  network = google_compute_network.vpc_demo.id
  region  = var.region
}

# Configuración de Cloud NAT para subred privada
resource "google_compute_router_nat" "nat_privada" {
  name   = "nat-privada"
  router = google_compute_router.router_nat.name
  region = var.region

  nat_ip_allocate_option = "AUTO_ONLY"

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.subnet_privada.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

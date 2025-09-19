output "vpc_name" {
  description = "The name of the VPC"
  value       = google_compute_network.vpc_demo.name
}

output "public_subnet_id" {
  description = "List of subnet IDs"
  value       = google_compute_subnetwork.subnet_publica.id
}

output "private_subnet_id" {
  description = "List of subnet IDs"
  value       = google_compute_subnetwork.subnet_privada.id
}

output "static_ip" {
  description = "Static IP address"
  value       = google_compute_address.static_ip.address
}

output "tags" {
  description = "Tags for firewall rules"
  value       = google_compute_route.ruta_internet.tags
}


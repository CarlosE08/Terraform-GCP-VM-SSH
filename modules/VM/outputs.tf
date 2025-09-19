output "vm_privada_internal_ip" {
  description = "Dirección IP interna de la VM privada"
  value       = google_compute_instance.vm_privada.network_interface[0].network_ip
}
# output "tags" {
#   value = "Las siguientes son las etiquetas que tienen todos los recursos: ${var.common_tags}"
# }

output "ip_publica" {
  value = "La IP para la conexion publica es: ${module.vpc.static_ip}"
}

output "ip_privada" {
  value = "La IP privada de la VM privada es: ${module.vm.vm_privada_internal_ip}"
  
}

# output "route_tags" {
#   description = "Tags for the route to allow internet access"
#   value       = module.vpc.tags
# }
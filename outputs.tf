output "tags" {
  value = "Las siguientes son las etiquetas que tienen todos los recursos: ${module.vpc.tags}"
}

output "ip_publica" {
  value = "La IP para la conexion publica es: ${module.vm.static_ip}"
}

# output "route_tags" {
#   description = "Tags for the route to allow internet access"
#   value       = module.vpc.tags
# }
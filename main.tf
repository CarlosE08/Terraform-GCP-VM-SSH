
module "vpc" {
  source = "./modules/VPC"
  region = var.region
}

module "vm" {
  source       = "./modules/VM"
  # Variables para levantar la VM en la zona, tipo de máquina, imagen y llave SSH (con la que nos conectaremos)
  zone         = var.zone
  machine_type = var.machine_type
  image        = var.image
  ssh_key_path = var.ssh_key_path

  # Variables para conectar la VM a la VPC
  vpc_name         = module.vpc.vpc_name
  public_subnet_id = module.vpc.public_subnet_id
  static_ip        = module.vpc.static_ip

  # Para conectar la VM privada a la subred privada
  private_subnet_id = module.vpc.private_subnet_id

  # Etiquetas comunes
  common_tags = var.common_tags
}

# Las etiquetas nos sirven para identificar recursos en la nube. 
# Nos permiten filtrar recursos en la consola de GCP y también para asignar políticas de IAM basadas en etiquetas.


# Para generar la llave SSH (si no tienes una):
# ssh-keygen -t rsa -b 2048 -f .SSH/prueba -C "carlos" 
  # Siendo "carlos" el usuario con el que te conectarás a la VM
  # Si se desea guardar en otra ruta, cambiar ".SSH/prueba" por la ruta deseada

# Esto genera dos archivos: prueba (llave privada) y prueba.pub (llave pública), 
# siendo esta última la que se usa en el metadata de la VM para permitir la conexión SSH (revisar "modules/VM/gcp_vm.tf", línea 38)
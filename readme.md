# Proyecto Terraform en GCP: VPC y VMs Pública y Privada

Este proyecto crea una **VPC personalizada** en Google Cloud Platform (GCP) con subredes **pública y privada**, una **VM pública con IP fija** y una **VM privada accesible únicamente desde la VM pública**.

---

## Estructura del proyecto

```
.
├── main.tf
├── variables.tf
├── outputs.tf
├── modules/
│   ├── VPC/
│   │   ├── gcp_vpc.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── VM/
│       ├── gcp_vm.tf
│       ├── variables.tf
│       └── outputs.tf
└── .SSH/           # Carpeta para llaves SSH
```

---

## Recursos que crea

### Red y subredes
- **VPC personalizada** (`vpc-demo`)
- **Subred pública** (`subnet-publica`) con acceso a Internet
- **Subred privada** (`subnet-privada`) con Cloud NAT para salida a Internet
- **IP estática** para la VM pública
- **Firewall** que permite:
  - SSH desde tu IP a la VM pública
  - ICMP (ping) desde la VM pública a la privada

### Instancias
- **VM pública**
  - Con IP fija
  - Conectable por SSH desde tu IP
  - Etiquetada `publica` y `ssh-access`
- **VM privada**
  - Solo accesible desde la VM pública (ping y opcionalmente SSH)
  - Etiquetada `privada`

---

## Requisitos

- Terraform >= 1.5
- Cuenta en Google Cloud Platform con permisos para:
  - Crear VPC, subredes y rutas
  - Crear instancias y direcciones IP
  - Configurar firewall y Cloud NAT
- SSH (para conectarte a las VM)

---

## Preparar llaves SSH

Genera la llave si no tienes una:

```bash
ssh-keygen -t rsa -b 2048 -f .SSH/prueba -C "carlos"
```

Esto genera:
- `.SSH/prueba` → llave privada
- `.SSH/prueba.pub` → llave pública que se usará en las VMs

---

## Uso

1. Inicializa Terraform:

```bash
terraform init
```

2. Revisa el plan:

```bash
terraform plan
```

3. Aplica la infraestructura:

```bash
terraform apply
```

4. Obtén la IP privada de la VM privada:

```bash
terraform output vm_privada_internal_ip
```

5. Conéctate a la VM pública:

```bash
ssh -i .SSH/prueba carlos@<IP_PUBLICA>
```

6. Desde la VM pública, prueba la conectividad con la privada:

```bash
ping <IP_PRIVADA>
```

---

## Variables principales

- `region`: Región de GCP donde se desplegará la VPC y las VMs
- `zone`: Zona donde se creará cada instancia
- `machine_type`: Tipo de máquina (ej. `e2-medium`)
- `image`: Imagen de la VM (ej. `debian-12-bullseye-v20230905`)
- `ssh_key_path`: Ruta a la llave privada SSH
- `common_tags`: Etiquetas comunes para los recursos
- `vpc_name`, `public_subnet_id`, `private_subnet_id`, `static_ip`: Valores provenientes del módulo VPC

---

## Outputs

- `vm_publica_ip` → IP pública de la VM pública
- `vm_privada_internal_ip` → IP interna de la VM privada

---

## Buenas prácticas

- Mantener las llaves SSH en `.SSH/` y agregar la carpeta al `.gitignore`:
  ```
  .SSH/*
  !.SSH/
  ```
- No exponer la VM privada directamente a Internet.
- Usar Cloud NAT para permitir que la VM privada tenga salida a Internet si es necesario.

---

## Contacto

Proyecto creado por **Carlos Escobar** para pruebas de Terraform y GCP.

# Exercici 2 — VPC personalitzada i 6 instàncies EC2 amb Terraform

| | |
|---|---|
| **Alumne** | Marc Hernandez Dominguez |
| **Mòdul** | Cloud Computing (ASIX2) |
| **Repositori** | [practiquescloud](https://github.com/MarcOrnstein/practiquescloud) |
| **Tecnologia** | Terraform + AWS |
| **Data** | Octubre de 2026 |

---

## 1. Objectiu

L'objectiu d'aquest exercici és desplegar de manera automàtica, amb **Terraform**, una infraestructura AWS que comprovi els conceptes de xarxa virtual privada (VPC), subxarxes i instàncies EC2 a la regió `us-east-1`:

- **VPC personalitzada** amb CIDR `10.0.0.0/16`.
- **3 subxarxes** associades a la mateixa Zona de Disponibilitat (`us-east-1a`) amb CIDRs `10.0.1.0/24`, `10.0.2.0/24` i `10.0.3.0/24`.
- **6 instàncies EC2** de tipus `t3.micro` amb Amazon Linux 2023, 2 desplegades a cada una de les 3 subxarxes.
- Sortides (`output`) amb els IDs de la VPC, subxarxes i instàncies.

Amb aquest exercici es practiquen els conceptes d **Infraestructura com a Codi (IaC)**: definir recursos en fitxers de configuració, planificar els canvis i aplicar-los de forma reproduïble.

---

## 2. Part A — Disseny de Xarxa i càlculs

### Topologia de la xarxa

![Topologia de la infraestructura](assets/topologia.png?v=2)

### Càlculs de subxarxes

La VPC utilitza el bloc CIDR `10.0.0.0/16`, el qual permet `2^16 - 2 = 65.534` adreces IP. S'han creat 3 subxarxes amb blocs /24, cada una amb `2^24 - 2 = 16.777.214` adreces IP:

| Subxarxa | CIDR | IP inicial | IP final |
|---|---|---|---|
| Subnet 1 | `10.0.1.0/24` | `10.0.1.1` | `10.0.1.254` |
| Subnet 2 | `10.0.2.0/24` | `10.0.2.1` | `10.0.2.254` |
| Subnet 3 | `10.0.3.0/24` | `10.0.3.1` | `10.0.3.254` |

Cada subxarxa està situada a la **Zona de Disponibilitat `us-east-1a`**. totes les instàncies EC2 tenen activat l'IP pública assignada automàticament (`map_public_ip_on_launch = true`) per permettre l'accès Internet sense necessitat d'una gateway externa en aquest exercici bàsic.

---

## 3. Part B — Desplegament manual per la Consola d'AWS

Accedir a la consola d'AWS i seguir els següents passos:

1. **Crear una VPC nova** amb CIDR `10.0.0.0/16` i activar les hostnames DNS.
2. **Crear 3 subxarxes** a la zona `us-east-1a` amb els CIDRs corresponents (`10.0.1.0/24`, `10.0.2.0/24`, `10.0.3.0/24`) i activar l'assignació d IP pública.
3. **Llegir les captures**:

   - `vpc_subnets.png`: Mostra la VPC amb les 3 subxarxes i els seus CIDRs.
   - `ec2_instances.png`: Mostra les 6 instàncies EC2 desplegades a les diferents subxarxes.

4. **Desplegar 6 instàncies EC2** de tipus `t3.micro` amb Amazon Linux 2023, assignant-les a les respectives subxarxes i activant l'IP pública.

5. **Verificar els outputs** des del consola o utilitzant el `aws ec2 describe-instances`.

Després de finir, recordeu eliminar els recursos per evitar costos adicionals.

---

## 4. Part C — Desplegament amb Terraform

### Instruccions detallades pas a pas

Totes les comandes s'executen des de la carpeta `pt1-4-ex2/`:

```bash
cd pt1-4-ex2
```

### Pas 1 — Inicialitzar el projecte

Descarrega el provider d'AWS i crea el directori `.terraform/`:

```bash
terraform init
```

### Pas 2 — Format i validació (opcional però recomanat)

```bash
terraform fmt
terraform validate
```

### Pas 3 — Planificar els canvis

Mostra què creara Terraform sense aplicar cap canvi a AWS:

```bash
terraform plan
```

Revisa que el pla inclogui **6 instàncies** `t3.micro`, **3 subxarxes** i la **VPC**. Deuria mostrar un resultat semblant a:

```
Plan: 6 to add, 0 to change, 0 to destroy
```

### Pas 4 — Aplicar la configuració

Crea la infraestructura real a AWS. Cal confirmar amb `yes`:

```bash
terraform apply
```

Alternativament, sense confirmació interactiva:

```bash
terraform apply -auto-approve
```

En acabar, Terraform mostra els outputs, per exemple:

```text
Apply complete! Resources: 6 added, 0 changed, 0 destroyed.

Outputs:

vpc_id = vpc-0abc1234
subnet_ids = [
  "subnet-0a1b2c3d",
  "subnet-0e4f5g6h",
  "subnet-0i7j8k9l",
]

instance_ids = [
  "i-0a1b2c3d4e5f6g7h8",
  "i-0b2c3d4e5f6g7h8i9",
  "i-0c3d4e5f6g7h8i9j0",
  "i-0d4e5f6g7h8i9j0k1",
  "i-0e5f6g7h8i9j0k1l2",
  "i-0f6g7h8i9j0k1l2m3",
]
```

Es poden tornar a consultar en qualsevol moment amb:

```bash
terraform output
terraform output vpc_id
terraform output subnet_ids
terraform output instance_ids
```

### Pas 5 — Comprovar el desplegament (opcional)

```bash
aws ec2 describe-instances \
  --region us-east-1 \
  --filters "Name=vpc-id,Equals=vpc-0abc1234" \
  --query "Reservations[].Instances[].{ID:InstanceId,Subnet:SubnetId,IP:PublicIpAddress,Type:InstanceType,State:State.Name}" \
  --output table
```

### Pas 6 — Destruir la infraestructura

Quant s'acabi l'exercici, **cal eliminar els recursos** per evitar costos:

```bash
terraform destroy
```

O bé, sense confirmació interactiva:

```bash
terraform destroy -auto-approve
```

Comprova que la sortida sigui `Destroy complete! Resources: 6 destroyed.`

---

## 5. Seccions d'imatges

Les següents images s'han de ubicar en la carpeta `assets/`:

![Topologia de la infraestructura](assets/topologia.png?v=2)

![Subxarxes de la VPC](assets/vpc_subnets.png?v=2)

![Instàncies EC2](assets/ec2_instances.png?v=2)

---

## 6. Requisits previs

1. **Terraform** instal·lat (versió `>= 1.5`):

   ```bash
   terraform version
   ```

2. **AWS CLI** configurada amb unes credencials vàlides i permisos per crear VPC, subxarxes i instàncies EC2:

   ```bash
   aws configure
   aws sts get-caller-identity
   ```

   Les credencials **no** s'han de pujar mai al repositori.

3. Connexió a Internet perquè Terraform descarregui el provider `hashicorp/aws`.

4. Un compte d'AWS amb permisos per crear recursos a la regió `us-east-1`.

---

## 7. Neteja de fitxers locals

Terraform genera fitxers i directoris que **no** s'han de versionar (`.terraform/`, `terraform.tfstate*`, `.terraform.lock.hcl` és opcional). El projecte ja inclou un `.gitignore` (heretat de la raïz o de l'exercici 1) amb:

```gitignore
.terraform/
*.tfstate
*.tfstate.*
crash.log
*.tfvars
```

> ⚠️ El fitxer `terraform.tfstate` pot contenir informació sensible. En entorns reals es recomana desar l'estat en un backend remot (per exemple, S3).

---

## 8. Costos

Les instàncies `t3.micro` són elegibles per al **nivell gratuït** d'AWS (750 hores/mes durant els primers 12 mesos). Aquest exercici despliega **6 instàncies**, consumint 6 x 750 = 4.500 hores/mes si s'executen 24/7. Per tant, es recomana executar `terraform destroy` en acabar l'exercici o deixar-les apaguades mitjançant les funcions d'AWS.

---

## 9. Resum de recursos creats

| Nom | Tipus | Descripció |
|---|---|---|
| `aws_vpc.ex2_vpc` | `vpc` | VPC personalitzada CIDR `10.0.0.0/16` |
| `aws_subnet.ex2_subnet1` | `subnet` | Subnet 1 CIDR `10.0.1.0/24`, AZ `us-east-1a` |
| `aws_subnet.ex2_subnet2` | `subnet` | Subnet 2 CIDR `10.0.2.0/24`, AZ `us-east-1a` |
| `aws_subnet.ex2_subnet3` | `subnet` | Subnet 3 CIDR `10.0.3.0/24`, AZ `us-east-1a` |
| `aws_instance.ex2_subnet1_instances[0]` | `instance` | Instància 1, `t3.micro`, subnet 1 |
| `aws_instance.ex2_subnet1_instances[1]` | `instance` | Instància 2, `t3.micro`, subnet 1 |
| `aws_instance.ex2_subnet2_instances[0]` | `instance` | Instància 3, `t3.micro`, subnet 2 |
| `aws_instance.ex2_subnet2_instances[1]` | `instance` | Instància 4, `t3.micro`, subnet 2 |
| `aws_instance.ex2_subnet3_instances[0]` | `instance` | Instància 5, `t3.micro`, subnet 3 |
| `aws_instance.ex2_subnet3_instances[1]` | `instance` | Instància 6, `t3.micro`, subnet 3 |

**Entorn:** regió `us-east-1` (N. Virginia)

**Outputs:** `vpc_id`, `subnet_ids`, `instance_ids`

---

**Autor: Marc Hernandez Dominguez — ASIX2, Cloud Computing.**
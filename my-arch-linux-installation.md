# Instalación de Arch Linux

---

## Especificaciones del equipo

| Componente | Detalle |
|---|---|
| **Modelo** | Slimbook EVO (EVO15-A8) |
| **CPU** | AMD Ryzen 7 8845HS (16) @ 5.14 GHz |
| **GPU** | AMD Radeon 780M Graphics |
| **RAM** | 64 GB |
| **Almacenamiento** | Samsung SSD 990 PRO 4TB (NVMe) |
| **Pantalla** | 2560×1600 @ 120 Hz |

---

## 1. Teclado y consola

```bash
# Teclado español
loadkeys es

# Fuente más grande para alta densidad
setfont ter-132b
```

---

## 2. Red (Wi-Fi)

```bash
# Iniciar iwctl (Wi-Fi)
iwctl
  # Listar interfaces de red
  device list
  # Escanear redes Wi-Fi
  station wlan0 get-networks
  # Conectarse a la red
  station wlan0 connect SSID
  # Salir de iwctl
  exit
```

```bash
# Verificar conexión a internet
ping -c 3 archlinux.org
```

---

## 3. Hora

```bash
# Activar sincronización NTP
timedatectl set-ntp true

# Establecer zona horaria
timedatectl set-timezone Europe/Madrid

# Verificar hora y fecha
timedatectl status
```

---

## 4. Limpieza del disco

Limpia todas las firmas y la tabla de particiones del disco.

```bash
# Borrar firmas de filesystem/LVM
wipefs -a /dev/nvme0n1

# Limpiar tabla de particiones
sgdisk --zap-all /dev/nvme0n1
```

---

## 5. Particionado

```bash
fdisk /dev/nvme0n1
```

| Comando | Acción |
|---|---|
| `g` | Crear tabla GPT |
| `n` → Enter → Enter → `+2G` | Partición EFI (2 GiB) |
| `t` → `1` | Tipo EFI System |
| `n` → Enter → Enter → Enter | Partición sistema (resto) |
| `w` | Escribir y salir |

### Tabla de particiones resultante

| Partición | Tamaño | Tipo |
|---|---|---|
| `nvme0n1p1` | 2 GiB | EFI System (FAT32) |
| `nvme0n1p2` | Resto | Linux filesystem (LUKS + btrfs) |

---

## 6. Cifrado LUKS

Cifra la partición del sistema y abre el volumen.

```bash
# Crear volumen LUKS
cryptsetup -v luksFormat /dev/nvme0n1p2

# Abrir volumen como /dev/mapper/cryptroot
cryptsetup open /dev/nvme0n1p2 cryptroot
```

---

## 7. Formateo y subvolúmenes btrfs

Formatea la partición EFI y el volumen cifrado como btrfs con subvolúmenes.

```bash
# Formatear partición EFI
mkfs.fat -F32 /dev/nvme0n1p1

# Formatear volumen cifrado como btrfs
mkfs.btrfs -L cryptroot /dev/mapper/cryptroot
```

### Crear subvolúmenes

```bash
# Montar btrfs completo para crear subvols
mount /dev/mapper/cryptroot /mnt

# Subvolumen raíz
btrfs subvolume create /mnt/@

# Subvolumen /home
btrfs subvolume create /mnt/@home

# Subvolumen /var/log
btrfs subvolume create /mnt/@log

# Subvolumen /var/cache/pacman/pkg
btrfs subvolume create /mnt/@pkg

# Desmontar para remontar con subvols
umount /mnt
```

### Montar con optimizaciones

```bash
# Raíz
mount -o noatime,ssd,compress=zstd,space_cache=v2,discard=async,subvol=@ /dev/mapper/cryptroot /mnt

# /home
mount --mkdir -o noatime,ssd,compress=zstd,space_cache=v2,discard=async,subvol=@home /dev/mapper/cryptroot /mnt/home

# Logs
mount --mkdir -o noatime,ssd,compress=zstd,space_cache=v2,discard=async,subvol=@log /dev/mapper/cryptroot /mnt/var/log

# Caché pacman
mount --mkdir -o noatime,ssd,compress=zstd,space_cache=v2,discard=async,subvol=@pkg /dev/mapper/cryptroot /mnt/var/cache/pacman/pkg

# EFI sin cifrar
mount /dev/nvme0n1p1 /mnt/boot
```

### Resumen de capas

| Capa | Dispositivo | Filesystem | Punto de montaje |
|---|---|---|---|
| Partición | `/dev/nvme0n1p1` | FAT32 | `/boot` |
| Partición | `/dev/nvme0n1p2` | LUKS2 | — |
| Mapper | `/dev/mapper/cryptroot` | btrfs | — |
| Subvolumen `@` | `/dev/mapper/cryptroot` | btrfs | `/` |
| Subvolumen `@home` | `/dev/mapper/cryptroot` | btrfs | `/home` |
| Subvolumen `@log` | `/dev/mapper/cryptroot` | btrfs | `/var/log` |
| Subvolumen `@pkg` | `/dev/mapper/cryptroot` | btrfs | `/var/cache/pacman/pkg` |
---

## 8. Actualizar mirrors

```bash
# Obtener mirrors más rápidos
reflector --country Spain --latest 10 --protocol http,https --sort rate --save /etc/pacman.d/mirrorlist
```

---

## 9. Instalación base

| Paquete | Propósito |
|---|---|
| `base` | Sistema base mínimo de Arch Linux |
| `linux` | Kernel Linux |
| `linux-firmware` | Firmware para hardware |
| `amd-ucode` | Microcode para CPU AMD Ryzen |
| `btrfs-progs` | Herramientas para gestionar btrfs |
| `cryptsetup` | Descifrar LUKS al arrancar |
| `vim` | Editor de texto |
| `limine` | Bootloader |
| `iwd` | Conexión Wi-Fi (iwctl) |

```bash
pacstrap -K /mnt base linux linux-firmware amd-ucode btrfs-progs cryptsetup vim limine iwd
```

---

## 10. Generar fstab

```bash
# Generar fstab
genfstab -U /mnt >> /mnt/etc/fstab
```

---

## 11. Entrar al sistema (chroot)

```bash
# Entrar al sistema instalado
arch-chroot /mnt
```

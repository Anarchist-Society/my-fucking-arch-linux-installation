# Instalación de Arch Linux

> **Introducción** — Esta guía documenta mi instalación de Arch Linux con cifrado LUKS2 + btrfs con subvolúmenes y Limine como bootloader en un sistema UEFI. No sustituye [la guía oficial de instalación](https://wiki.archlinux.org/title/Installation_guide), sino que es una versión condensada adaptada a mi hardware. El ESP (FAT32) no está cifrado y se monta como `/boot`. La red se configura con iwd + systemd-networkd.

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

## Preparación

### Teclado y consola

```bash
# Teclado español
loadkeys es

# Fuente más grande para alta densidad
setfont ter-132b
```

### Red (Wi-Fi)

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

### Hora

```bash
# Activar sincronización NTP
timedatectl set-ntp true

# Establecer zona horaria
timedatectl set-timezone Europe/Madrid

# Verificar hora y fecha
timedatectl status
```

### Limpieza del disco

Limpia todas las firmas y la tabla de particiones del disco.

```bash
# Borrar firmas de filesystem/LVM
wipefs --all /dev/nvme0n1

# Limpiar tabla de particiones
sgdisk --zap-all /dev/nvme0n1
```

---

## Particionado del disco

```bash
# Particionar el disco con fdisk
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

## Formatear la partición EFI

```bash
# Formatear partición EFI como FAT32
mkfs.fat -F32 /dev/nvme0n1p1
```

---

## Preparar la partición del sistema

### Crear el volumen cifrado LUKS

Cifra la partición del sistema y abre el volumen.

```bash
# Crear volumen LUKS
cryptsetup -v luksFormat /dev/nvme0n1p2

# Abrir volumen como /dev/mapper/cryptroot
cryptsetup open /dev/nvme0n1p2 cryptroot
```

### Crear la estructura btrfs

Formatea el volumen cifrado como btrfs con subvolúmenes.

```bash
# Formatear volumen cifrado como btrfs
mkfs.btrfs -L cryptroot /dev/mapper/cryptroot
```

#### Crear subvolúmenes

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

#### Montar con optimizaciones

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

#### Resumen de capas

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

## Instalar Arch Linux

### Actualizar mirrors

```bash
# Obtener mirrors más rápidos
reflector --country Spain --latest 10 --protocol http,https --sort rate --save /etc/pacman.d/mirrorlist
```

### Instalación base

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
# Instalar sistema base
pacstrap -K /mnt base linux linux-firmware amd-ucode btrfs-progs cryptsetup vim limine iwd
```

### Generar fstab

```bash
# Generar fstab
genfstab -U /mnt >> /mnt/etc/fstab
```

### Entrar al sistema (chroot)

```bash
# Entrar al sistema instalado
arch-chroot /mnt
```

### Zona horaria

```bash
# Establecer zona horaria
ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime

# Sincronizar reloj hardware
hwclock --systohc
```

### Localización

```bash
# Generar locale español
echo "es_ES.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen

# Configurar idioma del sistema
echo "LANG=es_ES.UTF-8" > /etc/locale.conf

# Configurar teclado en consola
echo "KEYMAP=es" > /etc/vconsole.conf
```

### Hostname

```bash
# Establecer nombre del equipo
echo "penguin" > /etc/hostname
```

### Initramfs

Configura el initramfs para que pueda descifrar el volumen LUKS al arrancar.

```bash
# Editar hooks del initramfs
vim /etc/mkinitcpio.conf
```

Localiza la línea `HOOKS=(...` y cámbiala a:

```bash
HOOKS=(base udev autodetect keyboard keymap modconf block encrypt filesystems fsck)
```

- `encrypt`: descifra el volumen LUKS usando `cryptdevice=` del kernel cmdline
- `keyboard` + `keymap`: permiten escribir la contraseña con el teclado en español al arrancar

```bash
# Regenerar initramfs
mkinitcpio -P
```

---

## Configurar el bootloader (Limine)

Instala y configura Limine como bootloader UEFI.

```bash
# Obtener PARTUUID de la partición LUKS
blkid -s PARTUUID -o value /dev/nvme0n1p2
# ↑ Guarda este PARTUUID, lo necesitas para la configuración
```

```bash
# Crear directorio para Limine en el ESP
mkdir -p /boot/EFI/LIMINE

# Copiar bootloader UEFI
cp /usr/share/limine/BOOTX64.EFI /boot/EFI/LIMINE/
```

```bash
# Crear configuración de Limine
vim /boot/EFI/LIMINE/limine.conf
```

```
timeout: 5

/Arch Linux
    protocol: linux
    path: boot():/vmlinuz-linux
    cmdline: cryptdevice=PARTUUID=<PARTUUID>:cryptroot root=/dev/mapper/cryptroot rw rootflags=subvol=@ rootfstype=btrfs
    module_path: boot():/amd-ucode.img
    module_path: boot():/initramfs-linux.img
```

Reemplaza `<PARTUUID>` por el PARTUUID de tu partición LUKS (`/dev/nvme0n1p2`).

```bash
# Registrar Limine en el firmware UEFI
efibootmgr --create --disk /dev/nvme0n1 --part 1 --label "Arch Linux" --loader '\\EFI\\LIMINE\\BOOTX64.EFI'
```

---

## Pasos finales

### Contraseñas

```bash
# Contraseña de root
passwd

# Crear usuario
useradd --create-home --groups wheel anarchist-penguin

# Contraseña del usuario
passwd anarchist-penguin
```

### Servicios

```bash
# Habilitar Wi-Fi (iwd)
systemctl enable iwd

# Habilitar red dinámica (DHCP)
systemctl enable systemd-networkd
```

### Salir y reiniciar

```bash
# Salir del chroot
exit

# Desmontar todo
umount -R /mnt

# Cerrar volumen LUKS
cryptsetup close cryptroot

# Reiniciar
reboot
```

---

*Guía de instalación completada.*

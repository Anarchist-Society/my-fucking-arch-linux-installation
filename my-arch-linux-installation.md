# Instalación de Arch Linux

## Tabla de contenidos

- [Introducción](#introducción)

- [Especificaciones del equipo](#especificaciones-del-equipo)
- [Preparación](#preparación)
  - [Teclado y consola](#teclado-y-consola)
  - [Red (Wi-Fi)](#red-wi-fi)
  - [Hora](#hora)
  - [Limpieza del disco](#limpieza-del-disco)
- [Particionado del disco](#particionado-del-disco)
- [Formatear la partición EFI](#formatear-la-partición-efi)
- [Preparar la partición del sistema](#preparar-la-partición-del-sistema)
  - [Crear el volumen cifrado LUKS](#crear-el-volumen-cifrado-luks)
  - [Crear la estructura btrfs](#crear-la-estructura-btrfs)
- [Instalar Arch Linux](#instalar-arch-linux)
  - [Actualizar mirrors](#actualizar-mirrors)
  - [Instalación base](#instalación-base)
  - [Generar fstab](#generar-fstab)
  - [Entrar al sistema (chroot)](#entrar-al-sistema-chroot)
  - [Zona horaria](#zona-horaria)
  - [Localización](#localización)
  - [Hostname](#hostname)
  - [Initramfs](#initramfs)
- [Configurar el bootloader (Limine)](#configurar-el-bootloader-limine)
- [Pasos finales](#pasos-finales)
  - [Contraseñas](#contraseñas)
  - [Servicios](#servicios)
  - [Salir y reiniciar](#salir-y-reiniciar)

---

## Introducción

Esta guía documenta mi instalación de [Arch Linux](https://archlinux.org) con cifrado LUKS2 + btrfs con subvolúmenes y Limine como bootloader en un sistema UEFI (Slimbook EVO con AMD Ryzen 7 8845HS y Samsung SSD 990 PRO 4TB). No sustituye [la guía oficial de instalación](https://wiki.archlinux.org/title/Installation_guide), sino que es una versión condensada de los pasos esenciales adaptada a mi hardware.

Características de esta instalación:

- Partición del sistema cifrada con LUKS2 y formateada con btrfs usando subvolúmenes planos.
- Partición EFI (FAT32) sin cifrar montada como `/boot`.
- Bootloader Limine — ligero, soporta btrfs/LUKS.
- Red con iwd + systemd-networkd (nativos de systemd, sin dependencias extra).
- Sin LVM — btrfs gestiona volúmenes y snapshots por sí mismo.

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

Uso `iwctl` (de `iwd`) porque es más ligero que NetworkManager y funciona sin dependencias adicionales. La conexión se configura interactivamente; las credenciales se guardan automáticamente.

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
ping -c 3 ping.archlinux.org
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

Creo dos particiones en tabla GPT:
- Una **EFI** de 2 GiB para el bootloader y kernels — suficiente para varios kernels sin quedarse corto.
- El **resto del disco** sin cifrar a nivel de partición; el cifrado se aplica dentro con LUKS.

Uso `fdisk` porque es la herramienta estándar en el ISO de Arch, minimalista y hace exactamente lo que necesito sin dependencias.

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

La partición EFI debe ser FAT32 (lo exige el firmware UEFI). Se monta en `/boot` y no se cifra.

```bash
# Formatear partición EFI como FAT32
mkfs.fat -F32 /dev/nvme0n1p1
```

---

## Preparar la partición del sistema

### Crear el volumen cifrado LUKS

Cifro la partición del sistema con LUKS2 para proteger los datos en caso de robo o pérdida del equipo. La contraseña se pide manualmente en cada arranque.

```bash
# Crear volumen LUKS
cryptsetup --verbose luksFormat /dev/nvme0n1p2

# Abrir volumen como /dev/mapper/cryptroot
cryptsetup open /dev/nvme0n1p2 cryptroot
```

### Crear la estructura btrfs

btrfs permite snapshots, compresión transparente, sumas de verificación para integridad de datos, y subvolúmenes. Uso un layout plano (no anidado) porque es más flexible y evita problemas al restaurar snapshots.

Las opciones de montaje:
- `noatime` — evita escrituras innecesarias al leer archivos.
- `ssd` — optimiza para NVMe/SSD (agrupa escrituras).
- `compress=zstd` — comprime datos en vuelo, reduce espacio sin pérdida de rendimiento en CPUs modernas.
- `space_cache=v2` — mejor gestión del espacio libre.
- `discard=async` — TRIM paralelo sin bloquear operaciones.

Subvolúmenes separados para `/home`, `/var/log` y `/var/cache/pacman/pkg` evitan que esas rutas se incluyan al hacer snapshots de la raíz.

```bash
# Formatear volumen cifrado como btrfs
mkfs.btrfs --label cryptroot /dev/mapper/cryptroot
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
mount --options noatime,ssd,compress=zstd,space_cache=v2,discard=async,subvol=@ /dev/mapper/cryptroot /mnt

# /home
mount --mkdir --options noatime,ssd,compress=zstd,space_cache=v2,discard=async,subvol=@home /dev/mapper/cryptroot /mnt/home

# Logs
mount --mkdir --options noatime,ssd,compress=zstd,space_cache=v2,discard=async,subvol=@log /dev/mapper/cryptroot /mnt/var/log

# Caché pacman
mount --mkdir --options noatime,ssd,compress=zstd,space_cache=v2,discard=async,subvol=@pkg /dev/mapper/cryptroot /mnt/var/cache/pacman/pkg

# EFI sin cifrar
mount --mkdir /dev/nvme0n1p1 /mnt/boot
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

`reflector` obtiene los mirrors más rápidos cercanos a España, acelerando las descargas de pacman.

```bash
# Obtener mirrors más rápidos
reflector --country Spain --latest 10 --protocol http,https --sort rate --save /etc/pacman.d/mirrorlist
```

### Instalación base

Instalo solo los paquetes necesarios para que el sistema arranque y tenga red.

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
| `sudo` | Elevación de privilegios |

```bash
# Instalar sistema base
pacstrap -K /mnt base linux linux-firmware amd-ucode btrfs-progs cryptsetup vim limine iwd sudo
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
echo "fucking-archlinux" > /etc/hostname
```

### Initramfs

El hook `encrypt` permite al initramfs descifrar LUKS usando el parámetro `cryptdevice=` del kernel. No incluyo `microcode` en hooks porque va cargado por Limine como `module_path`. No incluyo `consolefont` porque no es necesario en sistemas modernos.

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

Limine es un bootloader moderno, minimalista y rápido. Soporta arranque desde btrfs sobre LUKS, configuración en texto plano y se integra con snapper para ofrecer snapshots arrancables. A diferencia de GRUB, no necesita regenerar configuración tras cada actualización de kernel (el `module_path` apunta directamente a los archivos).

El microcode AMD va como `module_path` en Limine, no en hooks del initramfs. Esto mantiene el initramfs más pequeño y la lógica de carga en el bootloader.

```bash
# Obtener PARTUUID de la partición LUKS
blkid --match-tag PARTUUID --output value /dev/nvme0n1p2
# ↑ Guarda este PARTUUID, lo necesitas para la configuración
```

```bash
# Crear directorio para Limine en el ESP
mkdir --parents /boot/EFI/LIMINE

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

El usuario `anarchist-penguin` se crea sin grupo `wheel`. Los permisos sudo se conceden mediante un archivo dedicado en `/etc/sudoers.d/`, siguiendo el principio de mínimos privilegios: solo este usuario puede elevar privilegios, no todo el grupo wheel.

```bash
# Contraseña de root
passwd

# Crear usuario
useradd --create-home anarchist-penguin

# Contraseña del usuario
passwd anarchist-penguin

# Dar permisos sudo al usuario
echo "anarchist-penguin ALL=(ALL) ALL" > /etc/sudoers.d/00-anarchist-penguin
chmod 440 /etc/sudoers.d/00-anarchist-penguin
```

### Servicios

- `iwd` — servicio de Wi-Fi, permite usar `iwctl` para conectarse.
- `systemd-networkd` — gestor de red nativo de systemd, asigna IP por DHCP.
- `systemd-resolved` — resolución DNS automática (recibe los DNS del router por DHCP).

```bash
# Habilitar Wi-Fi (iwd)
systemctl enable iwd

# Habilitar red dinámica (DHCP) y resolución DNS
systemctl enable systemd-networkd
systemctl enable systemd-resolved
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

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
  - [Servicios](#servicios)
  - [Salir y reiniciar](#salir-y-reiniciar)

---

## Introducción

Esta guía documenta mi instalación de [Arch Linux](https://archlinux.org) con cifrado LUKS2 + btrfs con subvolúmenes y Limine como bootloader en un sistema UEFI (Slimbook EVO con AMD Ryzen 7 8845HS y Samsung SSD 990 PRO 4TB). No sustituye [la guía oficial de instalación](https://wiki.archlinux.org/title/Installation_guide), sino que es una versión condensada de los pasos esenciales adaptada a mi hardware.

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

[Keyboard configuration (Arch Wiki)](https://wiki.archlinux.org/title/Linux_console/Keyboard_configuration). `loadkeys es` configura el teclado en español para poder escribir la contraseña LUKS y comandos correctamente (ñ, teclas especiales). `setfont ter-132b` cambia a una fuente más grande para pantallas HiDPI (2560×1600) y mejora la legibilidad.

```bash
# Teclado español
loadkeys es

# Fuente más grande para alta densidad
setfont ter-132b
```

### Red (Wi-Fi)

Uso [`iwctl`](https://wiki.archlinux.org/title/Iwd) (de `iwd`) porque es más ligero que NetworkManager y funciona sin dependencias adicionales. La conexión se configura interactivamente. Las credenciales se guardan automáticamente.

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

[systemd-timesyncd](https://wiki.archlinux.org/title/Systemd-timesyncd) está activado por defecto en el entorno live. Necesitas la hora exacta para evitar errores de verificación de firma de paquetes y certificados TLS.

```bash
# Verificar que la hora está sincronizada
timedatectl

# Activar sincronización NTP
timedatectl set-ntp true

# Establecer zona horaria
timedatectl set-timezone Europe/Madrid

# Verificar hora y fecha
timedatectl status
```

### Limpieza del disco

[Securely wipe disk (Arch Wiki)](https://wiki.archlinux.org/title/Securely_wipe_disk). Elimina firmas de sistemas de archivo anteriores (`wipefs --all`) y la tabla de particiones GPT (`sgdisk --zap-all`) para empezar con un disco limpio y evitar conflictos al particionar y montar.

```bash
# Borrar firmas de filesystem/LVM
wipefs --all /dev/nvme0n1

# Limpiar tabla de particiones
sgdisk --zap-all /dev/nvme0n1
```

---

## Particionado del disco

Creo dos particiones en [tabla GPT](https://wiki.archlinux.org/title/GUID_Partition_Table):
- Una [**EFI**](https://wiki.archlinux.org/title/EFI_system_partition) de 2 GiB para el bootloader y kernels — suficiente para varios kernels sin quedarse corto.
- El **resto del disco** sin cifrar a nivel de partición. El cifrado se aplica dentro con LUKS.

Uso [`fdisk`](https://wiki.archlinux.org/title/Fdisk) porque es la herramienta estándar en el ISO de Arch, minimalista y hace exactamente lo que necesito sin dependencias.

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

La [partición EFI](https://wiki.archlinux.org/title/EFI_system_partition) debe ser FAT32 (lo exige el firmware UEFI). Se monta en `/boot` y no se cifra.

```bash
# Formatear partición EFI como FAT32
mkfs.fat -F32 /dev/nvme0n1p1
```

---

## Preparar la partición del sistema

### Crear el volumen cifrado LUKS

Cifro la partición del sistema con [LUKS2](https://wiki.archlinux.org/title/Dm-crypt) para proteger los datos en caso de robo o pérdida del equipo. La contraseña se pide manualmente en cada arranque.

```bash
# Crear volumen LUKS
cryptsetup --verbose luksFormat /dev/nvme0n1p2

# Abrir volumen como /dev/mapper/cryptroot
cryptsetup open /dev/nvme0n1p2 cryptroot
```

### Crear la estructura btrfs

[btrfs](https://wiki.archlinux.org/title/Btrfs) permite snapshots, compresión transparente, sumas de verificación para integridad de datos, y subvolúmenes. Uso un layout plano (`@`, `@home`, `@log`, `@pkg` — no anidados) porque es más flexible y evita problemas al restaurar snapshots.

Las opciones de montaje:
- `noatime` — evita escrituras innecesarias al leer archivos.
- `ssd` — optimiza para NVMe/SSD (agrupa escrituras).
- `compress=zstd` — comprime datos en vuelo, reduce espacio sin pérdida de rendimiento en CPUs modernas.
- `space_cache=v2` — mejor gestión del espacio libre.
- `discard=async` — TRIM paralelo sin bloquear operaciones.

La separación en subvolúmenes independientes sigue [el layout por defecto de archinstall](https://archinstall.archlinux.page/cli_parameters/config/disk_config.html#btrfs) (`@`, `@home`, `@log`, `@pkg`). Cada subvolumen se monta, snapshotea y restaura por separado:

| Subvolumen | Montaje | Por qué separado |
|---|---|---|
| `@` | `/` | Raíz del sistema |
| `@home` | `/home` | Tus datos no se pierden al restaurar snapshots de `@` |
| `@log` | `/var/log` | Logs volátiles, excluirlos evita snapshots enormes |
| `@pkg` | `/var/cache/pacman/pkg` | Caché de paquetes (GBs), innecesaria en snapshots de raíz |

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

[`reflector`](https://wiki.archlinux.org/title/Reflector) obtiene los mirrors más rápidos cercanos a España, acelerando las descargas de pacman.

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
| `cryptsetup` | Descifrar LUKS al arrancar |
| `btrfs-progs` | Herramientas para gestionar btrfs |
| `limine` | Bootloader |
| `iwd` | Conexión Wi-Fi (iwctl) |
| `vim` | Editor de texto |

```bash
# Instalar sistema base
pacstrap -K /mnt base linux linux-firmware amd-ucode cryptsetup btrfs-progs limine iwd vim
```

### Generar fstab

`genfstab -U` usa [UUID](https://wiki.archlinux.org/title/UUID) en lugar de nombres de dispositivo (como `/dev/nvme0n1p1`). Los UUID no cambian aunque se reordenen los discos.

```bash
# Generar fstab
genfstab -U /mnt >> /mnt/etc/fstab
```

### Entrar al sistema (chroot)

[Chroot (Arch Wiki)](https://wiki.archlinux.org/title/Chroot). `arch-chroot /mnt` cambia el directorio raíz del sistema en vivo a la nueva instalación en `/mnt`. A partir de aquí los comandos se ejecutan como si estuviésemos dentro del sistema recién instalado, permitiendo configurarlo (zona horaria, idioma, hostname, initramfs, bootloader) antes del primer reinicio.

```bash
# Entrar al sistema instalado
arch-chroot /mnt
```

### Zona horaria

[System time (Arch Wiki)](https://wiki.archlinux.org/title/System_time). `ln -sf` crea un enlace simbólico al archivo de zona horaria correspondiente, haciendo que el sistema use la hora de Europa/Madrid. `hwclock --systohc` sincroniza el reloj hardware (RTC) con la hora del sistema para que se mantenga al apagar el equipo.

```bash
# Establecer zona horaria
ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime

# Sincronizar reloj hardware
hwclock --systohc
```

### Localización

[Locale (Arch Wiki)](https://wiki.archlinux.org/title/Locale). Edita `/etc/locale.gen` y descomenta el locale español (`es_ES.UTF-8 UTF-8`). `locale-gen` genera los locales. `LANG=es_ES.UTF-8` en `/etc/locale.conf` establece el idioma del sistema. `KEYMAP=es` en `/etc/vconsole.conf` fija el teclado español en la consola virtual.

```bash
# Editar locale.gen y descomentar es_ES.UTF-8 UTF-8
vim /etc/locale.gen
   # Descomenta: es_ES.UTF-8 UTF-8

# Generar locales
locale-gen

# Configurar idioma del sistema
echo "LANG=es_ES.UTF-8" > /etc/locale.conf

# Configurar teclado en consola
echo "KEYMAP=es" > /etc/vconsole.conf
```

### Hostname

[Hostname (Arch Wiki)](https://wiki.archlinux.org/title/Hostname). `/etc/hostname` contiene el nombre del equipo. Se usa para identificar la máquina en la red local y aparece en el prompt de la terminal.

```bash
# Establecer nombre del equipo
echo "fucking-archlinux" > /etc/hostname
```

### Initramfs

[Mkinitcpio (Arch Wiki)](https://wiki.archlinux.org/title/Mkinitcpio). El initramfs es un sistema de archivos temporal que se carga en memoria al arrancar. Contiene los módulos y herramientas necesarios para acceder al sistema raíz, incluyendo el descifrado LUKS.

El hook [`encrypt`](https://wiki.archlinux.org/title/Mkinitcpio#Common_hooks) permite al initramfs descifrar LUKS usando el parámetro `cryptdevice=` del kernel.

```bash
# Editar hooks del initramfs
vim /etc/mkinitcpio.conf
```

Localiza la línea `HOOKS=(...` y cámbiala a:

```bash
HOOKS=(base udev autodetect microcode modconf kms keyboard keymap block encrypt filesystems fsck)
```

- `encrypt`: descifra el volumen LUKS usando `cryptdevice=` del kernel cmdline

```bash
# Regenerar initramfs
mkinitcpio -P
```

## Configurar el bootloader (Limine)

[Limine](https://wiki.archlinux.org/title/Limine) es un bootloader moderno, minimalista y rápido. Soporta arranque desde btrfs sobre LUKS y configuración en texto plano. A diferencia de GRUB, no necesita regenerar configuración tras cada actualización de kernel (el `module_path` apunta directamente a los archivos).

El binario `BOOTX64.EFI` se copia a `EFI/BOOT/`, la [ruta de búsqueda por defecto del firmware UEFI](https://wiki.archlinux.org/title/Limine#UEFI_systems). El firmware la encuentra automáticamente sin necesidad de `efibootmgr` ni entradas NVRAM.

```bash
# Guardar PARTUUID en variable temporal
PARTUUID=$(blkid --match-tag PARTUUID --output value /dev/nvme0n1p2)

# Ver el PARTUUID (cópialo para limine.conf)
echo $PARTUUID
```

```bash
# Crear directorio para Limine en el ESP
mkdir --parents /boot/EFI/BOOT

# Copiar bootloader UEFI a la ruta de fallback UEFI
cp /usr/share/limine/BOOTX64.EFI /boot/EFI/BOOT/
```

```bash
# Escribir PARTUUID en limine.conf como base, luego editar
echo $PARTUUID > /boot/limine.conf
vim /boot/limine.conf
```

```bash
# Tiempo de espera en segundos antes de arrancar la entrada por defecto
timeout: 5

# --- Entrada de arranque principal ---
/Arch Linux
    # protocol: linux  ->  arranque tradicional (vmlinuz + initramfs), no UKI
    protocol: linux

    # Ruta al kernel dentro del ESP
    path: boot():/vmlinuz-linux

    # Parámetros del kernel: descifrar LUKS con PARTUUID,
    # montar root desde el mapeador, btrfs con subvol @
    cmdline: cryptdevice=PARTUUID=<PARTUUID>:cryptroot root=/dev/mapper/cryptroot rw rootflags=subvol=@ rootfstype=btrfs

    # Ruta al initramfs dentro del ESP
    module_path: boot():/initramfs-linux.img
```

Reemplaza `<PARTUUID>` por el PARTUUID de tu partición LUKS (`/dev/nvme0n1p2`).

---

## Pasos finales

### Root password

[Users and groups (Arch Wiki)](https://wiki.archlinux.org/title/Users_and_groups#User_database). Establece una contraseña segura para el usuario root para permitir realizar acciones administrativas:

```bash
# Establecer contraseña de root
passwd
```

> Una vez reiniciado el sistema, crea un usuario no root siguiendo la [guía de post-instalación de usuarios](post-install-users.md).

### Servicios

- [`iwd`](https://wiki.archlinux.org/title/Iwd) — servicio de Wi-Fi, permite usar `iwctl` para conectarse.
- [`systemd-networkd`](https://wiki.archlinux.org/title/Systemd-networkd) — gestor de red nativo de systemd, asigna IP por DHCP.
- [`systemd-resolved`](https://wiki.archlinux.org/title/Systemd-resolved) — resolución DNS automática (recibe los DNS del router por DHCP).

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
umount --recursive /mnt

# Cerrar volumen LUKS
cryptsetup close cryptroot

# Reiniciar
reboot
```

---

*Guía de instalación completada.*

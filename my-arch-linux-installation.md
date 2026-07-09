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

Uso [`iwctl`](https://wiki.archlinux.org/title/Iwd) (de iwd) porque viene preinstalado en el ISO de Arch Linux y es la herramienta estándar para conectarse por Wi-Fi durante la instalación. La conexión se configura interactivamente. Las credenciales se guardan automáticamente.

```bash
# Iniciar iwctl (Wi-Fi)
iwctl

  # Listar interfaces de red
  device list

  # Escanear redes Wi-Fi
  station <device> get-networks

  # Conectarse a la red
  station <device> connect <SSID>

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

Este esquema de particionado sigue la configuración documentada en [dm-crypt/Encrypting an entire system](https://wiki.archlinux.org/title/Dm-crypt/Encrypting_an_entire_system#LUKS_on_a_partition) (partición EFI + LUKS).

### Tabla de particiones resultante

| Partición | Tamaño | Tipo |
|---|---|---|
| `nvme0n1p1` | 2 GiB | EFI System (FAT32) |
| `nvme0n1p2` | Resto | Linux filesystem (LUKS + btrfs) |

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

Las opciones de montaje:
- `noatime` — evita escrituras innecesarias al leer archivos.
- `ssd` — optimiza para NVMe/SSD (agrupa escrituras).
- `compress=zstd` — comprime datos en vuelo, reduce espacio sin pérdida de rendimiento en CPUs modernas.
- `space_cache=v2` — mejor gestión del espacio libre.
- `discard=async` — TRIM paralelo sin bloquear operaciones.

```bash
# Raíz
mount --options noatime,ssd,compress=zstd,space_cache=v2,discard=async,subvol=@ /dev/mapper/cryptroot /mnt

# /home
mount --mkdir --options noatime,ssd,compress=zstd,space_cache=v2,discard=async,subvol=@home /dev/mapper/cryptroot /mnt/home

# Caché pacman
mount --mkdir --options noatime,ssd,compress=zstd,space_cache=v2,discard=async,subvol=@pkg /dev/mapper/cryptroot /mnt/var/cache/pacman/pkg

# Logs
mount --mkdir --options noatime,ssd,compress=zstd,space_cache=v2,discard=async,subvol=@log /dev/mapper/cryptroot /mnt/var/log

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
echo "FONT=default8x16" >> /etc/vconsole.conf
```

### Hostname

[Hostname (Arch Wiki)](https://wiki.archlinux.org/title/Hostname). `/etc/hostname` contiene el nombre del equipo. Se usa para identificar la máquina en la red local y aparece en el prompt de la terminal.

```bash
# Establecer nombre del equipo
echo "fucking-archlinux" > /etc/hostname
```

### Initramfs

[Mkinitcpio (Arch Wiki)](https://wiki.archlinux.org/title/Mkinitcpio). El initramfs es un sistema de archivos temporal que se carga en memoria al arrancar. Contiene los módulos y herramientas necesarios para acceder al sistema raíz, incluyendo el descifrado LUKS.

Los hooks de mkinitcpio son scripts que se ejecutan durante la construcción del initramfs y al arrancar. Cada hook realiza una tarea específica: cargar módulos, configurar dispositivos o preparar el sistema antes de montar la raíz. El orden importa — se ejecutan en secuencia y algunos dependen de otros.

El hook [`encrypt`](https://wiki.archlinux.org/title/Mkinitcpio#Common_hooks) permite al initramfs descifrar LUKS usando el parámetro `cryptdevice=` del kernel.

```bash
# Editar hooks del initramfs
vim /etc/mkinitcpio.conf
```

Localiza la línea `HOOKS=(...` y cámbiala a:

```ini
HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block encrypt filesystems fsck)
```

| Hook | Propósito |
|---|---|
| `base` | Carga módulos esenciales y utilidades mínimas del initramfs |
| `udev` | Detecta hardware y carga módulos automáticamente |
| `autodetect` | Reduce el initramfs incluyendo solo módulos del hardware presente |
| `microcode` | Aplica microcode de la CPU al arrancar |
| `modconf` | Carga módulos adicionales desde `/etc/modprobe.d/` |
| `kms` | Inicializa el modo de vídeo (Kernel Mode Setting) temprano |
| `keyboard` | Carga el mapa de teclado para escribir la contraseña LUKS |
| `keymap` | Aplica `KEYMAP=es` de `/etc/vconsole.conf` |
| `consolefont` | Carga la fuente definida en `FONT=` de `/etc/vconsole.conf` en la consola durante el arranque |
| `block` | Espera a que los dispositivos de bloque estén listos |
| `encrypt` | Descifra el volumen LUKS usando `cryptdevice=` del kernel |
| `filesystems` | Monta el sistema de archivos raíz |
| `fsck` | Comprueba integridad de los sistemas de archivos |

```bash
# Regenerar initramfs
mkinitcpio -P
```

### Orden de los hooks

El orden en la línea `HOOKS=(...)` importa — algunos hooks necesitan ejecutarse antes que otros:

| Hook | Posición | Motivo |
|------|----------|--------|
| `keyboard` | Antes de `autodetect` | Teclado externo USB: `autodetect` debe incluir los módulos USB HID |
| `block` | Antes de `encrypt` | Los dispositivos de bloque deben estar listos antes de descifrar LUKS |
| `keymap` | Antes de `consolefont` | El layout español debe cargarse antes que la fuente |

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

# Editar la configuración de Limine
vim /boot/limine.conf
```

```ini
# Tiempo de espera en segundos antes de arrancar la entrada por defecto
timeout: 3

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

## Plymouth (boot splash)

[Plymouth (Arch Wiki)](https://wiki.archlinux.org/title/Plymouth) es un splash gráfico de arranque que oculta los mensajes del kernel y muestra una animación. También integra el prompt de contraseña LUKS de forma gráfica.

```bash
# Instalar Plymouth
pacman --sync plymouth
```

### Configurar mkinitcpio

Añade el hook `plymouth` **antes de `encrypt`** en `/etc/mkinitcpio.conf`:

```ini
HOOKS=(base udev keyboard autodetect microcode modconf kms keymap consolefont block plymouth encrypt filesystems fsck)
```

| Hook | Posición | Motivo |
|------|----------|--------|
| `plymouth` | Antes de `encrypt` | Muestra el prompt de contraseña LUKS de forma gráfica |

### Configurar el bootloader

Añade `splash` y opcionalmente `quiet` a los parámetros del kernel en `/boot/limine.conf`:

```ini
cmdline: cryptdevice=PARTUUID=<PARTUUID>:cryptroot root=/dev/mapper/cryptroot rw rootflags=subvol=@ rootfstype=btrfs splash quiet
```

- `splash` — activa Plymouth
- `quiet` — oculta los mensajes del kernel (opcional)

### HiDPI

Para tu pantalla 2560×1600, configura el factor de escala en `/etc/plymouth/plymouthd.conf`:

```ini
[Daemon]
Theme=spinner
DeviceScale=2
```

### Temas disponibles

| Tema | Descripción |
|------|------------|
| `bgrt` | Similar a spinner pero con el logo del fabricante (OEM) |
| `details` | Muestra mensajes de arranque detallados (útil para depuración) |
| `fade-in` | Fundido con estrellas |
| `glow` | Corporativo, con gráfico de progreso circular |
| `script` | Tema basado en script, personalizable |
| `solar` | Tema espacial con una estrella azul |
| `spinfinity` | Símbolo de infinito giratorio |
| `spinner` | Simple, con un spinner de carga |
| `text` | Versión textual, sin gráficos |
| `tribar` | Barra de progreso triple |

```bash
# Listar temas instalados
plymouth-set-default-theme --list

# Cambiar tema y regenerar initramfs
plymouth-set-default-theme --rebuild-initrd <theme>
```

```bash
# Regenerar initramfs
mkinitcpio -P
```

### Downgrade (bug conocido en v26)

El hook `keymap` no funciona correctamente con Plymouth v26 (26.134.222-1 y -2). El prompt LUKS se muestra en inglés (US) aunque `KEYMAP=es` esté configurado. Solución: downgrade a v24.004.60-14.

Más información: [Foro Arch Linux](https://bbs.archlinux.org/viewtopic.php?id=313743) — [Bug upstream](https://gitlab.freedesktop.org/plymouth/plymouth/-/work_items/337)

```bash
# Descargar v24 desde Arch Archive
curl -OL https://archive.archlinux.org/packages/p/plymouth/plymouth-24.004.60-14-x86_64.pkg.tar.zst

# Downgrade forzado
pacman --upgrade plymouth-24.004.60-14-x86_64.pkg.tar.zst

# Pinear para que no se actualice
# Añadir al final de /etc/pacman.conf: IgnorePkg = plymouth

# Eliminar el paquete descargado
rm plymouth-24.004.60-14-x86_64.pkg.tar.zst
```

---

## Pasos finales

### Root password

[Users and groups (Arch Wiki)](https://wiki.archlinux.org/title/Users_and_groups#User_database). Establece una contraseña segura para el usuario root para permitir realizar acciones administrativas:

```bash
# Establecer contraseña de root
passwd
```

> Una vez reiniciado el sistema, crea un usuario no root siguiendo la sección [Usuarios](#usuarios).

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

## Gráficos (AMDGPU)

[AMDGPU (Arch Wiki)](https://wiki.archlinux.org/title/AMDGPU) es el driver oficial para GPUs Radeon modernas (incluyendo la Radeon 780M del Ryzen 8845HS). OpenGL, Vulkan y aceleración de video (VA-API/VDPAU) están incluidos en mesa.

```bash
# Instalar drivers gráficos AMD
sudo pacman --sync mesa vulkan-radeon
```

| Paquete | Propósito |
|---------|-----------|
| `mesa` | OpenGL, Vulkan y VA-API |
| `vulkan-radeon` | Driver Vulkan específico para AMD |

---

## Red (iwd + systemd-networkd)

[iwd (Arch Wiki)](https://wiki.archlinux.org/title/Iwd) es el daemon de Wi-Fi nativo de systemd. Es ligero, no tiene dependencias externas y se gestiona con `iwctl` desde TTY. A diferencia de NetworkManager, no necesita un gestor de red adicional — iwd + systemd-networkd son suficientes para la conectividad completa.

### Verificar que iwd está activo

```bash
# Verificar estado del servicio iwd
systemctl status iwd
```

Si no está activo, iniciarlo y habilitarlo:

```bash
# Habilitar iwd para que arranque automáticamente al iniciar el sistema
systemctl enable iwd

# Iniciar iwd ahora
systemctl start iwd
```

### Escanear redes disponibles

```bash
# Escanear redes Wi-Fi
iwctl station <device> scan

# Listar las redes encontradas
iwctl station <device> get-networks
```

`<device>` es el nombre de tu interfaz Wi-Fi (por ejemplo `wlan0`). Si no aparece, usa:

```bash
# Listar dispositivos de red disponibles
iwctl device list
```

### Conectarse a una red

```bash
# Conectarse a la red (iwctl pedirá la contraseña interactivamente)
iwctl station <device> connect <SSID>
```

Sustituye `<SSID>` por el nombre de la red. `iwctl` solicitará la contraseña. La red se guarda automáticamente en `iwd` para reconexiones futuras.

### Configurar red (asignación de IP)

[systemd-networkd](https://wiki.archlinux.org/title/Systemd-networkd) necesita ficheros `.network` para asignar IP por DHCP. Sin esto, `iwd` se conecta al Wi-Fi pero la interfaz no obtiene dirección IP:

```bash
sudo vim /etc/systemd/network/20-ethernet.network
```

```ini
# Red cableada: se aplica a interfaces de tipo ether (enp2s0, eth0...)
# Type=ether sin Kind=!* también matchearía interfaces virtuales (veth*) de contenedores
# https://bugs.archlinux.org/task/70892
[Match]
Type=ether

# Excluye interfaces virtuales (bridges, VLANs, veth...)
Kind=!*

[Link]
# Esperar a que tenga una ruta por defecto antes de marcar el sistema como online
RequiredForOnline=routable

[Network]
# Obtener IP, puerta de enlace y DNS automáticamente desde el router
DHCP=yes

# Resolver nombres .local en la LAN
MulticastDNS=yes

# Métrica baja = prioridad alta. Ethernet es la interfaz preferida.
# systemd-networkd no asigna métricas por tipo de interfaz automáticamente:
# https://github.com/systemd/systemd/issues/17698
[DHCPv4]
RouteMetric=100

[IPv6AcceptRA]
RouteMetric=100
```

```bash
sudo vim /etc/systemd/network/20-wlan.network
```

```ini
# Red Wi-Fi: se aplica a interfaces de tipo wlan (wlan0, wlp2s0...)
[Match]
Type=wlan

[Link]
# Esperar a que tenga una ruta por defecto antes de marcar el sistema como online
RequiredForOnline=routable

[Network]
# Obtener IP, puerta de enlace y DNS automáticamente desde el router
DHCP=yes

# Resolver nombres .local en la LAN
MulticastDNS=yes

# Métrica media. Si Ethernet está disponible, el tráfico sale por Ethernet.
# systemd-networkd no asigna métricas por tipo de interfaz automáticamente:
# https://github.com/systemd/systemd/issues/17698
[DHCPv4]
RouteMetric=600

[IPv6AcceptRA]
RouteMetric=600
```

```bash
sudo vim /etc/systemd/network/20-wwan.network
```

```ini
# Red móvil (WWAN): se aplica a interfaces de tipo wwan (wwan0...)
[Match]
Type=wwan

[Link]
# Esperar a que tenga una ruta por defecto antes de marcar el sistema como online
RequiredForOnline=routable

[Network]
# Obtener IP, puerta de enlace y DNS automáticamente desde el router
DHCP=yes

# Resolver nombres .local en la LAN
MulticastDNS=yes

# Métrica alta = prioridad baja. Solo se usa si no hay Ethernet ni Wi-Fi.
# systemd-networkd no asigna métricas por tipo de interfaz automáticamente:
# https://github.com/systemd/systemd/issues/17698
[DHCPv4]
RouteMetric=700

[IPv6AcceptRA]
RouteMetric=700
```

Luego habilitar e iniciar systemd-networkd:

```bash
sudo systemctl enable --now systemd-networkd
```

Estos ficheros `.network` están basados en los ejemplos del [archiso oficial](https://gitlab.archlinux.org/archlinux/archiso/-/blob/master/configs/releng/airootfs/etc/systemd/network/) con las métricas de ruta y opciones adicionales de la [guía de systemd-networkd](https://wiki.archlinux.org/title/Systemd-networkd#Configure_a_wired_network_with_DHCP).

### Verificar conexión

```bash
# Probar conectividad
ping -c 3 ping.archlinux.org
```

---

## Audio (PipeWire + WirePlumber)

[PipeWire](https://wiki.archlinux.org/title/PipeWire) es un servidor multimedia que gestiona flujos de audio y vídeo en Linux. A diferencia de ALSA (nivel de kernel) y PulseAudio (servidor de sonido tradicional), PipeWire ofrece baja latencia, gestión segura de permisos (esencial en Wayland) y manejo unificado de audio y vídeo mediante un grafo de nodos enrutables.

WirePlumber actúa como gestor de sesiones: decide qué rutas de audio se conectan, maneja perfiles de dispositivos (altavoz, auriculares, HDMI) y aplica reglas de enrutamiento configuradas por el usuario o por el propio dispositivo. Es el reemplazo moderno de `pipewire-media-session`.

```bash
# Instalar PipeWire como servidor de audio y WirePlumber como gestor de sesiones
sudo pacman --sync pipewire wireplumber pipewire-pulse pipewire-jack pipewire-alsa sof-firmware
```

| Paquete | Propósito |
|---------|-----------|
| `pipewire` | Servidor de audio/video |
| `wireplumber` | Gestor de sesiones de PipeWire, maneja rutas y perfiles |
| `pipewire-pulse` | Sustituye PulseAudio, permite que apps PulseAudio usen PipeWire |
| `pipewire-jack` | Compatibilidad con JACK, permite usar apps de audio profesional |
| `pipewire-alsa` | Capa de compatibilidad ALSA sobre PipeWire |
| `sof-firmware` | Firmware para el DSP de audio en portátiles modernos |

Habilitar servicios de usuario:

```bash
# Habilitar e iniciar servicios de PipeWire y WirePlumber
systemctl --user enable --now pipewire.service
systemctl --user enable --now pipewire-pulse.service
systemctl --user enable --now wireplumber.service
```

---

## Utilidades del sistema

### brightnessctl

[brightnessctl](https://github.com/Hummer12007/brightnessctl) es una herramienta de línea de comandos para leer y ajustar el brillo de dispositivos en Linux. Modifica valores directamente en `/sys/class/backlight/`, por lo que funciona tanto en X11 como en Wayland (o sin servidor gráfico). Soporta backlights de pantalla, retroiluminación de teclado y LEDs.

```bash
# Instalar brightnessctl
sudo pacman --sync brightnessctl
```

| Paquete | Propósito |
|---------|-----------|
| `brightnessctl` | Control de brillo ligero vía /sys/class/backlight/ |

```bash
# Ver nivel actual y máximo
brightnessctl get
brightnessctl max

# Establecer brillo al 50 %
brightnessctl set 50%

# Subir/bajar 10 puntos porcentuales
brightnessctl set +10%
brightnessctl set 10%-
```

### Bluetooth

[Bluetooth](https://wiki.archlinux.org/title/Bluetooth) es un estándar para la interconexión inalámbrica de corto alcance. El soporte básico se habilita con `bluez` y se gestiona desde `bluetoothctl`.

```bash
# Instalar Bluetooth
sudo pacman --sync bluez bluez-utils
```

| Paquete | Propósito |
|---------|-----------|
| `bluez` | Pila de protocolo Bluetooth |
| `bluez-utils` | Utilidades como `bluetoothctl` |

```bash
# Habilitar e iniciar el servicio Bluetooth
sudo systemctl enable --now bluetooth.service
```

```bash
# Abrir bluetoothctl
bluetoothctl

# Dentro de bluetoothctl:

# Buscar dispositivos
scan on

# Emparejar
pair XX:XX:XX:XX

# Conectar
connect XX:XX:XX:XX

# Confiar (para conexión automática)
trust XX:XX:XX:XX
```

### unzip

`unzip` es una herramienta para descomprimir archivos `.zip`. Es esencial para extraer paquetes y archivos comprimidos.

```bash
# Instalar unzip
sudo pacman --sync unzip
```

| Paquete | Propósito |
|---------|-----------|
| `unzip` | Descompresión de archivos ZIP |

---

## Usuarios

[Sudo](https://wiki.archlinux.org/title/Sudo) es un programa para ejecutar comandos con privilegios elevados mediante `sudoers.d` sin grupo `wheel`, siguiendo el principio de mínimos privilegios.

```bash
# Instalar sudo
sudo pacman --sync sudo

# Contraseña de root (si no se estableció durante la instalación)
passwd

# Crear usuario
sudo useradd --create-home anarchist-penguin

# Contraseña del usuario
sudo passwd anarchist-penguin

# Dar permisos sudo al usuario
echo "anarchist-penguin ALL=(ALL) ALL" | sudo tee /etc/sudoers.d/00-anarchist-penguin
sudo chmod 440 /etc/sudoers.d/00-anarchist-penguin

# Verificar que la configuración de sudo es correcta
sudo visudo -c
```

| Paquete | Propósito |
|---------|-----------|
| `sudo` | Ejecutar comandos con privilegios de otro usuario (normalmente root) |
```

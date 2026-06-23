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
loadkeys es              # Teclado español
setfont ter-132b         # Fuente más grande para alta densidad
```

---

## 2. Red (Wi-Fi)

```bash
iwctl
  device list                  # Listar interfaces de red
  station wlan0 get-networks   # Escanear redes Wi-Fi
  station wlan0 connect SSID   # Conectarse a la red
  exit                         # Salir de iwctl
```

```bash
ping -c 3 archlinux.org        # Verificar conexión a internet
```

---

## 3. Hora

```bash
timedatectl set-ntp true    # Activar sincronización NTP
timedatectl status          # Verificar hora y fecha
```

---

## 4. Limpieza del disco

Limpia todas las firmas y la tabla de particiones del disco.

```bash
wipefs -a /dev/nvme0n1          # Borrar firmas de filesystem/LVM
sgdisk --zap-all /dev/nvme0n1   # Limpiar tabla de particiones
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
mount /dev/mapper/cryptroot /mnt   # Montar btrfs completo para crear subvols

btrfs subvolume create /mnt/@       # Subvolumen raíz
btrfs subvolume create /mnt/@home   # Subvolumen /home
btrfs subvolume create /mnt/@log    # Subvolumen /var/log
btrfs subvolume create /mnt/@pkg    # Subvolumen /var/cache/pacman/pkg

umount /mnt                         # Desmontar para remontar con subvols
```

### Montar con compresión zstd

```bash
mount -o subvol=@,compress=zstd /dev/mapper/cryptroot /mnt              # Raíz con compresión
mount --mkdir -o subvol=@home,compress=zstd /dev/mapper/cryptroot /mnt/home  # /home
mount --mkdir -o subvol=@log,compress=zstd /dev/mapper/cryptroot /mnt/var/log  # Logs
mount --mkdir -o subvol=@pkg,compress=zstd /dev/mapper/cryptroot /mnt/var/cache/pacman/pkg  # Caché pacman
mount /dev/nvme0n1p1 /mnt/boot                                              # EFI sin cifrar
```
---

## 8. Actualizar mirrors

```bash
reflector --country Spain --latest 10 --protocol http,https --sort rate --save /etc/pacman.d/mirrorlist   # Mirrors rápidos
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

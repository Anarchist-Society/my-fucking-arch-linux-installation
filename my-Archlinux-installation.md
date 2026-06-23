# Instalación de Arch Linux

<p align="center">
  <img src="https://img.shields.io/badge/Arch_Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white" />
  <img src="https://img.shields.io/badge/LUKS2-00457C?style=for-the-badge&logo=linux&logoColor=white" />
  <img src="https://img.shields.io/badge/btrfs-352A1E?style=for-the-badge&logo=linux&logoColor=white" />
  <img src="https://img.shields.io/badge/Samsung_990_PRO-1428A0?style=for-the-badge&logo=samsung&logoColor=white" />
</p>

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
loadkeys es
setfont ter-132b
```

---

## 2. Red (Wi-Fi)

```bash
iwctl
  device list
  station wlan0 get-networks
  station wlan0 connect SSID
  exit
```

```bash
ping -c 3 archlinux.org
```

---

## 3. Hora

```bash
timedatectl set-ntp true
timedatectl status
```

---

## 4. Limpieza del disco

Limpia todas las firmas y la tabla de particiones del disco.

```bash
wipefs -a /dev/nvme0n1
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
mount /dev/mapper/cryptroot /mnt

btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@log
btrfs subvolume create /mnt/@pkg

umount /mnt
```

### Montar con compresión zstd

```bash
mount -o subvol=@,compress=zstd /dev/mapper/cryptroot /mnt
mount --mkdir -o subvol=@home,compress=zstd /dev/mapper/cryptroot /mnt/home
mount --mkdir -o subvol=@log,compress=zstd /dev/mapper/cryptroot /mnt/var/log
mount --mkdir -o subvol=@pkg,compress=zstd /dev/mapper/cryptroot /mnt/var/cache/pacman/pkg
mount /dev/nvme0n1p1 /mnt/boot
```

### Estructura final del disco

```
nvme0n1p1  → /mnt/boot              (FAT32, sin cifrar)
nvme0n1p2  → cifrado LUKS2
  └─ cryptroot  → btrfs "cryptroot"
       ├── @       → /mnt
       ├── @home   → /mnt/home
       ├── @log    → /mnt/var/log
       └── @pkg    → /mnt/var/cache/pacman/pkg
```

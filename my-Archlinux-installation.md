# Instalación de Arch Linux

## Especificaciones

| Componente | Detalle |
|---|---|
| Modelo | Slimbook EVO (EVO15-A8) |
| CPU | AMD Ryzen 7 8845HS (16) @ 5.14 GHz |
| GPU | AMD Radeon 780M Graphics |
| RAM | 64 GB |
| Almacenamiento | Samsung SSD 990 PRO 4TB (NVMe) |
| Pantalla | 2560×1600 @ 120 Hz |

---

## 1. Teclado y consola

```bash
loadkeys es
setfont ter-132b
```

## 2. Red (Wi-Fi)

```bash
iwctl
  device list
  station wlan0 get-networks
  station wlan0 connect SSID
  exit
```

Verificar: `ping -c 3 archlinux.org`

## 3. Hora

```bash
timedatectl set-ntp true
timedatectl status
```

---

## 4. Limpieza del disco

```bash
wipefs -a /dev/nvme0n1
sgdisk --zap-all /dev/nvme0n1
```

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

## 6. Cifrado LUKS

```bash
cryptsetup -v luksFormat /dev/nvme0n1p2
cryptsetup open /dev/nvme0n1p2 cryptroot
```

## 7. Formateo y subvolúmenes btrfs

```bash
mkfs.fat -F32 /dev/nvme0n1p1
mkfs.btrfs -L cryptroot /dev/mapper/cryptroot

mount /dev/mapper/cryptroot /mnt

btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@log
btrfs subvolume create /mnt/@pkg

umount /mnt

mount -o subvol=@,compress=zstd /dev/mapper/cryptroot /mnt
mount --mkdir -o subvol=@home,compress=zstd /dev/mapper/cryptroot /mnt/home
mount --mkdir -o subvol=@log,compress=zstd /dev/mapper/cryptroot /mnt/var/log
mount --mkdir -o subvol=@pkg,compress=zstd /dev/mapper/cryptroot /mnt/var/cache/pacman/pkg
mount /dev/nvme0n1p1 /mnt/boot
```



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

## 5. Particionado (estilo Omarchy)

```bash
gdisk /dev/nvme0n1
```

| Partición | Tamaño | Tipo | Código GPT |
|---|---|---|---|
| `nvme0n1p1` | 1 GiB | EFI System | EF00 |
| `nvme0n1p2` | resto | Linux filesystem | 8300 |



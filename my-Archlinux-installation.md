# Instalación de Arch Linux

## Especificaciones

| Componente | Detalle |
|---|---|
| Modelo | Slimbook EVO (EVO15-A8) |
| CPU | AMD Ryzen 7 8845HS (16) @ 5.14 GHz |
| GPU | AMD Radeon 780M Graphics |
| RAM | 60.61 GiB |
| Almacenamiento | NVMe 3.6 TB |
| Pantalla | 2560×1600 @ 120 Hz (integrada) · 1920×1080 @ 60 Hz (externa) |
| Sist. operativo | Arch Linux x86_64 |
| Kernel | Linux 7.0.12-arch1-1 |
| WM | Hyprland 0.55.4 (Wayland) |

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



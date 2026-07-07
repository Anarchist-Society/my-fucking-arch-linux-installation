# My Fucking Arch Linux Installation

<p align="center">
  <img src="https://archlinux.org/static/logos/archlinux-logo-light-scalable.svg" alt="Arch Linux light" width="400"/>
</p>

Guías de instalación y configuración de **Arch Linux** con **LUKS2 + btrfs + Limine** para un **Slimbook EVO (EVO15-A8)** ([slimbook.com](https://slimbook.com/en/evo-8845hs)).

Este repositorio documenta la instalación de Arch Linux en mi **Slimbook EVO (EVO15-A8)**, un ultrabook de aluminio con **AMD Ryzen 7 8845HS** (8 núcleos físicos, 16 hilos de ejecución, hasta 5.1 GHz), **AMD Radeon 780M**, 64 GB DDR5 y un Samsung SSD 990 PRO 4 TB. El setup combina **LUKS2** para cifrado completo del disco, **btrfs** con subvolúmenes planos y compresión zstd, **Limine** como bootloader UEFI (sin dependencia de NVRAM), y **Hyprland** sobre Wayland como escritorio, con **PipeWire** para audio, **iwd + systemd-networkd** para red y **Paru** como helper AUR.

## My Fucking Hardware

| Componente | Especificación |
|---|---|
| CPU | AMD Ryzen 7 8845HS |
| GPU | AMD Radeon 780M |
| RAM | 64 GB |
| Almacenamiento | Samsung SSD 990 PRO 4 TB |
| Pantalla | 2560×1600 @ 120 Hz |

## My Fucking Stack

| Componente | Tecnología |
|---|---|
| Sistema | Arch Linux |
| Cifrado | LUKS2 |
| Filesystem | btrfs (subvolúmenes planos) |
| Bootloader | Limine (UEFI, sin NVRAM) |
| Initramfs | mkinitcpio |
| Display | Hyprland (Wayland) |
| Audio | PipeWire + WirePlumber |
| Red | iwd + systemd-networkd |
| AUR | Paru |

## Guías

| Guía | Descripción |
|---|---|
| [Instalación principal](my-arch-linux-installation.md) | Particionado, LUKS2, btrfs, Limine, red y servicios base |
| [Audio](post-install-audio.md) | PipeWire, WirePlumber, pipewire-pulse y sof-firmware |
| [Red](post-install-iwctl.md) | iwd + systemd-networkd para ethernet, Wi-Fi y WWAN |
| [Hooks de mkinitcpio](post-install-hooks.md) | Hooks del initramfs (encrypt, resume, microcode, etc.) |
| [zram](post-install-zram.md) | Swap comprimido en RAM con zram-generator |
| [Hibernación](post-install-hibernate.md) | Swapfile en btrfs, resume hook y resume_offset |
| [Usuarios](post-install-users.md) | Creación de usuario no-root y sudo |
| [AUR](post-install-aur.md) | Helper AUR y paquetes AUR |
| [AUR](post-install-aur.md) | Paquetes desde AUR (Brave, LocalSend) |
| [Drivers gráficos](post-install-graphics.md) | Mesa + vulkan-radeon para AMD Radeon |
| [Hyprland](post-install-hyprland.md) | Compositor Wayland + Hyprlauncher + Hyprpaper |
| [Utilidades sistema](post-install-system-utilities.md) | Brillo y Bluetooth |
| [Actualizaciones](post-install-updates.md) | Comando de actualización del sistema con parámetros largos |
| [Programas](post-install-programs.md) | Software adicional |

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

## My Fucking Dotfiles

Las configuraciones viven en este repositorio y se enlazan simbólicamente en el sistema, de modo que cualquier cambio en el repo se aplica directamente.

| Configuración | Enlace en el sistema | Archivo en el repo |
|---|---|---|
| Bash | `~/.bashrc` | [`bashrc.sh`](bashrc.sh) |
| Hyprland | `~/.config/hypr/hyprland.lua` | [`hyprland.lua`](hyprland.lua) |
| kitty | `~/.config/kitty/kitty.conf` | [`kitty.conf`](kitty.conf) |
| Yazi | `~/.config/yazi/yazi.toml` | [`yazi.toml`](yazi.toml) |

Ejecuta los comandos desde la raíz de este repositorio.

```bash
# Bash
ln -sf "$(pwd)/bashrc.sh" ~/.bashrc
```

```bash
# Hyprland
mkdir --parents ~/.config/hypr
ln -sf "$(pwd)/hyprland.lua" ~/.config/hypr/hyprland.lua
```

```bash
# kitty
mkdir --parents ~/.config/kitty
ln -sf "$(pwd)/kitty.conf" ~/.config/kitty/kitty.conf
```

```bash
# Yazi
mkdir --parents ~/.config/yazi
ln -sf "$(pwd)/yazi.toml" ~/.config/yazi/yazi.toml
```

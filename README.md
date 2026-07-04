# my-fucking-arch-linux-installation

Guías de instalación y configuración de **Arch Linux** con **LUKS2 + btrfs + Limine** para un **Slimbook EVO (EVO15-A8)**.

## Hardware

| Componente | Especificación |
|---|---|
| CPU | AMD Ryzen 7 8845HS |
| GPU | AMD Radeon 780M |
| RAM | 64 GB |
| Almacenamiento | Samsung SSD 990 PRO 4 TB |
| Pantalla | 2560×1600 @ 120 Hz |

## Stack

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
| [Paru](post-install-paru.md) | Instalación del helper AUR desde fuente |
| [AUR](post-install-aur.md) | Paquetes desde AUR (Brave, LocalSend) |
| [Drivers gráficos](post-install-graphics.md) | Mesa + vulkan-radeon para AMD Radeon |
| [Hyprland](post-install-hyprland.md) | Compositor Wayland + Hyprlauncher |
| [Brillo](post-install-brightnessctl.md) | Control de retroiluminación con brightnessctl |
| [Programas](post-install-programs.md) | Software adicional (opencode) |

---

Hecho con ❤️ para no tener que volver a googlearlo todo.

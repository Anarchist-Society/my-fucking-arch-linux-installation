# Post-instalación: brightnessctl

## brightnessctl

[brightnessctl](https://github.com/Hummer12007/brightnessctl) — herramienta de línea de comandos para leer y ajustar el brillo de dispositivos en Linux. Modifica valores directamente en `/sys/class/backlight/`, por lo que funciona tanto en X11 como en Wayland (o sin servidor gráfico). Soporta backlights de pantalla, retroiluminación de teclado y LEDs.

```bash
# Instalar brightnessctl
sudo pacman --sync brightnessctl
```

| Paquete | Propósito |
|---------|-----------|
| `brightnessctl` | Control de brillo ligero vía /sys/class/backlight/ |

### Comandos básicos

```bash
# Ver nivel actual y máximo
brightnessctl get
brightnessctl max

# Establecer brillo al 50 %
brightnessctl set 50%

# Subir/bajar 10 puntos porcentuales
brightnessctl set +10%
brightnessctl set 10%-

# Usar dispositivo específico (si hay varios)
brightnessctl --device='amdgpu_bl1' set 50%
```

### Más información

- [ArchWiki — Backlight](https://wiki.archlinux.org/title/Backlight)

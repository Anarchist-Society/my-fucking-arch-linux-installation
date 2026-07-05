# Post-instalación: brightnessctl

## brightnessctl

[brightnessctl](https://github.com/Hummer12007/brightnessctl) — herramienta de línea de comandos para leer y ajustar el brillo de dispositivos en Linux. Modifica valores directamente en `/sys/class/backlight/`, por lo que funciona tanto en X11 como en Wayland (o sin servidor gráfico). Soporta backlights de pantalla, retroiluminación de teclado y LEDs.

```bash
# Instalar brightnessctl
sudo pacman --sync brightnessctl
```

### Verificar dispositivo detectado

```bash
# Muestra el dispositivo activo, brillo actual, máximo y clase
brightnessctl info
```

### Nota sobre permisos

Con systemd/logind no hace falta estar en el grupo `video`; el acceso de escritura a los backlights se otorga automáticamente via ACLs al iniciar sesión local.

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

| Paquete | Propósito |
|---------|-----------|
| `brightnessctl` | Control de brillo ligero vía /sys/class/backlight/ |

### Atajo de teclado (Hyprland)

```lua
-- ~/.config/hypr/hyprland.lua
local mainMod = "SUPER"
hl.bind(mainMod .. "+ F5", hl.dsp.exec_cmd("brightnessctl set 5%-"))
hl.bind(mainMod .. "+ F6", hl.dsp.exec_cmd("brightnessctl set +5%"))
```

| Atajo | Acción |
|-------|--------|
| <kbd>SUPER</kbd> + <kbd>F5</kbd> | Bajar brillo 5 % |
| <kbd>SUPER</kbd> + <kbd>F6</kbd> | Subir brillo 5 % |

### Más información

- [ArchWiki — Backlight](https://wiki.archlinux.org/title/Backlight)

# Post-instalación: Hyprland

## Hyprland

[Hyprland](https://wiki.archlinux.org/title/Hyprland) es un compositor Wayland dinámico con animaciones fluidas, renderizado optimizado y configuración en texto plano. Arranca desde TTY sin necesidad de display manager.

```bash
# Instalar Hyprland
sudo pacman --sync hyprland
```

| Paquete | Propósito |
|---------|-----------|
| `hyprland` | Compositor Wayland dinámico con animaciones, renderizado optimizado y configuración en texto plano |

## Hyprlauncher

[Hyprlauncher](https://github.com/hyprwm/hyprlauncher) — [Documentación](https://wiki.hypr.land/Hypr-Ecosystem/hyprlauncher/). Lanzador de aplicaciones multipropósito para Hyprland con búsqueda dinámica y atajo por teclado.

```bash
# Instalar Hyprlauncher
sudo pacman --sync hyprlauncher
```

| Paquete | Propósito |
|---------|-----------|
| `hyprlauncher` | Lanzador de aplicaciones minimalista para Hyprland con búsqueda dinámica |

### Atajo de teclado

```lua
-- ~/.config/hypr/hyprland.lua
local mainMod = "SUPER"
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd("hyprlauncher"))
```

| Atajo | Acción |
|-------|--------|
| <kbd>SUPER</kbd> + <kbd>Space</kbd> | Abrir Hyprlauncher |

## Hyprpaper

[Hyprpaper](https://github.com/hyprwm/hyprpaper) — [Documentación](https://wiki.hypr.land/Hypr-Ecosystem/hyprpaper/). Gestor de fondos de pantalla para Hyprland, rápido y con soporte para múltiples monitores.

```bash
# Instalar Hyprpaper
sudo pacman --sync hyprpaper
```

| Paquete | Propósito |
|---------|-----------|
| `hyprpaper` | Gestor de fondos de pantalla para Hyprland |

### Configuración

Crear el archivo `~/.config/hypr/hyprpaper.conf`:

```
# ~/.config/hypr/hyprpaper.conf
preload = ~/Pictures/wallpapers/mi-fondo.jpg
wallpaper = , ~/Pictures/wallpapers/mi-fondo.jpg
```

| Opción | Función |
|--------|---------|
| `preload` | Precarga la imagen en memoria para cambio instantáneo |
| `wallpaper` | Asigna la imagen a un monitor (`MONITOR, ruta`). `,` aplica a todos los monitores |

### Spawn con Hyprland

```lua
-- ~/.config/hypr/hyprland.lua
hl.spawn_along("hyprpaper")
```

Hyprpaper arranca automáticamente junto con Hyprland al usar `spawn_along`.

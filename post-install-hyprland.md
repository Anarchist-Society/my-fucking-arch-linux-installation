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
wallpaper {
    monitor = 
    path = ~/Pictures/Wallpapers/
    timeout = 60
}
```

| Opción | Función |
|--------|---------|
| `monitor` | Monitor específico (`DP-1`, `HDMI-A-1`) o vacío para todos |
| `path` | Carpeta donde están los fondos de pantalla |
| `timeout` | Segundos entre cambio de fondo (default: 30) |

Hyprpaper rotará automáticamente entre todas las imágenes de la carpeta cada `timeout` segundos.

### Modos de ajuste

Agregar `fit` al bloque para controlar cómo se escalan las imágenes:

```
wallpaper {
    monitor = 
    path = ~/Pictures/Wallpapers/
    timeout = 60
    fit = cover
}
```

| `fit` | Función |
|-------|---------|
| `cover` | Rellena el monitor (default, recorta bordes) |
| `contain` | Muestra la imagen completa (puede haber bordes negros) |
| `fill` | Estira la imagen para llenar todo |
| `tile` | Repite la imagen en mosaico |

### Autostart

Hyprpaper debe ejecutarse al iniciar Hyprland. Agregar al archivo `~/.config/hypr/hyprland.lua`:

```lua
-- ~/.config/hypr/hyprland.lua
hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpaper")
end)
```

| Fuente | Método |
|--------|--------|
| [Hyprland Wiki — Autostart](https://wiki.hypr.land/Configuring/Basics/Autostart) | `hl.on("hyprland.start", ...)` |
| [Hyprland Wiki — hyprpaper](https://wiki.hypr.land/Hypr-Ecosystem/hyprpaper) | systemd: `systemctl --user enable --now hyprpaper.service` |

## Referencias

| Documento | Enlace |
|-----------|--------|
| Hyprland Wiki — Autostart | https://wiki.hypr.land/Configuring/Basics/Autostart |
| Hyprland Wiki — hyprpaper | https://wiki.hypr.land/Hypr-Ecosystem/hyprpaper |
| Hyprpaper GitHub | https://github.com/hyprwm/hyprpaper |
| Hyprlauncher GitHub | https://github.com/hyprwm/hyprlauncher |

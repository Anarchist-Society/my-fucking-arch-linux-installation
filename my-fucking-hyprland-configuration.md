# my-fucking-hyprland-configuration

## Hyprland

[Hyprland](https://wiki.archlinux.org/title/Hyprland) es un compositor Wayland dinámico. Arranca desde TTY sin display manager.

```bash
# Instalar Hyprland
sudo pacman --sync hyprland
```

## Hyprpaper

[Hyprpaper](https://github.com/hyprwm/hyprpaper) es un gestor de fondos de pantalla para Hyprland.

```bash
# Instalar Hyprpaper
sudo pacman --sync hyprpaper
```

### Configuración

Crear `~/.config/hypr/hyprpaper.conf`:

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
| `monitor` | Monitor específico o vacío para todos |
| `path` | Carpeta de fondos de pantalla |
| `timeout` | Segundos entre cambios |

### Autostart

Agregar a `~/.config/hypr/hyprland.lua`:

```lua
hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpaper")
end)
```

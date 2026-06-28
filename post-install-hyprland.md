# Post-instalación: Hyprland

## Hyprland

[Hyprland](https://wiki.archlinux.org/title/Hyprland) es un compositor Wayland dinámico.

```bash
pacman -S hyprland
```

## Configuración mínima

```bash
mkdir --parents ~/.config/hypr
vim ~/.config/hypr/hyprland.conf
```

```
monitor=eDP-1,2560x1600@120,0x0,1

input {
    kb_layout=es
    follow_mouse=1
}

$terminal = kitty
$menu = wofi --show drun

bind = SUPER, Return, exec, $terminal
bind = SUPER, Q, killactive,
bind = SUPER, D, exec, $menu
bind = SUPER, 1-9, workspace, 1-9
bind = SUPER SHIFT, 1-9, movetoworkspace, 1-9
bind = SUPER, F, fullscreen,

bindm = SUPER, mouse:272, movewindow
bindm = SUPER, mouse:273, resizewindow

exec-once = waybar
exec-once = dunst
```

## Audio

[PipeWire](https://wiki.archlinux.org/title/PipeWire) reemplaza PulseAudio.

```bash
pacman -S pipewire wireplumber pipewire-pulse
```

## Inicio de sesión

Opción recomendada: iniciar Hyprland manualmente desde la TTY al arrancar:

```bash
# En ~/.bash_profile o ~/.zprofile
if [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    exec Hyprland
fi
```

O instalar [uwsm](https://wiki.archlinux.org/title/UWSM) (como Omarchy):

```bash
pacman -S uwsm
```

## Siguientes pasos

Paquetes opcionales para un escritorio funcional:

- `kitty` o `alacritty` — terminal
- `waybar` — barra de estado
- `wofi` — lanzador de aplicaciones
- `dunst` — notificaciones
- `grim` + `slurp` + `swappy` — capturas de pantalla
- `wl-clipboard` — portapapeles Wayland
- `thunar` o `dolphin` — gestor de archivos
- `polkit-kde-agent` — diálogos de permisos
- `ttf-jetbrains-mono` — fuente monoespaciada
- `firefox` o `chromium` — navegador

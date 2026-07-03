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

```bash
# ~/.config/hypr/hyprland.conf
bind = SUPER, Return, exec, hyprlauncher
```

| Atajo | Acción |
|-------|--------|
| <kbd>SUPER</kbd> + <kbd>Enter</kbd> | Abrir Hyprlauncher |

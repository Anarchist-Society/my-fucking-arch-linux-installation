# Post-instalación: Autologin en TTY + Hyprland

Alternativa a SDDM: iniciar sesión automáticamente en la TTY y lanzar Hyprland sin display manager. Esto evita dependencias Qt, acelera el arranque y elimina un servicio del sistema.

## Autologin en TTY1

Configurar `getty` para que haga login automático sin pedir contraseña en `tty1`:

```bash
# Crear el directorio de drop-ins
sudo mkdir --parents /etc/systemd/system/getty@tty1.service.d
```

```ini
# /etc/systemd/system/getty@tty1.service.d/autologin.conf
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --noreset --noclear --autologin anarchist-penguin - $TERM
```

Fuente: [Arch Wiki — Getty #Automatic login to virtual console](https://wiki.archlinux.org/title/Getty#Automatic_login_to_virtual_console)

## Lanzar Hyprland desde .zprofile

Al hacer login en `tty1`, el shell ejecuta `.zprofile`. Ahí se detecta si es la TTY correcta y se arranca Hyprland:

```bash
# ~/.zprofile
if [ -z "${WAYLAND_DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  exec Hyprland
fi
```

Si usas bash en lugar de zsh, usa `~/.bash_profile` en su lugar.

Fuente: [Hyprland Wiki — Master Tutorial #Launching Hyprland](https://wiki.hyprland.org/Getting-Started/Master-Tutorial/#launching-hyprland)

## Comparativa: TTY autologin vs SDDM

| Aspecto | TTY autologin | SDDM |
|---------|---------------|------|
| Dependencias | Solo agetty (incluido en `util-linux`) | Qt6 + SDDM (~200 MB) |
| Arranque | Directo a Hyprland | Pasa por greeter gráfico |
| Servicios | Ninguno adicional | `sddm.service` |
| Recuperación tras crash | Vuelve a TTY, puedes debuggear | Vuelve al greeter gráfico |
| Selector de sesiones | No | Sí |
| Pantalla de login | No (solo texto) | Sí (gráfica, themes) |

## Verificar

```bash
# Recargar systemd para aplicar el drop-in
sudo systemctl daemon-reload

# Ver el estado del servicio
systemctl status getty@tty1.service
```

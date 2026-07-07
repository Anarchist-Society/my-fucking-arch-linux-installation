# Post-instalación: SDDM (display manager)

[SDDM (Simple Desktop Display Manager)](https://wiki.archlinux.org/title/SDDM) es el gestor de sesiones gráfico que muestra la pantalla de inicio de sesión. Omarchy lo recomienda por su compatibilidad con Hyprland y Wayland.

```bash
# Instalar SDDM
sudo pacman --sync sddm
```

| Paquete | Propósito |
|---------|-----------|
| `sddm` | Display manager para X11 y Wayland |

## Autologin

SDDM soporta inicio de sesión automático mediante un archivo de configuración. Se usan **drop-ins** en `/etc/sddm.conf.d/` en lugar de modificar el archivo principal, siguiendo el enfoque de [Omarchy](https://github.com/basecamp/omarchy/blob/dev/install/login/sddm.sh):

```bash
# Crear el directorio de drop-ins si no existe
sudo mkdir --parents /etc/sddm.conf.d
```

```ini
# /etc/sddm.conf.d/autologin.conf
[Autologin]
User=anarchist-penguin
Session=hyprland
```

> Para ver las sesiones disponibles: `ls /usr/share/wayland-sessions/`.

## Configuración Wayland

SDDM puede ejecutarse sobre Wayland para mejor integración con Hyprland:

```ini
# /etc/sddm.conf.d/10-wayland.conf
[General]
DisplayServer=wayland

[Wayland]
CompositorCommand=hyprland
```

## Habilitar el servicio

```bash
# Habilitar SDDM para que arranque automáticamente
sudo systemctl enable sddm.service
```

## Eliminar la promoción de GNOME Keyring (opcional)

Para evitar que se cree un llavero de claves cifradas al iniciar sesión con autologin (lo cual es molesto si no usas GNOME):

```bash
# Eliminar las líneas de gnome-keyring de la configuración PAM de SDDM
sudo sed -i '/-auth.*pam_gnome_keyring\.so/d' /etc/pam.d/sddm
sudo sed -i '/-password.*pam_gnome_keyring\.so/d' /etc/pam.d/sddm
```

Esto es lo que hace [Omarchy por defecto](https://github.com/basecamp/omarchy/blob/dev/install/login/sddm.sh).

## Verificar

```bash
# Comprobar que SDDM está activo y habilitado
systemctl status sddm.service
```

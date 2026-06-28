# Post-instalación: Usuarios

[Sudo (Arch Wiki)](https://wiki.archlinux.org/title/Sudo). Creación de usuario y configuración de sudo mediante `sudoers.d` sin grupo `wheel`, siguiendo el principio de mínimos privilegios.

```bash
# Instalar sudo
pacman -S sudo

# Contraseña de root
passwd

# Crear usuario
useradd --create-home anarchist-penguin

# Contraseña del usuario
passwd anarchist-penguin

# Dar permisos sudo al usuario
echo "anarchist-penguin ALL=(ALL) ALL" > /etc/sudoers.d/00-anarchist-penguin
chmod 440 /etc/sudoers.d/00-anarchist-penguin
```

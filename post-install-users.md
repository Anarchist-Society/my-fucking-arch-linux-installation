# Post-instalación: Usuarios

[Sudo (Arch Wiki)](https://wiki.archlinux.org/title/Sudo). Creación de usuario y configuración de sudo mediante `sudoers.d` sin grupo `wheel`, siguiendo el principio de mínimos privilegios.

```bash
# Instalar sudo
pacman --sync sudo

# Contraseña de root (si no se estableció durante la instalación)
passwd

# Crear usuario
useradd --create-home anarchist-penguin

# Contraseña del usuario
passwd anarchist-penguin

# Dar permisos sudo al usuario
echo "anarchist-penguin ALL=(ALL) ALL" > /etc/sudoers.d/00-anarchist-penguin
chmod --changes 440 /etc/sudoers.d/00-anarchist-penguin

# Verificar que la configuración de sudo es correcta
visudo -c
```

| Paquete | Propósito |
|---------|-----------|
| `sudo` | Ejecutar comandos con privilegios de otro usuario (normalmente root) |

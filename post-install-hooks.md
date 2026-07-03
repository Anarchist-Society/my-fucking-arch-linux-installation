# Post-instalación: Hooks de mkinitcpio

[Mkinitcpio (Arch Wiki)](https://wiki.archlinux.org/title/Mkinitcpio). Los hooks de mkinitcpio definen qué módulos y herramientas se incluyen en el initramfs. Se configuran mediante drop-ins en `/etc/mkinitcpio.conf.d/` para no modificar el archivo principal.

```bash
# Crear el directorio de drop-ins si no existe
sudo mkdir --parents /etc/mkinitcpio.conf.d
# Editar con vim
sudo vim /etc/mkinitcpio.conf.d/archlinux-hooks.conf
```

Añadir los hooks base:

```bash
# Hooks base para LUKS + btrfs + microcode
HOOKS=(base udev autodetect microcode modconf kms keyboard keymap block encrypt filesystems fsck)
```

| Paquete | Propósito |
|---------|-----------|
| (ninguno — incluido en `mkinitcpio`) | |

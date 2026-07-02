# Post-instalación: Hibernación

[Hibernation (Arch Wiki)](https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Hibernation)

La hibernación guarda el contenido de la RAM en el swap y apaga el equipo. Al encender, el kernel restaura el estado guardado. Requiere un swapfile del tamaño de la RAM, el hook `resume` en mkinitcpio y los parámetros `resume=` y `resume_offset=` en el cmdline del kernel.

```bash
# Crear subvolumen Btrfs dedicado para swap
sudo btrfs subvolume create /swap

# Crear swapfile del tamaño exacto de la RAM
sudo btrfs filesystem mkswapfile --size 60g --uuid clear /swap/swapfile
```

### fstab

```bash
# Swapfile en subvolumen Btrfs dedicado para hibernación
/swap/swapfile  none  swap  defaults,pri=0  0  0
```

```bash
# Activar swap con prioridad baja para que zram se use primero
sudo swapon -p 0 /swap/swapfile
```

### mkinitcpio

Crear `/etc/mkinitcpio.conf.d/resume.conf`:

```bash
# Añadir resume después de encrypt (necesita /dev/mapper/cryptroot)
HOOKS=(base udev autodetect microcode modconf kms keyboard keymap block encrypt resume filesystems fsck)
```

### Calcular el offset del swapfile

```bash
# Obtener el offset físico necesario para resume_offset=
sudo btrfs inspect-internal map-swapfile /swap/swapfile
```

### Limine

Editar `/etc/default/limine` y añadir al final de `KERNEL_CMDLINE[default]=`:

```bash
KERNEL_CMDLINE[default]="... resume=/dev/mapper/cryptroot resume_offset=<N>"
```

### Reconstruir initramfs

```bash
# Reconstruir initramfs con el hook resume y actualizar el bootloader
sudo limine-update
```

### Probar

```bash
# Probar hibernación (guarda RAM en swap y apaga)
systemctl hibernate

# Probar suspensión (RAM, sin apagar)
systemctl suspend
```

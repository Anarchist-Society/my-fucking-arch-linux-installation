# Post-instalación: Hibernación

[Hibernation (Arch Wiki)](https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Hibernation) + [Btrfs swap file (Arch Wiki)](https://wiki.archlinux.org/title/Btrfs#Swap_file)

La hibernación guarda el contenido de la RAM en el swap y apaga el equipo. Al encender, el kernel restaura el estado guardado. Requiere un swapfile del tamaño de la RAM, el hook `resume` en mkinitcpio y los parámetros `resume=` y `resume_offset=` en el cmdline del kernel.

```bash
# Crear subvolumen Btrfs dedicado para swap
sudo btrfs subvolume create /swap

# Crear swapfile del tamaño exacto de la RAM
sudo btrfs filesystem mkswapfile --size 60g --uuid clear /swap/swapfile
```

### Activar swap

```bash
# Activar swap con prioridad baja para que zram se use primero
sudo swapon -p 0 /swap/swapfile
```

### fstab

Editar `/etc/fstab` con `vim` y añadir:

```bash
# Btrfs swapfile for system hibernation
/swap/swapfile none swap defaults,pri=0 0 0
```

### mkinitcpio

Crear el fichero con `vim`:

```bash
# Crear el directorio de drop-ins si no existe
sudo mkdir --parents /etc/mkinitcpio.conf.d

# Editar con vim (se crea automáticamente al guardar)
sudo vim /etc/mkinitcpio.conf.d/archlinux-resume.conf
```

Añadir el hook `resume` dentro de `HOOKS`:

```ini
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
# Añadir los parámetros de reanudación para hibernación
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

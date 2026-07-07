# Post-instalación: Hibernación

La [hibernación](https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Hibernation) guarda el contenido de la RAM en el swap y apaga el equipo. Al encender, el kernel restaura el estado guardado. Requiere un [swapfile en btrfs](https://wiki.archlinux.org/title/Btrfs#Swap_file) del tamaño de la RAM, el hook `resume` en mkinitcpio y los parámetros `resume=` y `resume_offset=` en el cmdline del kernel.

### Crear subvolumen y swapfile

Btrfs requiere un subvolumen dedicado para alojar el swapfile, y el swapfile debe tener al menos el tamaño de la RAM (64 GB) para que quepa el contenido completo al hibernar. — [Btrfs#Swap_file](https://wiki.archlinux.org/title/Btrfs#Swap_file)

```bash
# Crear subvolumen Btrfs dedicado para swap
sudo btrfs subvolume create /swap

# Crear swapfile del tamaño exacto de la RAM
sudo btrfs filesystem mkswapfile --size 64g --uuid clear /swap/swapfile
```

### Activar swap

Hay que activar el swap para que el sistema pueda escribir en él durante la hibernación. — [Power_management/Suspend_and_hibernate#Hibernation](https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Hibernation)

```bash
# Activar swap para hibernación
sudo swapon /swap/swapfile
```

### fstab

Se añade a `/etc/fstab` para que el swap se active automáticamente en cada arranque. — [Fstab](https://wiki.archlinux.org/title/Fstab)

```bash
# Añadir entrada de swap al fstab para montaje automático al arrancar
/swap/swapfile none swap defaults,pri=0 0 0
```

### mkinitcpio (hook resume)

El hook `resume` en el initramfs es necesario para que el kernel pueda restaurar el estado del sistema desde el swap al encender después de una hibernación. — [Mkinitcpio#HOOKS](https://wiki.archlinux.org/title/Mkinitcpio#HOOKS)

Según la [ArchWiki](https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Configure_the_initramfs), en sistemas con cifrado (dm-crypt) el hook `resume` debe colocarse **después del hook `encrypt`**. El ejemplo oficial para sistemas sin cifrar lo sitúa tras `filesystems`, por lo que el orden completo con LUKS + Plymouth queda:

```init
HOOKS=(base udev keyboard autodetect microcode modconf kms keymap consolefont block plymouth encrypt filesystems resume fsck)
```

Para evitar conflictos entre múltiples drop-ins, se usa un solo archivo con prefijo `zzz` que contenga todos los hooks:

```bash
# Crear el directorio de drop-ins si no existe
sudo mkdir --parents /etc/mkinitcpio.conf.d

# Crear drop-in único con todos los hooks (incluyendo resume)
sudo tee /etc/mkinitcpio.conf.d/zzz-hooks.conf << 'EOF'
HOOKS=(base udev keyboard autodetect microcode modconf kms keymap consolefont block plymouth encrypt filesystems resume fsck)
EOF

# Eliminar drop-ins redundantes que definan HOOKS
sudo rm /etc/mkinitcpio.conf.d/archlinux-hooks.conf /etc/mkinitcpio.conf.d/plymouth.conf /etc/mkinitcpio.conf.d/archlinux-resume.conf 2>/dev/null
```

### Calcular el offset del swapfile

En btrfs, el swapfile no está en una posición fija en el disco, por lo que el kernel necesita el offset físico para localizarlo al reanudar. — [Btrfs#Swap_file](https://wiki.archlinux.org/title/Btrfs#Swap_file)

```bash
# Obtener el offset físico del swapfile para el parámetro resume_offset=
sudo btrfs inspect-internal map-swapfile /swap/swapfile
```

### Limine (parámetros del kernel)

Hay que pasarle al kernel la ruta del dispositivo de swap (`resume=`) y el offset físico (`resume_offset=`) para que sepa dónde está guardado el estado de hibernación. — [Suspend_and_hibernate#Hibernation](https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Hibernation)

Editar `/boot/limine.conf` y añadir al final de la línea `cmdline`:

```bash
# /boot/limine.conf
cmdline: ... resume=/dev/mapper/cryptroot resume_offset=<N>
```

### Reconstruir initramfs

Después de añadir el hook `resume` hay que regenerar el initramfs para que lo incluya. — [Mkinitcpio](https://wiki.archlinux.org/title/Mkinitcpio)

```bash
# Reconstruir initramfs para incluir el nuevo hook resume
sudo mkinitcpio -P
```

### Probar

Verificar que la hibernación funciona correctamente: — [Power_management/Suspend_and_hibernate](https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate)

```bash
# Probar hibernación (guarda la RAM en el swap y apaga el equipo)
systemctl hibernate

# Probar suspensión (mantiene la RAM encendida, consumo mínimo)
systemctl suspend
```

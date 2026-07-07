# Post-instalación: Hibernación

La [hibernación](https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Hibernation) guarda el contenido de la RAM en el swap y apaga el equipo. Al encender, el kernel restaura el estado guardado. Requiere un [swapfile en btrfs](https://wiki.archlinux.org/title/Btrfs#Swap_file) del tamaño de la RAM, el hook `resume` en mkinitcpio y los parámetros `resume=` y `resume_offset=` en el cmdline del kernel.

### Crear subvolumen y swapfile

Btrfs requiere un subvolumen dedicado para alojar el swapfile, y el swapfile debe tener al menos el tamaño de la RAM (60 GiB) para que quepa el contenido completo al hibernar. — [Btrfs#Swap_file](https://wiki.archlinux.org/title/Btrfs#Swap_file)

```bash
# Crear subvolumen Btrfs dedicado para swap
sudo btrfs subvolume create /swap

# Crear swapfile del tamaño exacto de la RAM
sudo btrfs filesystem mkswapfile --size 60g --uuid clear /swap/swapfile
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

Según la [ArchWiki](https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Configure_the_initramfs):

> When using a busybox-based initramfs, the resume hook is required in /etc/mkinitcpio.conf. Whether by label or by UUID, the swap partition is referred to with a udev device node, so the resume hook must follow the udev hook. For example:
> `HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block filesystems resume fsck)`

En sistemas con cifrado LUKS se intercala `encrypt` antes de `filesystems`, y con Plymouth se añade `plymouth` antes de `encrypt`. El orden completo queda:

```init
HOOKS=(base udev keyboard autodetect microcode modconf kms keymap consolefont block plymouth encrypt filesystems resume fsck)
```

Asegúrate de que tu drop-in de hooks (ej. `archlinux-hooks.conf`) incluya `resume` en esa posición. Consulta [Hooks de mkinitcpio](post-install-hooks.md) para la configuración completa.

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

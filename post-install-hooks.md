# Post-instalación: Hooks de mkinitcpio

[Mkinitcpio (Arch Wiki)](https://wiki.archlinux.org/title/Mkinitcpio). Los hooks de mkinitcpio definen qué módulos y herramientas se incluyen en el initramfs — el sistema de archivos temporal que se carga en memoria al arrancar para montar la raíz y descifrar LUKS.

## Drop-ins (`/etc/mkinitcpio.conf.d/`)

Para no modificar el archivo principal `/etc/mkinitcpio.conf`, puedes usar **drop-ins** en `/etc/mkinitcpio.conf.d/`. Está documentado en la [sección de configuración de mkinitcpio (Arch Wiki)](https://wiki.archlinux.org/title/Mkinitcpio#Configuration) y en la [página de manual `mkinitcpio.conf(5)`](https://man.archlinux.org/man/mkinitcpio.conf.5).

```bash
# Crear el directorio de drop-ins si no existe
sudo mkdir --parents /etc/mkinitcpio.conf.d

# Editar o crear un drop-in
sudo vim /etc/mkinitcpio.conf.d/archlinux-hooks.conf
```

Los drop-ins son archivos `.conf` que se fusionan con `/etc/mkinitcpio.conf` automáticamente. Puedes tener varios drop-ins para organizar la configuración (uno para hooks, otro para módulos, etc.).

> **Aviso**: Si el preset del kernel (`/etc/mkinitcpio.d/linux.preset`) contiene la línea `ALL_config="/etc/mkinitcpio.conf"`, los drop-ins **no se cargan** (versiones de mkinitcpio anteriores a la 36). En ese caso, comenta la línea con `# ALL_config="/etc/mkinitcpio.conf"` para habilitarlos. [(Arch Wiki — Mkinitcpio#Configuration)](https://wiki.archlinux.org/title/Mkinitcpio#Configuration)

### Orden de precedencia

- `/etc/mkinitcpio.conf.d/*.conf` tiene **prioridad** sobre `/etc/mkinitcpio.conf`
- Si varios drop-ins definen la misma variable, **gana el último alfabéticamente**
- Puedes usar `--dropin /etc/mkinitcpio.conf.d/<nombre>.conf` al regenerar para usar un drop-in específico

### Revisar configuraciones activas

```bash
# Listar drop-ins existentes
ls /etc/mkinitcpio.conf.d/

# Ver la configuración fusionada (todos los drop-ins + archivo principal)
mkinitcpio --config /etc/mkinitcpio.conf --docker
```

## Configuración base para LUKS + btrfs

```
# /etc/mkinitcpio.conf.d/archlinux-hooks.conf

HOOKS=(base udev autodetect microcode modconf kms keyboard keymap block encrypt filesystems fsck)
```

### Explicación de cada hook

Consulta la [tabla de hooks en la guía principal](my-arch-linux-installation.md#initramfs) para la descripción detallada de cada uno.

## Otras variantes

### Con systemd (sd-encrypt)

Si prefieres el initramfs basado en systemd en lugar de busybox:

```
HOOKS=(base systemd autodetect microcode modconf kms keyboard sd-vconsole block sd-encrypt filesystems fsck)
```

| Hook busybox | Hook systemd | Diferencia |
|---|---|---|
| `udev` | `systemd` | systemd incluye udev internamente |
| `keymap` + `consolefont` | `sd-vconsole` | Unificado en un solo hook |
| `encrypt` | `sd-encrypt` | Soporta TPM2, FIDO2, keyfiles |

### Con LVM

Si usas LVM además de LUKS, añade `lvm2`:

```
HOOKS=(base udev autodetect microcode modconf kms keyboard keymap block lvm2 encrypt filesystems fsck)
```

Requiere el paquete `lvm2`.

## Regenerar el initramfs

Tras cualquier cambio en los hooks, regenera el initramfs:

```bash
sudo mkinitcpio -P
```

## Verificar hooks y módulos

```bash
# Ayuda de un hook específico
mkinitcpio -H encrypt

# Listar módulos incluidos en la imagen actual
mkinitcpio -M

# Ver el contenido del initramfs
lsinitcpio /boot/initramfs-linux.img
```

# Post-instalación: Hooks de mkinitcpio

[Mkinitcpio](https://wiki.archlinux.org/title/Mkinitcpio) es la herramienta que genera el **initramfs** — un sistema de archivos temporal que se carga en memoria durante el arranque. Contiene los módulos del kernel y las utilidades necesarias para acceder al sistema raíz, incluyendo el descifrado LUKS. Los hooks definen qué módulos y herramientas se incluyen en esta imagen.

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
- Los drop-ins se cargan automáticamente al regenerar con `mkinitcpio -P`.

### Revisar configuraciones activas

```bash
# Listar drop-ins existentes
ls /etc/mkinitcpio.conf.d/
```

## Configuración completa para LUKS + btrfs + Plymouth + hibernación

Usar múltiples drop-ins que definan `HOOKS=(...)` hace que el último alfabéticamente sobrescriba a los anteriores. Para evitarlo, se usa un solo drop-in con todos los hooks, usando prefijo `zzz` para que sea el último en cargarse y no sea sobrescrito:

```ini
# /etc/mkinitcpio.conf.d/zzz-hooks.conf
HOOKS=(base udev keyboard autodetect microcode modconf kms keymap consolefont block plymouth encrypt filesystems resume fsck)
```

Eliminar cualquier otro drop-in que defina `HOOKS` para evitar conflictos:

```bash
sudo rm /etc/mkinitcpio.conf.d/archlinux-hooks.conf /etc/mkinitcpio.conf.d/plymouth.conf /etc/mkinitcpio.conf.d/archlinux-resume.conf 2>/dev/null
```

### Orden de los hooks

| Hook | Posición | Motivo | Referencia |
|---|---|---|---|
| `keyboard` | Antes de `autodetect` | Teclado externo USB: `autodetect` debe incluir los módulos USB HID | [Mkinitcpio (Arch Wiki)](https://wiki.archlinux.org/title/Mkinitcpio#Hook_list) |
| `block` | Antes de `encrypt` | Los dispositivos de bloque deben estar disponibles antes de descifrar LUKS | [dm-crypt/System configuration#Examples (Arch Wiki)](https://wiki.archlinux.org/title/Dm-crypt/System_configuration#Examples) |
| `plymouth` | Antes de `encrypt` | Muestra el prompt de contraseña LUKS de forma gráfica | [Plymouth (Arch Wiki)](https://wiki.archlinux.org/title/Plymouth#mkinitcpio) |
| `resume` | Después de `filesystems` | Debe ir después de `encrypt` (dm-crypt) y después de `filesystems` (orden del ejemplo oficial) | [Power management/Suspend and hibernate#Configure the initramfs](https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Configure_the_initramfs) |
| `keymap` | Antes de `consolefont` | El layout español debe cargarse antes de Plymouth | [Omarchy issue #6072](https://github.com/basecamp/omarchy/issues/6072) |

### Explicación de cada hook

Consulta la [tabla de hooks en la guía principal](my-arch-linux-installation.md#initramfs) para la descripción detallada de cada uno.

## Regenerar el initramfs

Tras cualquier cambio en los hooks, regenera el initramfs:

```bash
# Regenerar el initramfs para aplicar los cambios
sudo mkinitcpio -P
```

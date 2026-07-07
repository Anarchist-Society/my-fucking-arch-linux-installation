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

## Configuración base para LUKS + btrfs

```ini
# /etc/mkinitcpio.conf.d/archlinux-hooks.conf
HOOKS=(base udev keyboard autodetect microcode modconf kms keymap consolefont block plymouth encrypt filesystems fsck)
```

### Justificación del orden

| Hook | Posición | Motivo | Referencia |
|---|---|---|---|
| `keyboard` | Antes de `autodetect` | Teclado externo USB: `autodetect` debe incluir los módulos USB HID | [Mkinitcpio (Arch Wiki)](https://wiki.archlinux.org/title/Mkinitcpio#Hook_list) |
| `keymap` | Antes de `plymouth` | El layout español debe cargarse antes de Plymouth para que el prompt LUKS reconozca `KEYMAP=es` | [Omarchy issue #6072](https://github.com/basecamp/omarchy/issues/6072) |
| `block` | Antes de `encrypt` | Los dispositivos de bloque deben estar disponibles antes de descifrar LUKS | [dm-crypt/System configuration#Examples (Arch Wiki)](https://wiki.archlinux.org/title/Dm-crypt/System_configuration#Examples) |
| `plymouth` | Antes de `encrypt` | Muestra el prompt de contraseña LUKS de forma gráfica | [Plymouth (Arch Wiki)](https://wiki.archlinux.org/title/Plymouth#mkinitcpio) |

### Explicación de cada hook

Consulta la [tabla de hooks en la guía principal](my-arch-linux-installation.md#initramfs) para la descripción detallada de cada uno.

| Hook | Propósito |
|---|---|
| `plymouth` | Muestra un splash gráfico de arranque e integra el prompt LUKS de forma gráfica |

## Configuración para hibernación

```ini
# /etc/mkinitcpio.conf.d/archlinux-resume.conf
HOOKS+=(resume)
```

El hook `resume` es necesario para hibernar. Consulta [Hibernación](post-install-hibernate.md) para la configuración completa del swapfile y parámetros del kernel.

## Regenerar el initramfs

Tras cualquier cambio en los hooks, regenera el initramfs:

```bash
# Regenerar el initramfs para aplicar los cambios
sudo mkinitcpio -P
```

## Verificar hooks y módulos

```bash
# Ayuda de un hook específico
mkinitcpio -H encrypt

# Listar módulos incluidos en la imagen actual
mkinitcpio -M


```


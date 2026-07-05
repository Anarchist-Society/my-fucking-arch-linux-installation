# Post-instalación: Plymouth (boot splash)

[Plymouth (Arch Wiki)](https://wiki.archlinux.org/title/Plymouth) es un splash gráfico de arranque que oculta los mensajes del kernel y muestra una animación. También integra el prompt de contraseña LUKS de forma gráfica.

## Instalación

```bash
# Instalar Plymouth para el splash gráfico de arranque
sudo pacman --sync plymouth
```

## Configurar mkinitcpio

Añade el hook `plymouth` **antes de `encrypt`** mediante un drop-in:

```bash
# Crear el drop-in para Plymouth
sudo vim /etc/mkinitcpio.conf.d/plymouth.conf
```

```ini
# /etc/mkinitcpio.conf.d/plymouth.conf

HOOKS=(base udev keyboard autodetect microcode modconf kms keymap block plymouth encrypt filesystems fsck)
```

### Justificación del orden

| Hook | Posición | Motivo | Referencia |
|---|---|---|---|
| `keyboard` | Antes de `autodetect` | Teclado externo USB: `autodetect` debe incluir los módulos USB HID | [Mkinitcpio (Arch Wiki)](https://wiki.archlinux.org/title/Mkinitcpio#Hook_list) |
| `keymap` | Antes de `plymouth` | El layout español debe cargarse antes de Plymouth para que el prompt LUKS reconozca `KEYMAP=es` | [Omarchy issue #6072](https://github.com/basecamp/omarchy/issues/6072) |
| `block` | Antes de `encrypt` | Los dispositivos de bloque deben estar disponibles antes de descifrar LUKS | [dm-crypt/System configuration#Examples (Arch Wiki)](https://wiki.archlinux.org/title/Dm-crypt/System_configuration#Examples) |
| `plymouth` | Antes de `encrypt` | Muestra el prompt de contraseña LUKS de forma gráfica | [Plymouth (Arch Wiki)](https://wiki.archlinux.org/title/Plymouth#mkinitcpio) |

Para más información sobre el sistema de drop-ins, consulta la [guía de post-instalación de hooks](post-install-hooks.md).

## Configurar el bootloader (Limine)

Añade `splash` y opcionalmente `quiet` a los parámetros del kernel en `/boot/limine.conf`:

```ini
cmdline: cryptdevice=PARTUUID=<PARTUUID>:cryptroot root=/dev/mapper/cryptroot rw rootflags=subvol=@ rootfstype=btrfs splash quiet
```

- `splash` — activa Plymouth
- `quiet` — oculta los mensajes del kernel (opcional)

## HiDPI

Para tu pantalla 2560×1600, configura el factor de escala en `/etc/plymouth/plymouthd.conf`:

```ini
[Daemon]
Theme=spinner
DeviceScale=2
```

`DeviceScale=2` duplica el tamaño de la animación para que no se vea pequeña en pantallas de alta densidad.

### Temas disponibles

| Tema | Descripción |
|---|---|
| `spinner` | Simple, con un spinner de carga |
| `bgrt` | Similar a spinner pero con el logo del fabricante (OEM) |
| `solar` | Tema espacial con una estrella azul |
| `glow` | Corporativo, con gráfico de progreso circular |
| `fade-in` | Fundido con estrellas |
| `spinfinity` | Símbolo de infinito giratorio |

```bash
# Listar temas instalados
plymouth-set-default-theme -l

# Cambiar tema y regenerar initramfs
sudo plymouth-set-default-theme -R spinner
```

## Regenerar initramfs

```bash
sudo mkinitcpio -P
```

## Previsualizar el tema

```bash
sudo plymouthd; sudo plymouth --show-splash; sleep 5; sudo plymouth --quit
```

## Desactivar Plymouth temporalmente

Si algo falla, añade estos parámetros al kernel en Limine:

```ini
plymouth.enable=0 disablehooks=plymouth
```

## Referencias

- [Plymouth (Arch Wiki)](https://wiki.archlinux.org/title/Plymouth)
- [Mkinitcpio (Arch Wiki)](https://wiki.archlinux.org/title/Mkinitcpio)
- [Mkinitcpio#Configuration (Arch Wiki)](https://wiki.archlinux.org/title/Mkinitcpio#Configuration)
- [Linux console/Keyboard configuration (Arch Wiki)](https://wiki.archlinux.org/title/Linux_console/Keyboard_configuration)
- [Silent boot (Arch Wiki)](https://wiki.archlinux.org/title/Silent_boot)
- [Omarchy issue #6072 — Plymouth LUKS prompt keymap bug](https://github.com/basecamp/omarchy/issues/6072)
- [Guía de post-instalación de hooks](post-install-hooks.md)

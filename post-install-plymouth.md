# Post-instalación: Plymouth (boot splash)

[Plymouth (Arch Wiki)](https://wiki.archlinux.org/title/Plymouth) es un splash gráfico de arranque que oculta los mensajes del kernel y muestra una animación. También integra el prompt de contraseña LUKS de forma gráfica.

## Instalación

```bash
# Instalar Plymouth para el splash gráfico de arranque
sudo pacman --sync plymouth
```

## Configurar mkinitcpio

Plymouth se incluye como hook en mkinitcpio para que su binario y tema estén disponibles en el initramfs antes de montar la raíz. Para más información sobre drop-ins y el sistema de hooks, consulta la [guía de post-instalación de hooks](post-install-hooks.md).

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
# Reconstruir initramfs para aplicar los cambios
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

## Downgrade (bug conocido en v26)

El hook `keymap` no funciona correctamente con Plymouth v26 (26.134.222-1 y -2). El prompt LUKS se muestra en inglés (US) aunque `KEYMAP=es` esté configurado. Solución: downgrade a v24.004.60-14.

Más información: [Foro Arch Linux](https://bbs.archlinux.org/viewtopic.php?id=313743) — [Bug upstream](https://gitlab.freedesktop.org/plymouth/plymouth/-/work_items/337)

```bash
# Descargar v24 desde Arch Archive
wget https://archive.archlinux.org/packages/p/plymouth/plymouth-24.004.60-14-x86_64.pkg.tar.zst

# Downgrade forzado
sudo pacman -U plymouth-24.004.60-14-x86_64.pkg.tar.zst

# Pinear para que no se actualice en el próximo pacman -Syu
echo "IgnorePkg = plymouth" | sudo tee -a /etc/pacman.conf
```

Verifica la versión instalada: `pacman -Qi plymouth | grep Versión`

## Referencias

- [Plymouth (Arch Wiki)](https://wiki.archlinux.org/title/Plymouth)
- [Mkinitcpio (Arch Wiki)](https://wiki.archlinux.org/title/Mkinitcpio)
- [Mkinitcpio#Configuration (Arch Wiki)](https://wiki.archlinux.org/title/Mkinitcpio#Configuration)
- [Linux console/Keyboard configuration (Arch Wiki)](https://wiki.archlinux.org/title/Linux_console/Keyboard_configuration)
- [Silent boot (Arch Wiki)](https://wiki.archlinux.org/title/Silent_boot)
- [Omarchy issue #6072 — Plymouth LUKS prompt keymap bug](https://github.com/basecamp/omarchy/issues/6072)
- [Guía de post-instalación de hooks](post-install-hooks.md)

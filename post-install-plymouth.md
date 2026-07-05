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
| `bgrt` | Similar a spinner pero con el logo del fabricante (OEM) |
| `details` | Muestra mensajes de arranque detallados (útil para depuración) |
| `fade-in` | Fundido con estrellas |
| `glow` | Corporativo, con gráfico de progreso circular |
| `script` | Tema basado en script, personalizable |
| `solar` | Tema espacial con una estrella azul |
| `spinfinity` | Símbolo de infinito giratorio |
| `spinner` | Simple, con un spinner de carga |
| `text` | Versión textual, sin gráficos |
| `tribar` | Barra de progreso triple |

```bash
# Listar temas instalados
plymouth-set-default-theme --list

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
curl -OL https://archive.archlinux.org/packages/p/plymouth/plymouth-24.004.60-14-x86_64.pkg.tar.zst

# Downgrade forzado
sudo pacman --upgrade plymouth-24.004.60-14-x86_64.pkg.tar.zst

# Pinear para que no se actualice en el próximo pacman -Syu
# Añade al final de /etc/pacman.conf: IgnorePkg = plymouth
sudo vim /etc/pacman.conf

# Eliminar el paquete descargado
rm plymouth-24.004.60-14-x86_64.pkg.tar.zst

# Verificar la versión instalada
pacman -Q plymouth
```

# Post-instalación: zram (swap comprimido en RAM)

[zram](https://wiki.archlinux.org/title/Zram) es un módulo del kernel que crea un dispositivo de bloque comprimido en RAM para ser usado como swap. La compresión (zstd) permite almacenar ~2-3x más de lo que ocupa en RAM, reduce la latencia frente al swap en disco y evita desgaste del SSD.

`zram-generator` es el mecanismo oficial de systemd para configurar zram: un solo archivo de configuración que genera automáticamente `systemd-zram-setup@zram0.service`.

```bash
sudo pacman --sync zram-generator
```

| Paquete | Propósito |
|---------|-----------|
| `zram-generator` | Generador de unidades systemd para configurar dispositivos zram en cada arranque |

Crear `/etc/systemd/zram-generator.conf`:

```ini
[zram0]
zram-size = ram / 2
compression-algorithm = zstd
swap-priority = 100
```

Arrancar el servicio:

```bash
sudo systemctl daemon-reload
sudo systemctl start systemd-zram-setup@zram0.service
```

Verificar:

```bash
zramctl
swapon --show
```

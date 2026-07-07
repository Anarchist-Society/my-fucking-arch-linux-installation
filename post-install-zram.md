# Post-instalación: zram (swap comprimido en RAM)

[zram](https://wiki.archlinux.org/title/Zram) es un módulo del kernel que crea un dispositivo de bloque comprimido en RAM para ser usado como swap. La compresión (zstd) permite almacenar ~2-3x más de lo que ocupa en RAM, reduce la latencia frente al swap en disco y evita desgaste del SSD.

`zram-generator` es el mecanismo oficial de systemd para configurar zram: un solo archivo de configuración que genera automáticamente `systemd-zram-setup@zram0.service`.

```bash
# Instalar zram-generator
sudo pacman --sync zram-generator
```

| Paquete | Propósito |
|---------|-----------|
| `zram-generator` | Generador de unidades systemd para configurar dispositivos zram en cada arranque |

Hay que crear el archivo `/etc/systemd/zram-generator.conf`:

```ini
# /etc/systemd/zram-generator.conf
[zram0]
compression-algorithm = zstd
```

Arrancar el servicio:

```bash
# Recargar systemd para que reconozca el generador
sudo systemctl daemon-reload

# Arrancar el servicio que crea el dispositivo zram0
sudo systemctl start systemd-zram-setup@zram0.service
```

Verificar:

```bash
# Mostrar dispositivos zram y su estado
zramctl

# Mostrar todos los swaps activos con prioridad y tamaño
swapon --show
```

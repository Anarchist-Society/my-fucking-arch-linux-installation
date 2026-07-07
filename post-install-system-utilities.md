# Post-instalación: Utilidades del sistema

## brightnessctl

[brightnessctl](https://github.com/Hummer12007/brightnessctl) es una herramienta de línea de comandos para leer y ajustar el brillo de dispositivos en Linux. Modifica valores directamente en `/sys/class/backlight/`, por lo que funciona tanto en X11 como en Wayland (o sin servidor gráfico). Soporta backlights de pantalla, retroiluminación de teclado y LEDs.

```bash
# Instalar brightnessctl
sudo pacman --sync brightnessctl
```

| Paquete | Propósito |
|---------|-----------|
| `brightnessctl` | Control de brillo ligero vía /sys/class/backlight/ |

### Comandos básicos

```bash
# Ver nivel actual y máximo
brightnessctl get
brightnessctl max

# Establecer brillo al 50 %
brightnessctl set 50%

# Subir/bajar 10 puntos porcentuales
brightnessctl set +10%
brightnessctl set 10%-
```

## Bluetooth

[Bluetooth](https://wiki.archlinux.org/title/Bluetooth) es un estándar para la interconexión inalámbrica de corto alcance. El soporte básico se habilita con `bluez` y se gestiona desde `bluetoothctl`.

```bash
# Instalar Bluetooth
sudo pacman --sync bluez bluez-utils
```

| Paquete | Propósito |
|---------|-----------|
| `bluez` | Pila de protocolo Bluetooth |
| `bluez-utils` | Utilidades como `bluetoothctl` |

### Habilitar servicio

```bash
# Habilitar e iniciar el servicio Bluetooth
sudo systemctl enable --now bluetooth.service
```

### Emparejar dispositivos

```bash
# Abrir bluetoothctl
bluetoothctl

# Dentro de bluetoothctl:

# Buscar dispositivos
scan on

# Emparejar
pair XX:XX:XX:XX

# Conectar
connect XX:XX:XX:XX

# Confiar (para conexión automática,)
trust XX:XX:XX:XX
```

## unzip

`unzip` es una herramienta para descomprimir archivos `.zip`. Es esencial para extraer paquetes y archivos comprimidos.

```bash
# Instalar unzip
sudo pacman --sync unzip
```

| Paquete | Propósito |
|---------|-----------|
| `unzip` | Descompresión de archivos ZIP |

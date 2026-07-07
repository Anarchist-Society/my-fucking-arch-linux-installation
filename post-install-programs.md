# Post-instalación: Programas

Estos son los programas que uso en el sistema, ordenados por categoría.

## kitty

[Terminal emulator](https://sw.kovidgoyal.net/kitty/) GPU-acelerado, rápido y personalizable. Soporta tabs, splits, imágenes inline y temas.

```bash
# Instalar kitty
sudo pacman --sync kitty
```

| Paquete | Propósito |
|---------|-----------|
| `kitty` | Terminal emulator GPU-acelerado con soporte de imágenes y personalización |

## opencode

[CLI interactiva de IA](https://opencode.ai) para desarrollo de software. Ejecuta comandos, edita archivos y responde preguntas sobre el código directamente en la terminal.

```bash
curl -fsSL https://opencode.ai/install | bash
```

## unzip

Herramienta para descomprimir archivos `.zip`. Esencial para extraer paquetes y archivos comprimidos.

```bash
# Instalar unzip
sudo pacman --sync unzip
```

| Paquete | Propósito |
|---------|-----------|
| `unzip` | Descompresión de archivos ZIP |

## yazi

[Gestor de archivos terminal](https://github.com/sxyazi/yazi) rápido y personalizable. Navega directorios, previsualiza archivos y ejecuta acciones con atajos de teclado.

```bash
# Instalar yazi
sudo pacman --sync yazi
```

| Paquete | Propósito |
|---------|-----------|
| `yazi` | Gestor de archivos terminal con previsualización y atajos |

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
scan on          # Buscar dispositivos
pair XX:XX:XX:XX  # Emparejar
connect XX:XX:XX:XX  # Conectar
trust XX:XX:XX:XX   # Confiar (para reconexión automática)
```

| Fuente | Enlace |
|--------|--------|
| ArchWiki — Bluetooth | https://wiki.archlinux.org/title/Bluetooth |


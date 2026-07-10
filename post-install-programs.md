# Post-instalación: Programas

Estos son los programas que uso en el sistema, ordenados por categoría.

## Terminal

### kitty

[Kitty](https://sw.kovidgoyal.net/kitty/) es un emulador de terminal con GPU-acelerado, rápido y personalizable. Soporta tabs, splits, imágenes inline y temas.

```bash
# Instalar kitty
sudo pacman --sync kitty
```

| Paquete | Propósito |
|---------|-----------|
| `kitty` | Terminal emulator GPU-acelerado con soporte de imágenes y personalización |

### JetBrains Mono Nerd Font

[JetBrains Mono](https://www.jetbrains.com/mono/) es una fuente monoespaciada con ligaduras y soporte Nerd Font para iconos. Diseñada para desarrolladores con excelente legibilidad.

```bash
# Instalar JetBrains Mono Nerd Font
sudo pacman --sync ttf-jetbrains-mono-nerd

# Actualizar caché de fuentes
fc-cache
```

| Paquete | Propósito |
|---------|-----------|
| `ttf-jetbrains-mono-nerd` | Fuente monoespaciada con ligaduras e iconos Nerd Font |

```bash
# Configurar en kitty (~/.config/kitty/kitty.conf)
font_family JetBrainsMono Nerd Font
```

### yazi

[yazi](https://github.com/sxyazi/yazi) es un gestor de archivos de terminal, rápido y personalizable. Navega directorios, previsualiza archivos y ejecuta acciones con atajos de teclado.

```bash
# Instalar yazi
sudo pacman --sync yazi
```

| Paquete | Propósito |
|---------|-----------|
| `yazi` | Gestor de archivos terminal con previsualización y atajos |

### btop

[btop](https://github.com/aristocratos/btop) es un monitor de sistema con interfaz gráfica en terminal. Muestra CPU, RAM, discos, red y procesos en tiempo real.

```bash
# Instalar btop
sudo pacman --sync btop
```

| Paquete | Propósito |
|---------|-----------|
| `btop` | Monitor de sistema con interfaz visual en terminal |

### fastfetch

[fastfetch](https://github.com/fastfetch-cli/fastfetch) es una herramienta para obtener y mostrar información del sistema de forma rápida y personalizable. Muestra SO, kernel, shell, terminal, CPU, GPU, memoria y más.

```bash
# Instalar fastfetch
sudo pacman --sync fastfetch
```

| Paquete | Propósito |
|---------|-----------|
| `fastfetch` | Mostrar información del sistema de forma rápida y personalizable |

## Desarrollo

### opencode

[OpenCode](https://opencode.ai) es una CLI interactiva de IA para desarrollo de software. Ejecuta comandos, edita archivos y responde preguntas sobre el código directamente en la terminal.

```bash
curl -fsSL https://opencode.ai/install | bash
```

### nodejs y npm

[Node.js](https://nodejs.org/) es un entorno de ejecución de JavaScript fuera del navegador. [npm](https://www.npmjs.com/) es el gestor de paquetes oficial de Node.js.

```bash
# Instalar nodejs y npm
sudo pacman --sync nodejs npm
```

| Paquete | Propósito |
|---------|-----------|
| `nodejs` | Entorno de ejecución de JavaScript |
| `npm` | Gestor de paquetes de Node.js |

## Utilidades

### unzip

[unzip](https://infozip.sourceforge.net/unzip.html) es una herramienta para extraer archivos comprimidos en formato ZIP. Lista, extrae y examina archivos de archivos ZIP.

```bash
# Instalar unzip
sudo pacman --sync unzip
```

| Paquete | Propósito |
|---------|-----------|
| `unzip` | Extraer archivos comprimidos en formato ZIP |

## Red

### openssh

[OpenSSH](https://www.openssh.com/portable.html) es una implementación del protocolo SSH para acceso remoto, ejecución de comandos y transferencia de archivos de forma segura.

```bash
# Instalar openssh
sudo pacman --sync openssh
```

| Paquete | Propósito |
|---------|-----------|
| `openssh` | Cliente/servidor SSH para acceso remoto y transferencia de archivos |


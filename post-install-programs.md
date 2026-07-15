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
echo "font_family JetBrainsMono Nerd Font" >> ~/.config/kitty/kitty.conf
```

### noto-fonts-emoji

[Noto Fonts Emoji](https://fonts.google.com/noto/specimen/Noto+Emoji) es la fuente de emojis de Google. Compatible con la mayoría de aplicaciones y navegadores en Linux.

```bash
# Instalar fuente de emojis
sudo pacman --sync noto-fonts-emoji

# Actualizar caché de fuentes
fc-cache
```

| Paquete | Propósito |
|---------|-----------|
| `noto-fonts-emoji` | Fuente de emojis para navegadores y aplicaciones |

### bashrc

[~/.bashrc](bashrc.sh) es el archivo de configuración del shell Bash. Contiene alias, prompt, modo de edición y variables de entorno. Se copia al home tras la instalación.

```bash
# Copiar configuración de bashrc al home
cp bashrc.sh ~/.bashrc
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

### git

[Git](https://git-scm.com/) es un sistema de control de versiones distribuido, usado para gestionar el código fuente y colaborar en proyectos.

```bash
# Instalar git
sudo pacman --sync git
```

| Paquete | Propósito |
|---------|-----------|
| `git` | Sistema de control de versiones distribuido |

```bash
# Configurar identidad global
git config --global user.name "John Doe"
git config --global user.email "johndoe@example.com"
```

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

```bash
# Configurar directorio global para paquetes npm (evitar sudo)
mkdir ~/.npm-global
npm config set prefix ~/.npm-global

# Agregar al PATH en ~/.bashrc
echo 'export PATH="$HOME/.npm-global/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

## Utilidades

### sudo

[Sudo](https://wiki.archlinux.org/title/Sudo) permite ejecutar comandos con privilegios de administrador. Los "insults" muestran mensajes humorísticos al introducir una contraseña incorrecta.

```bash
# Activar insults de sudo
echo "Defaults insults" | sudo tee /etc/sudoers.d/10-insults
sudo chmod 440 /etc/sudoers.d/10-insults
```

| Fichero | Propósito |
|---------|-----------|
| `/etc/sudoers.d/10-insults` | Habilita mensajes de error humorísticos en sudo |

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

```bash
# Generar par de claves SSH ed25519
ssh-keygen -t ed25519 -C "tu_email@ejemplo.com"

# Iniciar el agente SSH
eval "$(ssh-agent -s)"

# Agregar clave privada al agente
ssh-add ~/.ssh/id_ed25519
```

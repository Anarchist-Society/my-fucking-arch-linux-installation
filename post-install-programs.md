# Post-instalación: Programas

Estos son los programas que uso en el sistema, ordenados por categoría.

## Tabla de contenidos
- [Escritorio](#escritorio)
  - [hyprland](#hyprland)
  - [sddm](#sddm)
  - [gnome-keyring](#gnome-keyring)
- [Terminal](#terminal)
  - [kitty](#kitty)
  - [tmux](#tmux)
  - [JetBrains Mono Nerd Font](#jetbrains-mono-nerd-font)
  - [noto-fonts-emoji](#noto-fonts-emoji)
  - [bashrc](#bashrc)
  - [yazi](#yazi)
  - [btop](#btop)
  - [fastfetch](#fastfetch)
  - [grim + slurp](#grim--slurp)
  - [obs-studio](#obs-studio)
  - [hyprlauncher](#hyprlauncher)
- [Desarrollo](#desarrollo)
  - [git](#git)
  - [lazygit](#lazygit)
  - [jdk-openjdk](#jdk-openjdk)
  - [opencode](#opencode)
  - [nodejs y npm](#nodejs-y-npm)
- [Utilidades](#utilidades)
  - [sudo](#sudo)
  - [dosfstools](#dosfstools)
  - [flatpak](#flatpak)
  - [fuse2](#fuse2)
  - [unzip](#unzip)
  - [7zip](#7zip)
  - [mpv](#mpv)
  - [yt-dlp](#yt-dlp)
  - [exiftool](#exiftool)
- [Hardware](#hardware)
  - [slimbook-bios-ec](#slimbook-bios-ec)
  - [zsa-moonlander](#zsa-moonlander)
- [Virtualización](#virtualización)
  - [VirtualBox](#virtualbox)
- [Juegos](#juegos)
  - [steam](#steam)
  - [sober](#sober)
  - [ppsspp](#ppsspp)
  - [heronite](#heronite)
- [Red](#red)
  - [openssh](#openssh)
  - [nmap](#nmap)
  - [nftables](#nftables)
- [VPN](#vpn)
  - [wireguard](#wireguard)

---

## Escritorio

### hyprland

[Hyprland](https://wiki.archlinux.org/title/Hyprland) es un compositor Wayland dinámico. Se puede arrancar desde TTY o desde un gestor de pantalla como [SDDM](#sddm).

```bash
# Instalar Hyprland
sudo pacman --sync hyprland
```

| Paquete | Propósito |
|---------|-----------|
| `hyprland` | Compositor Wayland dinámico y personalizable |

> Mi configuración de Hyprland está en [`hyprland.lua`](hyprland.lua) (ver [README](README.md#my-fucking-dotfiles)).

### sddm

[SDDM](https://wiki.archlinux.org/title/SDDM) (Simple Desktop Display Manager) es el gestor de pantalla que permite iniciar sesión gráficamente y elegir la sesión (Hyprland) sin entrar por TTY.

```bash
# Instalar SDDM
sudo pacman --sync sddm

# Habilitar el servicio para que arranque en el boot
sudo systemctl enable --now sddm.service
```

| Paquete | Propósito |
|---------|-----------|
| `sddm` | Gestor de pantalla (login gráfico) |

#### Teclado en español (X11)

El greeter de SDDM corre por defecto sobre X11 y toma su distribución de teclado de `/etc/X11/xorg.conf.d/00-keyboard.conf`. `localectl` genera ese fichero de forma declarativa, aplicándose al login de SDDM antes de que aparezca el diálogo.

```bash
# Fijar distribución española para X11 (greeter de SDDM)
localectl set-x11-keymap es
```

| Fichero | Propósito |
|---------|-----------|
| `/etc/X11/xorg.conf.d/00-keyboard.conf` | Distribución de teclado para X11 (lo usa el greeter de SDDM) |

### gnome-keyring

[GNOME Keyring](https://wiki.archlinux.org/title/GNOME/Keyring) provee `org.freedesktop.secrets`, el API de freedesktop que permite a las aplicaciones guardar secretos (tokens, contraseñas) de forma segura. Sin un proveedor de este servicio, aplicaciones como el launcher de Minecraft no recuerdan la sesión y vuelven a pedir las credenciales en cada arranque.

```bash
# Instalar gnome-keyring
sudo pacman --sync gnome-keyring
```

| Paquete | Propósito |
|---------|-----------|
| `gnome-keyring` | Proveedor de Secret Service para almacenar secretos de las aplicaciones |

## Terminal

### kitty

[Kitty](https://wiki.archlinux.org/title/Kitty) es un emulador de terminal con GPU-acelerado, rápido y personalizable. Soporta tabs, splits, imágenes inline y temas.

```bash
# Instalar kitty
sudo pacman --sync kitty
```

| Paquete | Propósito |
|---------|-----------|
| `kitty` | Terminal emulator GPU-acelerado con soporte de imágenes y personalización |

### tmux

[tmux](https://wiki.archlinux.org/title/Tmux) es un multiplexor de terminal que permite mantener sesiones persistentes, organizar el trabajo en ventanas y paneles, y recuperar la sesión aunque se cierre el terminal o se desconecte la conexión SSH.

```bash
# Instalar tmux
sudo pacman --sync tmux
```

| Paquete | Propósito |
|---------|-----------|
| `tmux` | Multiplexor de terminal con sesiones persistentes, ventanas y paneles |

### JetBrains Mono Nerd Font

[JetBrains Mono](https://www.jetbrains.com/mono) es una fuente monoespaciada con ligaduras y soporte Nerd Font para iconos. Diseñada para desarrolladores con excelente legibilidad.

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

[~/.bashrc](https://wiki.archlinux.org/title/Bash) es el archivo de configuración del shell Bash. Contiene alias, prompt, modo de edición y variables de entorno.

```bash
# Copiar configuración de bashrc al home
cp bashrc.sh ~/.bashrc
```

> Mi configuración de bashrc está en [`bashrc`](bashrc.sh) (ver [README](README.md#my-fucking-dotfiles)).

### yazi

[yazi](https://github.com/sxyazi/yazi) es un gestor de archivos de terminal, rápido y personalizable. Navega directorios, previsualiza archivos y ejecuta acciones con atajos de teclado.

```bash
# Instalar yazi
sudo pacman --sync yazi
```

| Paquete | Propósito |
|---------|-----------|
| `yazi` | Gestor de archivos terminal con previsualización y atajos |

#### Dependencias opcionales

Yazi funciona sin ellas, pero habilitan miniaturas, previsualizaciones y búsqueda:

```bash
# Instalar dependencias opcionales de yazi
sudo pacman --sync ffmpeg 7zip jq poppler fd ripgrep fzf zoxide resvg imagemagick
```

| Paquete | Propósito |
|---------|-----------|
| `ffmpeg` | Miniaturas de vídeo |
| `7zip` | Extracción y previsualización de archivos comprimidos |
| `jq` | Previsualización de JSON |
| `poppler` | Previsualización de PDF |
| `fd` | Búsqueda de archivos |
| `ripgrep` | Búsqueda de contenido en archivos (`rg`) |
| `fzf` | Navegación rápida por subárboles (>= 0.53.0) |
| `zoxide` | Navegación por directorios históricos (requiere `fzf`) |
| `resvg` | Previsualización de SVG |
| `imagemagick` | Previsualización de imágenes y fuentes (>= 7.1.1) |

> Los iconos ya están cubiertos por `ttf-jetbrains-mono-nerd` (sección [JetBrains Mono Nerd Font](#jetbrains-mono-nerd-font)) y el portapapeles por `wl-clipboard` (sección [grim + slurp](#grim--slurp)).

#### Configuración

La configuración de yazi vive en el repositorio y se enlaza simbólicamente. Ejecuta el comando desde la raíz del repo:

```bash
# Enlazar configuración de yazi
mkdir --parents ~/.config/yazi
ln --symbolic --force "$(pwd)/yazi.toml" ~/.config/yazi/yazi.toml
ln --symbolic --force "$(pwd)/theme.toml" ~/.config/yazi/theme.toml
```

| Fichero | Propósito |
|---------|-----------|
| `~/.config/yazi/yazi.toml` | Enlace simbólico a la configuración del repo |
| `~/.config/yazi/theme.toml` | Enlace simbólico al tema (iconos) del repo |

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

### grim + slurp

[grim](https://gitlab.freedesktop.org/emersion/grim) es una herramienta de captura de pantalla para Wayland. [slurp](https://github.com/emersion/slurp) permite seleccionar una región de la pantalla de forma interactiva. Combinados, permiten copiar capturas directamente al portapapeles.

```bash
# Instalar grim, slurp y wl-clipboard
sudo pacman --sync grim slurp wl-clipboard
```

| Paquete | Propósito |
|---------|-----------|
| `grim` | Captura de pantalla para Wayland |
| `slurp` | Selector de región interactivo |
| `wl-clipboard` | Copiar al portapapeles en Wayland |

```lua
-- Copiar región seleccionada al portapapeles (SUPER + Print)
hl.bind("Print", hl.dsp.exec_cmd('grim -g "$(slurp -d)" - | wl-copy'))
```

### obs-studio

[OBS Studio](https://wiki.archlinux.org/title/Open_Broadcaster_Software) es un software de grabación y streaming de código abierto. En Hyprland requiere `xdg-desktop-portal-hyprland` para la captura de pantalla y `qt6-wayland` para evitar crashes.

```bash
# Instalar OBS Studio
sudo pacman --sync obs-studio pipewire-jack qt6-wayland xdg-desktop-portal-hyprland
```

| Paquete | Propósito |
|---------|-----------|
| `obs-studio` | Software de grabación y streaming |
| `pipewire-jack` | Compatibilidad JACK a través de PipeWire |
| `qt6-wayland` | Soporte Wayland para Qt (evita crashes de OBS) |
| `xdg-desktop-portal-hyprland` | Portal de captura de pantalla para Hyprland |

### hyprlauncher

[Hyprlauncher](https://github.com/hyprwm/hyprlauncher) es el lanzador de aplicaciones oficial de Hyprland. Es multipropósito (aplicaciones, búsqueda de unicode, calculadora), rápido y funciona como daemon.

```bash
# Instalar Hyprlauncher
sudo pacman --sync hyprlauncher
```

| Paquete | Propósito |
|---------|-----------|
| `hyprlauncher` | Lanzador de aplicaciones oficial de Hyprland |

En esta configuración, **SUPER + R** abre el lanzador. La calculadora y la búsqueda Unicode no se detectan solas, hay que escribir su prefijo como **primer carácter** de la búsqueda.

| Prefijo | Finder | Ejemplo | Resultado |
|---------|--------|---------|-----------|
| *(ninguno)* | Aplicaciones | `brave` | Abre Brave |
| `=` | Calculadora | `=2+2` | `= 4` |
| `.` | Unicode | `.arrow` | `→ -> RIGHTWARDS ARROW` |
| `'` | Fuentes | `'mono` | Fuentes que coinciden |

## Desarrollo

### git

[Git](https://wiki.archlinux.org/title/Git) es un sistema de control de versiones distribuido, usado para gestionar el código fuente y colaborar en proyectos.

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

### lazygit

[Lazygit](https://github.com/jesseduffield/lazygit) es una interfaz TUI para Git que permite gestionar el repositorio (staging, commits, ramas, rebase, log) sin salir de la terminal.

```bash
# Instalar lazygit
sudo pacman --sync lazygit
```

| Paquete | Propósito |
|---------|-----------|
| `lazygit` | Interfaz interactiva en terminal para Git |

### jdk-openjdk

[OpenJDK](https://wiki.archlinux.org/title/Java) es la implementación de referencia de Java. Incluye el JDK (Java Development Kit) para compilar y ejecutar aplicaciones Java.

```bash
# Instalar OpenJDK
sudo pacman --sync jdk-openjdk
```

| Paquete | Propósito |
|---------|-----------|
| `jdk-openjdk` | Kit de desarrollo de Java (JDK) |

### opencode

[OpenCode](https://opencode.ai) es una CLI interactiva de IA para desarrollo de software. Ejecuta comandos, edita archivos y responde preguntas sobre el código directamente en la terminal.

```bash
curl -fsSL https://opencode.ai/install | bash
```

### nodejs y npm

[Node.js](https://wiki.archlinux.org/title/Node.js) es un entorno de ejecución de JavaScript fuera del navegador. [npm](https://www.npmjs.com/) es el gestor de paquetes oficial de Node.js.

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

[Sudo](https://wiki.archlinux.org/title/Sudo) permite ejecutar comandos con privilegios de administrador.

```bash
# Activar insults de sudo
# Los "insults" muestran mensajes humorísticos al introducir una contraseña incorrecta.
sudo tee /etc/sudoers.d/10-insults <<< "Defaults insults"
sudo chmod 440 /etc/sudoers.d/10-insults

# Verificar configuración con visudo
sudo visudo -c -f /etc/sudoers.d/10-insults
```

| Fichero | Propósito |
|---------|-----------|
| `/etc/sudoers.d/10-insults` | Habilita mensajes de error humorísticos en sudo |

### dosfstools

[dosfstools](https://github.com/dosfstools/dosfstools) es una colección de herramientas para gestionar sistemas de archivos FAT. Útil para formatear y verificar particiones EFI (FAT32).

```bash
# Instalar dosfstools
sudo pacman --sync dosfstools
```

| Paquete | Propósito |
|---------|-----------|
| `dosfstools` | Herramientas para gestionar sistemas de archivos FAT |

### flatpak

[Flatpak](https://wiki.archlinux.org/title/Flatpak) es un framework de sandboxing y distribución de aplicaciones Linux. Permite instalar aplicaciones aisladas del sistema con sus dependencias incluidas.

```bash
# Instalar flatpak
sudo pacman --sync flatpak
```

| Paquete | Propósito |
|---------|-----------|
| `flatpak` | Sandboxing y distribución de aplicaciones Linux |

### fuse2

[FUSE 2](https://github.com/libfuse/libfuse) (Filesystem in Userspace, versión 2) es una interfaz del kernel que permite implementar y montar sistemas de archivos desde el espacio de usuario mediante la biblioteca `libfuse.so.2`. Es necesario para ejecutar **AppImage**, que cargan esa biblioteca en tiempo de ejecución para montar su contenido. Arch solo instala `fuse3`, cuya biblioteca (`libfuse3.so.4`) no es compatible, así que sin este paquete los AppImage fallan al arrancar.

```bash
# Instalar FUSE 2 (convive con fuse3)
sudo pacman --sync fuse2
```

| Paquete | Propósito |
|---------|-----------|
| `fuse2` | Interfaz FUSE v2 (`libfuse.so.2`) para montar sistemas de archivos en espacio de usuario, requerida por el runtime de los AppImage |

### unzip

[unzip](https://infozip.sourceforge.net/UnZip.html) es una herramienta para extraer archivos comprimidos en formato ZIP. Lista, extrae y examina archivos de archivos ZIP.

```bash
# Instalar unzip
sudo pacman --sync unzip
```

| Paquete | Propósito |
|---------|-----------|
| `unzip` | Extraer archivos comprimidos en formato ZIP |

### 7zip

[7-Zip](https://www.7-zip.org) es un archivador de archivos con alta ratio de compresión. Se distribuye bajo la LGPL y soporta formatos como 7z, ZIP, RAR, TAR o GZ.

```bash
# Instalar 7zip
sudo pacman --sync 7zip
```

| Paquete | Propósito |
|---------|-----------|
| `7zip` | Extraer y crear archivos comprimidos en formato 7z |

### mpv

[mpv](https://wiki.archlinux.org/title/Mpv) es un reproductor de vídeo minimalista y ligero, altamente configurable. Soporta una amplia variedad de formatos de vídeo y audio.

```bash
# Instalar mpv
sudo pacman --sync mpv
```

| Paquete | Propósito |
|---------|-----------|
| `mpv` | Reproductor de vídeo minimalista |

### yt-dlp

[yt-dlp](https://github.com/yt-dlp/yt-dlp) es una herramienta de línea de comandos para descargar vídeos de YouTube y otros sitios. Soporta alta calidad, playlists, subtítulos y más.

```bash
# Instalar yt-dlp, ffmpeg y python-curl_cffi
sudo pacman --sync yt-dlp ffmpeg python-curl_cffi
```

| Paquete | Propósito |
|---------|-----------|
| `yt-dlp` | Descargar vídeos de YouTube y otros sitios |
| `ffmpeg` | Combina/remuxea el vídeo y el audio descargados |
| `python-curl_cffi` | Impersonación de navegador para yt-dlp (evita el HTTP 429 al descargar subtítulos) |

### exiftool

[ExifTool](https://exiftool.org/) es una herramienta de línea de comandos para leer, escribir y borrar metadatos (EXIF, GPS, IPTC, XMP...) de imágenes, vídeos y otros formatos. Es útil, por ejemplo, para quitar la ubicación de una foto antes de compartirla.

```bash
# Instalar exiftool
sudo pacman --sync exiftool
```

> `exiftool` es un nombre virtual en los repositorios oficiales: lo proporciona `perl-image-exiftool` (repo `extra`). Por eso `sudo pacman -S exiftool` instala `perl-image-exiftool`; se puede comprobar con `pacman -Qe exiftool`.

| Paquete | Propósito |
|---------|-----------|
| `perl-image-exiftool` (provee `exiftool`) | Leer, editar y borrar metadatos de imágenes y otros archivos |

```bash
# Comprobar la versión instalada
exiftool -ver

# Ver los metadatos de una imagen
exiftool foto.jpg

# Ver todos los grupos de etiquetas con su nombre completo
exiftool -G1 -a -s foto.jpg

# Borrar todos los metadatos (crea una copia `foto.jpg_original`)
exiftool -all= foto.jpg

# Borrar sin conservar la copia original
exiftool -overwrite_original -all= foto.jpg
```

## Hardware

### slimbook-bios-ec

Guía para actualizar BIOS y EC en [Slimbook EVO](https://slimbook.com/evo). Necesitas un pendrive y los ficheros BIOS y EC descomprimidos.

> **SECURE BOOT** debe estar desactivado para realizar el proceso.

#### Preparar el pendrive

```bash
# Particionar el pendrive (reemplaza /dev/sdX por tu dispositivo)
sudo fdisk /dev/sdX
```

| Comando | Acción |
|---------|--------|
| `o` | Crear tabla MBR |
| `n` → Enter → Enter → Enter | Crear partición en todo el disco |
| `t` | Cambiar tipo |
| `c` | Seleccionar tipo W95 FAT32 (LBA) |
| `a` | Activar bandera de arranque |
| `w` | Escribir y salir |

```bash
# Formatear partición como FAT32
sudo mkfs.fat -F 32 /dev/sdX1
```

> Sustituye `/dev/sdX` por el dispositivo de tu pendrive. Puedes identificarlo con `lsblk`.

```bash
# Montar el pendrive
sudo mount /dev/sdX1 /mnt/usb

# Copiar directorios BIOS, EC y EFI a la raíz del pendrive
sudo cp --recursive BIOS EC EFI /mnt/usb

# Sincronizar datos pendientes
sudo sync

# Desmontar el pendrive
sudo umount /mnt/usb
```

#### Flashear la BIOS

1. Conecta el cargador al equipo.
2. Ve a BIOS y establece el perfil de límite de carga en 100% o restablece los valores por defecto.
3. Con el equipo apagado, introduce el pendrive en cualquier puerto USB y enciéndelo.
4. Nada más pulses el botón de encendido, pulsa repetidamente **F7** hasta que aparezca el menú de arranque. Selecciona la unidad USB.
5. Aparecerá un listado de unidades y una línea de comandos. Identifica el pendrive (etiquetado como "removable hard disk" o similar, ruta `FS0`, `FS1` o `FS2`).
6. Para acceder al pendrive, escribe la ruta seguida de dos puntos (ej. `FS1:`).
7. Entra en el directorio BIOS: `cd BIOS` y ejecuta `F.nsh`.
8. Espera a que termine el proceso y el equipo se apague o reinicie.

#### Flashear el EC

> Tras el reinicio puede aparecer una ventana roja avisando de que las firmas de arranque no son válidas. Entra en la BIOS y desactiva el **Secure Boot** para flashear el EC.

Repite el proceso anterior:

1. Entra en el directorio EC: `cd EC` y ejecuta `F.nsh`.
2. Los ventiladores se pondrán a máxima potencia durante el flasheo y se apagarán al finalizar o el equipo se reiniciará.

Tras este último paso, tendrás instaladas las últimas versiones de BIOS y EC en tu Slimbook.

### zsa-moonlander

[ZSA Moonlander](https://zsa.io/moonlander/) es un teclado ergonómico programable. Requiere reglas udev para flashear el firmware desde el navegador (Oryx) o con Keymapp/Wally.

Crea el fichero `/etc/udev/rules.d/50-zsa.rules` e introduce el siguiente contenido:

```ini
# Rules for Oryx web flashing and live training
KERNEL=="hidraw*", ATTRS{idVendor}=="16c0", MODE="0664", GROUP="plugdev"
KERNEL=="hidraw*", ATTRS{idVendor}=="3297", MODE="0664", GROUP="plugdev"

# Legacy rules for live training over webusb (Not needed for firmware v21+)
  # Rule for all ZSA keyboards
  SUBSYSTEM=="usb", ATTR{idVendor}=="3297", GROUP="plugdev"
  # Rule for the Moonlander
  SUBSYSTEM=="usb", ATTR{idVendor}=="3297", ATTR{idProduct}=="1969", GROUP="plugdev"

# Keymapp / Wally Flashing rules for the Moonlander and Planck EZ
SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE:="0666", SYMLINK+="stm32_dfu"
```

```bash
# Crear grupo plugdev si no existe
sudo groupadd plugdev

# Añadir usuario al grupo plugdev
sudo usermod --append --groups plugdev $USER

# Reiniciar para aplicar reglas udev
sudo reboot
```

| Fichero | Propósito |
|---------|-----------|
| `50-zsa.rules` | Reglas udev para el Moonlander |

## Virtualización

### VirtualBox

[VirtualBox](https://wiki.archlinux.org/title/VirtualBox) es un hypervisor que permite ejecutar sistemas operativos en un entorno especial, llamado máquina virtual, sobre el sistema operativo existente. Está en constante desarrollo e incluye una interfaz gráfica Qt, así como herramientas de línea de comandos headless y SDL para gestionar y ejecutar máquinas virtuales.

Para integrar funciones del sistema anfitrión en los invitados (carpetas compartidas, portapapeles, aceleración de vídeo y modo de integración de ventanas), se proporcionan las VirtualBox Guest Additions para algunos sistemas operativos invitados.

```bash
# Instalar VirtualBox, módulos DKMS del host y headers del kernel
sudo pacman --sync virtualbox virtualbox-host-dkms linux-headers

# Cargar el módulo del host
sudo modprobe vboxdrv

# Agregar usuario al grupo vboxusers (requiere cerrar sesión para surtir efecto)
sudo usermod --append --groups vboxusers $USER
```

| Paquete | Propósito |
|---------|-----------|
| `virtualbox` | Hypervisor con GUI Qt y herramientas CLI headless y SDL |
| `virtualbox-host-dkms` | Módulos del kernel del host (`vboxdrv`, etc.), recompilados automáticamente por el hook DKMS al actualizar VirtualBox o el kernel |
| `linux-headers` | Headers del kernel `linux`, necesarios para compilar los módulos DKMS |

## Juegos

### steam

[Steam](https://store.steampowered.com/) es la plataforma de distribución de videojuegos de Valve. El cliente y buena parte del catálogo usan bibliotecas de 32 bits, así que la instalación necesita el repositorio `multilib`, el locale `en_US.UTF-8` y los drivers gráficos de 32 bits de la GPU.

#### Habilitar multilib

`multilib` contiene los paquetes de 32 bits que necesita Steam, pero viene deshabilitado por defecto en `/etc/pacman.conf`. Hay que descomentar el repositorio:

```ini
[multilib]
Include = /etc/pacman.d/mirrorlist
```

```bash
# Editar pacman.conf y descomentar el bloque [multilib]
sudo vim /etc/pacman.conf
```

| Fichero | Propósito |
|---------|-----------|
| `/etc/pacman.conf` | Habilitar `[multilib]` para acceder a los paquetes de 32 bits |

#### Generar el locale en_US.UTF-8

El runtime de Steam asume `en_US.UTF-8`. Si no está generado, el cliente puede fallar con errores de puntero inválido. No hace falta cambiar `LANG`. Basta con que el locale exista en el sistema.

```bash
# Descomentar "en_US.UTF-8 UTF-8" en /etc/locale.gen
sudo vim /etc/locale.gen

# Generar los locales
sudo locale-gen

# Verificar que existe
locale --all-locales | grep en_US.utf8
```

| Fichero | Propósito |
|---------|-----------|
| `/etc/locale.gen` | Descomentar `en_US.UTF-8 UTF-8` para generar el locale que usa Steam |

#### Instalar Steam

```bash
# Sincronizar la base de datos tras habilitar multilib
sudo pacman --sync --refresh --sysupgrade

# Instalar Steam y los drivers OpenGL/Vulkan de 32 bits (AMD Radeon)
sudo pacman --sync steam lib32-mesa lib32-vulkan-radeon
```

| Paquete | Propósito |
|---------|-----------|
| `steam` | Cliente de Steam y su runtime, con las dependencias `lib32-*` que necesita |
| `lib32-mesa` | OpenGL de 32 bits para la GPU AMD |
| `lib32-vulkan-radeon` | Vulkan de 32 bits para la GPU AMD (DXVK/vkd3d y juegos de 32 bits) |

> Si `pacman` pregunta por un proveedor de `lib32-vulkan-driver`, selecciona `lib32-vulkan-radeon`. Por orden alfabético propone `lib32-nvidia-utils`, que no corresponde a la AMD Radeon 780M.

#### DNS con systemd-resolved

Steam resuelve nombres con su propio runtime, que lee `/etc/resolv.conf` directamente. Si se usa `systemd-resolved` y ese fichero es estático y sin `nameserver`, el cliente no podrá iniciar sesión ni descargar juegos.

```bash
# Enlazar resolv.conf al stub de systemd-resolved
sudo ln --symbolic --force /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

# Comprobar que el modo es "stub" y que hay servidores DNS
resolvectl status
```

| Fichero | Propósito |
|---------|-----------|
| `/etc/resolv.conf` | Symlink a `stub-resolv.conf` para que Steam pueda resolver nombres |

### sober

[Sober](https://sober.vinegarhq.org/) es un launcher de código abierto para jugar a Roblox en Linux usando Vinegar, que traduce el juego para ejecutarlo de forma nativa. Se distribuye a través de [Flathub](https://flathub.org/), el repositorio principal de aplicaciones Flatpak.

```bash
# Instalar Sober (Roblox) vía Flatpak
flatpak install flathub org.vinegarhq.Sober
```

| Paquete | Propósito |
|---------|-----------|
| `org.vinegarhq.Sober` | Launcher de Roblox para Linux (Flatpak) |
| `flathub` | Repositorio de Flatpak con miles de aplicaciones |

### ppsspp

[PPSSPP](https://www.ppsspp.org/) es un emulador de PlayStation Portable (PSP) con frontend Qt y soporte para OpenGL y Vulkan. Está en el repositorio `extra`, así que no requiere AUR.

#### Instalar

```bash
# Instalar PPSSPP
sudo pacman --sync ppsspp
```

| Paquete | Propósito |
|---------|-----------|
| `ppsspp` | Emulador de PSP con soporte para OpenGL y Vulkan |

#### ISO del juego

PPSSPP no incluye juegos y la PSP no necesita BIOS para la mayoría de títulos. Hay que usar una copia volcada de la propia UMD, la distribución de ISOs de terceros es ilegal y Arch no las proporciona.

```bash
# Crear la carpeta para las ISOs
mkdir --parents ~/Isos/psp
```

#### Gráficos

Ajustes recomendados en `Ajustes de juego → Gráficos`. Solo se listan los que difieren del valor por defecto.

##### Modo de renderizado

| Ajuste | Valor | Motivo |
|--------|-------|--------|
| Backend | Vulkan | En Linux OpenGL es el valor por defecto; con RADV la 780M rinde mejor |
| Resolución de renderizado | 4x PSP | 1920×1088: 4 veces la PSP y un 36 % menos de trabajo que 5x |

> `Antialiasing (MSAA)`: no tocar. Con 4x PSP los bordes ya se ven bien y activarlo 4x calienta sin ganancia visible.

> Si en algún juego vuelve a subir el ventilador, baja solo la resolución a 3x PSP antes de desactivar el escalador o los filtros.

##### Pantalla

| Ajuste | Valor | Motivo |
|--------|-------|--------|
| Pantalla completa | Activado | Aprovecha el panel y el VRR de Hyprland |

> `Sincronización vertical` y `Pantalla de baja latencia` se dejan en sus valores por defecto (activado y desactivado, respectivamente). Con VRR conviene no forzar el modo Mailbox.

##### Escalado de texturas

| Ajuste | Valor | Motivo |
|--------|-------|--------|
| Escalador de texturas de GPU (rápido) | Spline36 | Más nitidez en texturas sin coste de CPU |

> `Nivel de escalado` se deja en su valor por defecto: 2x.

##### Filtrado de texturas

| Ajuste | Valor | Motivo |
|--------|-------|--------|
| Filtro de texturas | Auto Max Quality | Mejor resultado en 3D junto con el anisotrópico |
| Filtrado 2D inteligente | Activado | Evita que el arte 2D se vea borroso al escalar |

> `Filtrado anisotrópico`: no tocar. En PPSSPP 1.20.4 ya viene en **16x** por defecto.

#### Audio

| Ajuste | Valor | Motivo |
|--------|-------|--------|
| Modo de reproducción | Smooth | Evita crujidos si usas la velocidad alternativa |

#### Sistema

| Ajuste | Valor | Motivo |
|--------|-------|--------|
| Buscar nuevas versiones de PPSSPP | Deshabilitado | `pacman` gestiona las actualizaciones del paquete de `extra` |

### heronite

[Heronite](https://heronite.app/) es un launcher de juegos para Linux y Windows que reúne en una biblioteca Steam, Epic, GOG, Amazon y tus emuladores. No es un emulador: detecta RPCS3, PCSX2 y PPSSPP ya instalados y lanza los juegos desde ahí. No está en los repositorios oficiales ni en AUR; se instala desde los releases de GitHub.

#### Instalar

Trabajamos en una carpeta propia para que la comprobación de la suma encuentre el paquete sin depender del directorio actual.

```bash
mkdir --parents ~/Downloads/Heronite
cd ~/Downloads/Heronite

# Descargar el paquete de Arch y la lista de sumas (v1.7.0; revisar si hay versión nueva)
curl --location --output heronite-1.7.0-1-x86_64.pkg.tar.zst \
  https://github.com/RafaelGoulartB/Heronite/releases/download/v1.7.0/heronite-1.7.0-1-x86_64.pkg.tar.zst

curl --location --output SHA256SUMS \
  https://github.com/RafaelGoulartB/Heronite/releases/download/v1.7.0/SHA256SUMS

# Comprobar la suma: --ignore-missing omite el resto de archivos del release que no hemos descargado
sha256sum --check --ignore-missing SHA256SUMS

# Instalar
sudo pacman --upgrade heronite-1.7.0-1-x86_64.pkg.tar.zst

# Una vez instalado puedes borrar `~/Downloads/Heronite`: solo contiene el paquete descargado y el `SHA256SUMS`.
rm -rf ~/Downloads/Heronite
```

| Paquete | Propósito |
|---------|-----------|
| `heronite` | Launcher que unifica tiendas y emuladores en una sola biblioteca |

> Alternativa portátil, sin instalar en el sistema: descargar `Heronite-x86_64.AppImage` desde los [releases](https://github.com/RafaelGoulartB/Heronite/releases/latest), darle permiso de ejecución y abrirlo desde `~/Applications`.

#### Primer arranque

```bash
# Abrir Heronite
heronite-rs
```

> Necesita un driver Vulkan activo; con Mesa en la Radeon 780M ya funciona. Detecta los emuladores instalados, así que no hay que configurar RPCS3 ni PCSX2 de nuevo.

> Opcionales: `gamescope`, `bubblewrap`, `python3`, `webkit2gtk-4.1`, `umu-launcher`, `Ludusavi` y `gpu-screen-recorder`. Heronite comprueba actualizaciones desde GitHub al arrancar y verifica la firma del paquete.

## Red

### openssh

[OpenSSH](https://wiki.archlinux.org/title/OpenSSH) es una implementación del protocolo SSH para acceso remoto, ejecución de comandos y transferencia de archivos de forma segura.

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

### nmap

[nmap](https://wiki.archlinux.org/title/Nmap) es un escáner de red que permite descubrir hosts, puertos y servicios activos, así como detectar versiones y sistemas operativos. Es útil para auditar la seguridad de una red local.

```bash
# Instalar nmap
sudo pacman --sync nmap
```

| Paquete | Propósito |
|---------|-----------|
| `nmap` | Escáner de red para descubrir hosts, puertos y servicios |

### nftables

[nftables](https://wiki.archlinux.org/title/Nftables) es el firewall moderno del kernel Linux. Reemplaza a iptables y a ufw.

```bash
# Instalar nftables
sudo pacman --sync nftables
```

```bash
# Configurar
sudo vim /etc/nftables.conf
```

```nft
#!/usr/bin/nft -f
# vim:set ts=2 sw=2 et:

# IPv4/IPv6 Simple & Safe firewall ruleset.
# More examples in /usr/share/nftables/ and /usr/share/doc/nftables/examples/.

# Borra la tabla si ya existía (permite re-ejecutar sin error)
destroy table inet filter

# Tabla única para IPv4 e IPv6
# Crea una tabla llamada filter en la familia inet, abarca IPv4 e IPv6
table inet filter {
  # Cadena que procesa los paquetes que entran al equipo
  chain input {
    # Filtrar paquetes entrantes. Por defecto, descartar
    type filter hook input priority filter
    policy drop

    # Loopback (localhost) siempre permitido
    iif "lo" accept comment "allow from loopback"

    # ct Connections Tracking
    # Conexiones ya establecidas o relacionadas (respuestas a tus conexiones salientes)
    ct state {established, related} accept comment "allow tracked connections"

    # Descartar paquetes malformados o que no encajan en ninguna conexión conocida
    ct state invalid drop comment "early drop of invalid connections"

    # No responder a ping, como Windows
    # Comenta estas dos líneas si quieres que te puedan hacer ping.
    # Deben ir ANTES del accept de ICMP. El resto de ICMP sigue permitido.
    icmp type echo-request drop
    icmpv6 type echo-request drop

    # ICMP (ping, IPv4) e ICMPv6 (ping, IPv6, MTU)
    # meta l4proto es agnóstico de familia: una regla cubre IPv4 e IPv6
    meta l4proto { icmp, icmpv6 } accept comment "allow icmp"

    # DHCP (obtener IP por DHCP / DHCPv6)
    # Si usas IP dinámica (incluida una reserva DHCP), descomenta estas dos líneas.
    # udp dport 68 accept comment "allow dhcp ipv4"
    # udp dport 546 accept comment "allow dhcp ipv6"

    # SSH
    # tcp dport 22 accept comment "allow sshd"
    # tcp dport ssh accept comment "allow sshd"

    # mDNS (descubrimiento en LAN)
    # udp dport 5353 accept

    # Rechazar el resto con ICMP (máx. 5/s) y contar
    # pkttype host limit rate 5/second counter reject with icmpx type admin-prohibited
    # counter
  }

  # Cadena que procesa los paquetes reenviados (routing): bloquear
  chain forward {
    type filter hook forward priority filter
    policy drop
  }

  # Cadena que procesa los paquetes salientes: permitir todo
  # chain output {
  #   type filter hook output priority filter
  #   policy accept
  # }
}
```

```bash
# Aplicar y habilitar al inicio
sudo systemctl enable --now nftables.service

# Revisar las reglas activas
sudo nft list ruleset

# Para revertir los cambios (parar y deshabilitar al inicio)
sudo systemctl disable --now nftables.service
```

## VPN

[Proton VPN](https://protonvpn.com/) es el proveedor de VPN que uso. La configuración es manual con **WireGuard**, porque la app oficial de Proton exige NetworkManager y este equipo usa `iwd + systemd-networkd`. OpenVPN queda fuera: Proton lo está retirando y recomienda WireGuard para configuración manual.

### wireguard

[WireGuard](https://wiki.archlinux.org/title/WireGuard) es un protocolo VPN moderno, rápido y ligero. Se integra en el kernel y se configura con un fichero `.conf` que proporciona el proveedor.

```bash
# Instalar cliente y soporte de DNS para systemd-resolved
sudo pacman --sync wireguard-tools systemd-resolvconf
```

| Paquete | Propósito |
|---------|-----------|
| `wireguard-tools` | Cliente WireGuard (`wg`, `wg-quick`) |
| `systemd-resolvconf` | Aplica la línea `DNS =` mediante `systemd-resolved` |

#### Descargar la configuración

En [account.protonvpn.com](https://account.protonvpn.com/downloads) → **Downloads** → **WireGuard configuration**:

| Campo | Valor |
|-------|-------|
| **Nombre** | `proton` |
| **Plataforma** | GNU/Linux |
| **NAT-PMP (Port Forwarding)** | Desactivado |
| **VPN Accelerator** | Activado |
| **Servidor** | El recomendado o uno concreto de la lista |

- **Nombre**: será el nombre del fichero y de la interfaz. Debe ser corto (máximo 15 caracteres) y sin guiones.
- **Plataforma**: **GNU/Linux** es la que corresponde a `wg-quick`.
- **NAT-PMP**: solo abre puertos para hostear servicios o sembrar torrents, y no está disponible en el plan gratuito.
- **VPN Accelerator**: mejora la velocidad.
- **Servidor**: con plan gratuito solo aparecen servidores gratuitos.

Pulsa **Crear**, espera unos segundos y pulsa **Descargar**.

Guárdalo en `/etc/wireguard/` con permisos restringidos. El nombre del fichero será el nombre de la interfaz, así que conviene que sea corto (máximo 15 caracteres) y sin guiones: `proton.conf` vale:

```bash
# Copiar la configuración descargada con permisos de root
sudo install --mode 600 --owner root --group root ~/Downloads/proton.conf /etc/wireguard/proton.conf
```

El fichero tiene esta forma:

```ini
# /etc/wireguard/proton.conf
[Interface]
PrivateKey = <CLAVE_PRIVADA>
Address = 10.2.0.2/32
DNS = 10.2.0.1

[Peer]
PublicKey = <CLAVE_PÚBLICA_DEL_SERVIDOR>
AllowedIPs = 0.0.0.0/0, ::/0
Endpoint = <IP_O_DOMINIO>:51820
PersistentKeepalive = 25
```

#### Conectar

```bash
# Levantar el túnel
sudo wg-quick up proton

# Ver el estado del túnel
sudo wg show

# Comprobar que el DNS usa Proton
resolvectl status

# Comprobar la IP pública (debe ser la de Proton)
curl --silent https://ifconfig.me; echo
```

```bash
# Cerrar el túnel
sudo wg-quick down proton

# Levantarlo al arrancar
sudo systemctl enable --now wg-quick@proton.service
```

| Comando | Propósito |
|---------|-----------|
| `wg-quick up proton` | Crea la interfaz y levanta el túnel |
| `wg-quick down proton` | Cierra el túnel y elimina la interfaz |
| `wg show` | Muestra el estado del túnel y el tráfico |
| `wg-quick@proton.service` | Levanta el túnel al arrancar |

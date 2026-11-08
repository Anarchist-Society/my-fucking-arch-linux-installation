# Post-instalación: Programas

Estos son los programas que uso en el sistema, ordenados por categoría.

## Tabla de contenidos
- [Escritorio](#escritorio)
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
  - [unzip](#unzip)
  - [7zip](#7zip)
  - [mpv](#mpv)
  - [yt-dlp](#yt-dlp)
- [Hardware](#hardware)
  - [slimbook-bios-ec](#slimbook-bios-ec)
  - [zsa-moonlander](#zsa-moonlander)
- [Virtualización](#virtualización)
  - [VirtualBox](#virtualbox)
- [Juegos](#juegos)
  - [sober](#sober)
- [Red](#red)
  - [openssh](#openssh)
  - [nmap](#nmap)
  - [nftables](#nftables)

---

## Escritorio

### sddm

[SDDM](https://wiki.archlinux.org/title/SDDM) (Simple Desktop Display Manager) es el gestor de pantalla que permite iniciar sesión gráficamente y elegir la sesión (Hyprland) sin entrar por TTY.

```bash
# Instalar SDDM
sudo pacman --sync sddm

# Habilitar el servicio para que arranque en el boot
sudo systemctl enable sddm.service
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

[Kitty](https://sw.kovidgoyal.net/kitty/) es un emulador de terminal con GPU-acelerado, rápido y personalizable. Soporta tabs, splits, imágenes inline y temas.

```bash
# Instalar kitty
sudo pacman --sync kitty
```

| Paquete | Propósito |
|---------|-----------|
| `kitty` | Terminal emulator GPU-acelerado con soporte de imágenes y personalización |

### tmux

[tmux](https://github.com/tmux/tmux) es un multiplexor de terminal que permite mantener sesiones persistentes, organizar el trabajo en ventanas y paneles, y recuperar la sesión aunque se cierre el terminal o se desconecte la conexión SSH.

```bash
# Instalar tmux
sudo pacman --sync tmux
```

| Paquete | Propósito |
|---------|-----------|
| `tmux` | Multiplexor de terminal con sesiones persistentes, ventanas y paneles |

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

[OBS Studio](https://obsproject.com/) es un software de grabación y streaming de código abierto. En Hyprland requiere `xdg-desktop-portal-hyprland` para la captura de pantalla y `qt6-wayland` para evitar crashes.

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

La configuración predeterminada de Hyprland ya controla el lanzador; solo hay que pulsar **SUPER + R**.

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

[OpenJDK](https://openjdk.org/) es la implementación de referencia de Java. Incluye el JDK (Java Development Kit) para compilar y ejecutar aplicaciones Java.

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

[Flatpak](https://flatpak.org/) es un framework de sandboxing y distribución de aplicaciones Linux. Permite instalar aplicaciones aisladas del sistema con sus dependencias incluidas.

```bash
# Instalar flatpak
sudo pacman --sync flatpak
```

| Paquete | Propósito |
|---------|-----------|
| `flatpak` | Sandboxing y distribución de aplicaciones Linux |

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

[7-Zip](https://www.7-zip.org/) es un archivador de archivos con alta ratio de compresión. Se distribuye bajo la LGPL y soporta formatos como 7z, ZIP, RAR, TAR o GZ. Antes era provisto por el paquete `p7zip`, ya obsoleto en Arch.

```bash
# Instalar 7zip
sudo pacman --sync 7zip
```

| Paquete | Propósito |
|---------|-----------|
| `7zip` | Extraer y crear archivos comprimidos en formato 7z |

### mpv

[mpv](https://mpv.io/) es un reproductor de vídeo minimalista y ligero, altamente configurable. Soporta una amplia variedad de formatos de vídeo y audio.

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
sudo mount /dev/sdX1 /mnt

# Copiar directorios BIOS, EC y EFI a la raíz del pendrive
sudo cp -r BIOS EC EFI /mnt/

# Sincronizar datos pendientes
sudo sync

# Desmontar el pendrive
sudo umount /mnt
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

[VirtualBox](https://www.virtualbox.org/) es un hypervisor que permite ejecutar sistemas operativos en un entorno especial, llamado máquina virtual, sobre el sistema operativo existente. Está en constante desarrollo e incluye una interfaz gráfica Qt, así como herramientas de línea de comandos headless y SDL para gestionar y ejecutar máquinas virtuales.

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

### nmap

[nmap](https://nmap.org/) es un escáner de red que permite descubrir hosts, puertos y servicios activos, así como detectar versiones y sistemas operativos. Es útil para auditar la seguridad de una red local.

```bash
# Instalar nmap
sudo pacman --sync nmap
```

| Paquete | Propósito |
|---------|-----------|
| `nmap` | Escáner de red para descubrir hosts, puertos y servicios |

### nftables

[nftables](https://wiki.nftables.org/) es el firewall moderno del kernel Linux. Reemplaza a iptables y a ufw.

```bash
# Instalar nftables
sudo pacman --sync nftables
```

```bash
# Configurar
sudo nano /etc/nftables.conf
```

```nft
table inet filter {
    chain input {
        type filter hook input priority filter; policy drop;

        iif "lo" accept
        ct state established,related accept
        ct state invalid drop

        # ICMP / ICMPv6 (ping, vecinos IPv6, MTU)
        ip protocol icmp accept
        ip6 nexthdr icmpv6 accept

        # DHCP / DHCPv6 (systemd-networkd)
        udp dport 68 accept
        udp dport 546 accept

        # SSH (solo si usas sshd)
        tcp dport 22 accept
    }

    chain forward {
        type filter hook forward priority filter; policy drop;
    }

    chain output {
        type filter hook output priority filter; policy accept;
    }
}
```

```bash
# Aplicar y habilitar al inicio
sudo systemctl enable --now nftables

# Revisar las reglas activas
sudo nft list ruleset
```

- `policy drop` afecta a todo el sistema: si usas Docker, VirtualBox con red puente, KDE Connect o LocalSend, revisa la cadena `forward` y los puertos opcionales.
- Para revertir los cambios: `sudo systemctl stop nftables`.

Si más adelante instalas el servidor de Minecraft, añade a la cadena `input`:

```nft
tcp dport 25565 accept
```

Y no abras `25575/tcp` (rcon).

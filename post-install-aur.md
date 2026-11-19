# Post-instalación: Paquetes AUR

## Tabla de contenidos
- [AUR (Arch User Repository)](#aur-arch-user-repository)
- [Paru (AUR helper)](#paru-aur-helper)
- [Brave Browser](#brave-browser)
- [LocalSend](#localsend)
- [Exam Environment (freeCodeCamp)](#exam-environment-freecodecamp)
- [Minecraft (Java Edition)](#minecraft-java-edition)
- [Servidor de Minecraft (Java Edition)](#servidor-de-minecraft-java-edition)
- [PCSX2](#pcsx2)
- [RPCS3](#rpcs3)

---

## AUR (Arch User Repository)

[AUR](https://wiki.archlinux.org/title/Arch_User_Repository) es un repositorio comunitario donde los usuarios comparten [PKGBUILDs](https://wiki.archlinux.org/title/PKGBUILD) para instalar software no incluido en los repositorios oficiales de Arch. A diferencia de `pacman`, que instala binarios precompilados, los paquetes AUR se compilan desde el código fuente en tu máquina.

## Paru (AUR helper)

[Paru](https://github.com/Morganamilo/paru) es un asistente para AUR escrito en Rust, sucesor de yay. Permite instalar paquetes desde los repositorios oficiales y desde AUR con un solo comando.

```bash
# Instalar dependencias de compilación
sudo pacman -S --needed base-devel git

# Clonar y compilar paru desde AUR
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg --syncdeps --install --clean

# Paru sincroniza automáticamente la base de datos de paquetes con `--syncdeps` y elimina los fuentes tras la instalación con `--clean`.
```

| Paquete | Propósito |
|---------|-----------|
| `base-devel` | Herramientas de compilación (make, gcc, pkg-config, etc.) necesarias para `makepkg` |
| `git` | Sistema de control de versiones, necesario para clonar el repositorio de paru |

## Brave Browser

[Brave](https://brave.com/linux/) es un navegador web basado en Chromium con bloqueador de anuncios integrado, protección contra rastreo y énfasis en privacidad. Compatible con extensiones de Chrome.

```bash
# Instalar Brave
paru --sync brave-bin
```

| Paquete | Propósito |
|---------|-----------|
| `brave-bin` | Navegador Chromium con bloqueador de anuncios y protección antirrastreo (binario precompilado) |

## LocalSend

[LocalSend](https://localsend.org/) es una aplicación de código abierto para compartir archivos entre dispositivos en la red local de forma peer-to-peer, sin servidor central. Multiplataforma (Linux, Windows, macOS, Android, iOS).

```bash
# Instalar LocalSend
paru --sync localsend-bin
```

| Paquete | Propósito |
|---------|-----------|
| `localsend-bin` | Compartición de archivos local peer-to-peer multiplataforma (binario precompilado) |

## Exam Environment (freeCodeCamp)

[Exam Environment](https://github.com/freeCodeCamp/exam-env) es la aplicación de escritorio (Tauri) que usa [freeCodeCamp](https://www.freecodecamp.org/) para los exámenes certificados de su plataforma.

```bash
# Instalar Exam Environment
paru --sync exam-env
```

| Paquete | Propósito |
|---------|-----------|
| `exam-env` | Aplicación de escritorio de freeCodeCamp para los exámenes certificados |

## Minecraft (Java Edition)

[Minecraft Java Edition](https://www.minecraft.net/) es el juego original de construcción y supervivencia. El launcher oficial de Mojang se distribuye en AUR como `minecraft-launcher` e incluye el cliente, un script de lanzamiento y una entrada `.desktop`.

```bash
# Instalar el launcher oficial de Minecraft
paru --sync minecraft-launcher
```

| Paquete | Propósito |
|---------|-----------|
| `minecraft-launcher` | Launcher oficial de Minecraft Java Edition |

## Servidor de Minecraft (Java Edition)

El servidor vanilla se instala con el paquete AUR `minecraft-server`, que descarga el `.jar` oficial de Mojang y añade la integración con Arch: usuario y grupo `minecraft`, directorio `/srv/minecraft`, script de control `minecraftd`, unidad systemd y timer de backups. La referencia completa está en la [ArchWiki](https://wiki.archlinux.org/title/Minecraft/Java_Edition_server).

El servidor se ejecuta con el usuario sin privilegios `minecraft`. Si alguien consigue explotar el servidor, solo obtiene acceso a esa cuenta, no a la tuya. Por eso no se debe ejecutar como root ni cambiar el usuario del servicio.

> El paquete ya incluye el `.jar` oficial de [minecraft.net/download/server](https://www.minecraft.net/es-es/download/server). Descargarlo a mano solo es necesario si quieres una versión concreta, actualizar antes que el paquete AUR o prescindir de `minecraftd` y systemd.

### Instalación

```bash
# Instalar el servidor vanilla y ncat (para IDLE_SERVER)
paru --sync minecraft-server nmap

# tar suele venir en el grupo base, comprobar que está instalado
pacman -Q tar
```

| Paquete | Propósito |
|---------|-----------|
| `minecraft-server` | Servidor vanilla oficial, usuario `minecraft`, `/srv/minecraft`, script `minecraftd` y unidades systemd |
| `nmap` | Aporta `ncat`, necesario para suspender el servidor con `IDLE_SERVER` |
| `tar` | Necesario para crear backups. Suele estar instalado por defecto |

El paquete crea el usuario y grupo `minecraft`, el directorio `/srv/minecraft` y los siguientes archivos:

| Archivo | Propósito |
|---------|-----------|
| `minecraftd.service` | Servicio systemd del servidor |
| `minecraftd-backup.service` / `.timer` | Backup diario del mundo |
| `/usr/bin/minecraftd` | Script de control (`start`, `stop`, `console`, `backup`, etc.) |
| `/etc/conf.d/minecraft` | Configuración del script (RAM, backups, suspensión) |

### Aceptar la EULA

```bash
# Arrancar una vez para generar eula.txt
sudo minecraftd start

# Editar la EULA
sudo vim /srv/minecraft/eula.txt
```

```properties
eula=true
```

### Arranque y control

```bash
# Arrancar cuando lo necesites
sudo systemctl start minecraftd.service

# Alternativa sin systemd
sudo minecraftd start

# Estado del servidor
sudo minecraftd status

# Consola interactiva (tmux, se sale con Ctrl+b y luego d)
sudo minecraftd console
```

| Comando | Propósito |
|---------|-----------|
| `minecraftd start` | Arranca el servidor |
| `minecraftd stop` | Detiene el servidor |
| `minecraftd restart` | Reinicia el servidor |
| `minecraftd status` | Muestra el estado |
| `minecraftd console` | Abre la consola interactiva en tmux |
| `minecraftd command <cmd>` | Ejecuta un comando en la consola |
| `minecraftd backup` | Crea un backup del mundo |
| `minecraftd restore` | Restaura un backup |

### Permisos

```bash
# Añadir tu usuario al grupo minecraft
sudo usermod --append --groups minecraft "$USER"

# Escritura de grupo en todo el directorio
sudo chgrp --recursive minecraft /srv/minecraft
sudo chmod --recursive g+rwX /srv/minecraft

# Setgid: los archivos nuevos conservan el grupo minecraft
sudo find /srv/minecraft -type d -exec chmod g+s {} \;
```

Cierra sesión y vuelve a entrar para aplicar el grupo. Todos los archivos de `/srv/minecraft` deben pertenecer al usuario `minecraft` o, como mínimo, ser legibles y escribibles por él. Si el servidor no puede acceder a un archivo, fallará. Y si los permisos son muy restrictivos, puede que ni siquiera pueda escribir el error en el log.

### Configuración del servidor

El primer arranque ya genera un `server.properties` con valores por defecto. Cambia solo lo que necesites. Lo que no aparezca aquí se queda con su valor por defecto.

```bash
# Parar antes de editar
sudo minecraftd stop
vim /srv/minecraft/server.properties
```

```properties
# Nombre que aparece en la lista de servidores
motd=A Minecraft Server Of Anarchist-Penguin

# Puerto TCP en el que escucha el servidor (25565 por defecto)
server-port=25565

# Dificultad: peaceful, easy, normal o hard (por defecto easy)
difficulty=hard

# Número máximo de jugadores conectados a la vez (20 por defecto)
max-players=5
```

### RAM

```bash
# Configuración del script de gestión
sudo vim /etc/conf.d/minecraft
```

```bash
# RAM inicial y máxima (usar el mismo valor evita reajustes)
SERVER_START_CMD="java -Xms4G -Xmx4G -jar ./minecraft_server.jar nogui"
```

| Variable | Propósito |
|----------|-----------|
| `SERVER_START_CMD` | Comando de arranque. Aquí se ajustan `-Xms` (RAM inicial) y `-Xmx` (RAM máxima) |

### Backups

```bash
# Backup manual (funciona con el servidor arrancado o parado)
sudo minecraftd backup

# Restaurar (el servidor debe estar parado)
sudo minecraftd stop
sudo minecraftd restore
```

Haz un backup manual antes de actualizar, de parar el servidor o de hacer cambios importantes. Cada `sudo minecraftd backup` crea una copia nueva y elimina las antiguas, dejando solo `KEEP_BACKUPS`.

En `/etc/conf.d/minecraft`:

```bash
BACKUP_DEST="/srv/minecraft/backup"
BACKUP_PATHS="world" # en vanilla incluye Nether y End
BACKUP_FLAGS="-z" # compresión gzip
KEEP_BACKUPS=10 # conserva los 10 más recientes
```

### Firewall (nftables)

```bash
# Instalar nftables
sudo pacman --sync nftables

# Editar la configuración
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

    # Minecraft
    tcp dport 25565 accept comment "allow minecraft"

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

### Acceso desde Internet

#### IP local fija

IP local del equipo: `192.168.1.15` (reserva DHCP en el router). Si la IP cambia, el port forwarding deja de apuntar al equipo.

#### Port forwarding en el router

En la administración del router, dentro de *Port Forwarding* o *NAT*:

| Campo | Valor |
|-------|-------|
| aplicación / servicio | `Minecraft Server` |
| Puerto interno | `25565` |
| Puerto externo | `25565` |
| Protocolo | `TCP` |
| Destino | IP local del equipo (`192.168.1.15`) |

### Seguridad

Con el servidor arrancado, abre la consola:

```bash
sudo minecraftd console
```

```text
whitelist on
whitelist add NombreExactoDeUsuario
whitelist list
whitelist reload
op NombreExactoDeUsuario
```

## PCSX2

[PCSX2](https://pcsx2.net/) es un emulador de PlayStation 2 con frontend Qt y renderizado por hardware mediante Vulkan u OpenGL. No está en los repositorios oficiales de Arch, se instala desde AUR.

### Instalar

```bash
# Instalar PCSX2 desde AUR (compila desde fuente)
paru --sync pcsx2

# Comprobar la versión instalada
pcsx2-qt --version
```

| Paquete | Propósito |
|---------|-----------|
| `pcsx2` | Emulador de PS2 con frontend Qt, renderizado Vulkan/OpenGL y soporte de parches |

### BIOS

PCSX2 no incluye la BIOS de la PS2. Copia el archivo de BIOS en `~/.config/PCSX2/bios` antes de abrir el emulador.

```bash
# Crear la carpeta de BIOS
mkdir --parents ~/.config/PCSX2/bios
```

Copia allí el archivo de BIOS (`.bin` o `.rom0`), sin subcarpetas. Luego abre `Sistema → Ajustes → BIOS`, comprueba que `Directorio de BIOS` apunta a `~/.config/PCSX2/bios` y selecciona la imagen en `Selección de BIOS`.

| Ajuste | Valor | Motivo |
|--------|-------|--------|
| `Directorio de BIOS` | `~/.config/PCSX2/bios` | Ruta por defecto de PCSX2; solo compruébala |

> El archivo que se selecciona es el `.bin` o el `.rom0` de 4 MiB. Los `.diff`, `.rom1`, `.rom2`, `.erom` y `.nvm` son complementos.

> Si la BIOS no aparece en la lista, pulsa `Actualizar lista` o revisa que los ficheros estén directamente en la carpeta.

> `Arranque rápido` se deja activado (predeterminado) y `Avance rápido del arranque` desactivado (predeterminado). Si un juego no arranca, desactiva el arranque rápido solo en las propiedades de ese juego.

### ISO del juego

PCSX2 no incluye juegos. Hay que volcar los discos propios a ISO o BIN/CUE. Distribuir ISOs de terceros es ilegal.

```bash
# Crear la carpeta para las ISOs
mkdir --parents ~/Isos/ps2
```

Añade la carpeta en `Sistema → Ajustes → Lista de juegos` → `Directorios de búsqueda` → `Añadir...` y pulsa `Buscar juegos nuevos`. También puedes abrir una ISO suelta con `Sistema → Iniciar archivo...` o arrastrarla a la ventana.

| Formato | Nota |
|---------|------|
| ISO | El más directo: una imagen por disco |
| BIN/CUE | Necesario para juegos en CD con varias pistas |
| CHD | Comprimido. PCSX2 lo lee directamente |
| CSO/ZSO | Comprimido. Útil para juegos pequeños o en CD |

### Primer arranque

```bash
# Abrir PCSX2
pcsx2-qt
```

En el primer arranque, el asistente pide idioma, BIOS y tarjeta de memoria. Si se cierra antes de terminar, esos mismos ajustes están en `Sistema → Ajustes → BIOS` y `Sistema → Ajustes → Tarjetas de memoria`.

> En el asistente, desactiva `Activar actualizaciones automáticas`. El paquete de AUR no usa el actualizador interno de PCSX2, que en Linux solo funciona en el AppImage oficial, así que no se conecta a pcsx2.net para buscar versiones. Las actualizaciones de PCSX2 llegan con `paru` al actualizar el sistema.

Para comprobar que la BIOS funciona, usa `Sistema → Iniciar BIOS`. Para cargar un juego, selecciónalo en la lista o usa `Sistema → Iniciar archivo...`.

### Emulación

`Sistema → Ajustes → Emulación`.

#### Control de velocidad

> `Velocidad normal`, `Velocidad de avance rápido` y `Velocidad de cámara lenta` se dejan en `100 %`, `200 %` y `50 %`, que son los valores por defecto.

#### Ajustes del sistema

| Ajuste | Valor | Motivo |
|--------|-------|--------|
| `Habilitar VU1 multihilo (MTVU)` | Activado | Aprovecha los 16 hilos. Unos pocos juegos cuelgan; desactívalo solo en ese juego |

> Los demás ajustes (`Frecuencia de ciclo de la EE`, `Omisión de ciclos`, `Habilitar trucos`, `Precacheado de CDVD`, `Prefijado de subprocesos`, `Sistema de archivos del equipo` y `Activar CDVD rápido`) se dejan en sus valores por defecto. `CDVD rápido` solo se ofrece en ajustes por juego.

#### Ritmo de fotogramas/Control de latencia

> Se deja todo por defecto: `Latencia máxima de fotogramas` en `2`, `Ritmo de fotogramas óptimo` desactivado, `Sincronizar con frec. act. del equipo` desactivado, `Sincronización vertical (VSync)` desactivada, `Usar sincronización del equipo para VSync` desactivado y `Omitir fotogramas duplicados` activado. Con `vrr = 1` en Hyprland no hace falta forzar VSync: el panel ya evita el tearing, y el skip de duplicados por defecto ayuda en juegos a 30 fps sin coste extra.

### Gráficos

Ajustes recomendados en `Sistema → Ajustes → Gráficos`. El orden sigue las pestañas del emulador. Solo se listan los que difieren del valor por defecto.

> `API de gráficos` y `Adaptador`: dejar en `Automático (predeterminado)`. Con RADV, PCSX2 elige Vulkan y la `AMD Radeon 780M Graphics (RADV PHOENIX)`.

#### Imagen

> Toda la pestaña `Imagen` se deja por defecto: `Sin bordes`, `Estándar automática (4:3/3:2 progresivo)`, `No cambiar` en FMV, `Automático` al desentrelazar y `Bilineal (Suavizado)`. Siguen por defecto `Escalado por número enteros`, `Aplicar parches de imagen panorámica`, `Aplicar parches para desactivar el entrelazado`, `Compensación de imagen`, `Deshabilitar compensación de entrelazado` y `Mostrar área de sobrebarrido` (desactivados), y `Filtro antiborrosidad` (activado). Si quieres 16:9 en un título concreto, activa su parche panorámico en las propiedades de ese juego, no globalmente.

#### Renderizado

| Ajuste | Valor | Motivo |
|--------|-------|--------|
| `Resolución interna` | `3x nativa (~1080p/FHD)` | 1920×1344: más nitidez que 2x con menos carga que 4x en la iGPU |
| `Filtrado anisotrópico` | `16x` | Nitidez en superficies inclinadas. Si sube el consumo, bájalo a 8x |

> Los demás ajustes de `Renderizado` se dejan por defecto: `Bilineal (PS2)`, `Automático` en filtrado trilineal, `Sin escalar` en tramado, `Básica (recomendada)` en precisión de mezcla, `Mipmapping` activado, y `Prueba alfa precisa`, `AA1` y `Vista ordenada del rasterizador` desactivados.

> Si en algún juego vuelve a subir el ventilador, baja primero `Resolución interna` a `2x nativa` antes de tocar hacks; después, si hace falta, baja el filtrado anisotrópico a `8x`.

## RPCS3

[RPCS3](https://wiki.archlinux.org/title/RPCS3) es un emulador de PlayStation 3 con frontend Qt y renderizado por hardware mediante Vulkan u OpenGL. No está en los repositorios oficiales de Arch, se instala desde AUR.

### Instalar

```bash
# Instalar RPCS3 desde AUR (compila desde fuente)
paru --sync rpcs3-git
```

| Paquete | Propósito |
|---------|-----------|
| `rpcs3-git` | Emulador de PS3 desde la rama de desarrollo, con frontend Qt y renderizado Vulkan/OpenGL |

> Si `paru` pregunta por `qt6-multimedia-backend`, elige `1) qt6-multimedia-ffmpeg` (opción por omisión) y pulsa Enter. Para evitar el prompt, instala antes `sudo pacman -S --needed qt6-multimedia-ffmpeg`.

### Firmware

RPCS3 no incluye el firmware de la PS3. Descarga `PS3UPDAT.PUP` desde la [web de Sony](https://www.playstation.com/en-us/support/hardware/ps3/system-software/) e instálalo en `File → Install Firmware`.

> Una vez instalado puedes borrar el `PS3UPDAT.PUP` descargado: RPCS3 ya ha guardado el firmware en `~/.config/rpcs3`.

Los datos del emulador (firmware descomprimido, partidas y trofeos) se crean en `~/.config/rpcs3`.

> El firmware lo distribuye Sony, no hay que volcarlo de una consola.

### Juegos

RPCS3 no incluye juegos. Usa copias propias: carpetas de disco con `PS3_GAME`, paquetes `.pkg` instalables desde `File → Install .pkg` y licencias `.rap` para contenido de PSN. Añade la carpeta con tus juegos desde la lista de juegos del emulador.

```bash
# Ejemplo de carpeta para los volcados
mkdir --parents ~/Isos/ps3
```

> Distribuir copias de terceros es ilegal y Arch no las proporciona.

### Primer arranque

```bash
# Abrir RPCS3
rpcs3
```

En el primer arranque, instala el firmware y configura el mando en `Pads → Handlers` con `evdev`.

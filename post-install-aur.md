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

[PCSX2](https://pcsx2.net/) es un emulador de PlayStation 2 con frontend Qt y renderizado por hardware mediante Vulkan u OpenGL. Recompila la Emotion Engine y los VU con JIT, así que necesita una CPU de escritorio y una GPU compatible. No está en los repositorios oficiales de Arch: se instala desde AUR.

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

> El paquete compila PCSX2 y sus dependencias (Qt, ffmpeg, `rapidyaml`, etc.). En el 8845HS tarda entre 10 y 30 minutos. No interrumpas `paru` a mitad de la compilación.

> PCSX2 solo da soporte oficial a sus builds de AppImage y Flatpak. El paquete de AUR es un build de terceros. Si una actualización rompe la compilación, usa el AppImage estable de [pcsx2.net](https://pcsx2.net/downloads/) como alternativa.

> `pcsx2-latest-bin` es una nightly empaquetada como AppImage. Entra en conflicto con `pcsx2`, puede tener regresiones y no se recomienda como instalación principal. No instales los dos a la vez.

PCSX2 es solo de 64 bits: no necesita `multilib` ni `lib32`. `mesa` y `vulkan-radeon` ya están instalados en la guía base.

### BIOS

PCSX2 no incluye la BIOS de la PS2 y no existe una BIOS libre que la sustituya. Hay que volcar la de una consola propia con FreeMcBoot/Fortuna y `biosdrain`, o con otro método equivalente. Descargar una BIOS de terceros es ilegal y no está soportado.

```bash
# Crear la carpeta de BIOS
mkdir --parents ~/.config/PCSX2/bios
```

| Ruta | Propósito |
|------|-----------|
| `~/.config/PCSX2/bios` | Carpeta de búsqueda de BIOS por defecto |

Copia allí los ficheros del volcado (`*.rom0`, `*.rom1`, `*.nvm`, etc.), sin subcarpetas. Luego abre `Settings → BIOS`, comprueba que `BIOS Directory` apunta a esa ruta y selecciona la imagen en `BIOS Selection`.

| Ajuste | Valor | Motivo |
|--------|-------|--------|
| `BIOS Directory` | `~/.config/PCSX2/bios` | Ruta por defecto de PCSX2 |
| `Fast Boot` | Activado | Salta la animación de arranque de la consola |
| `Fast Forward Boot` | Desactivado | Solo acelera el arranque de la BIOS. No afecta al juego |

> Si la BIOS no aparece en la lista, pulsa `Refresh List` o revisa que los ficheros estén directamente en la carpeta. `Fast Boot` es un parche de la BIOS: si un juego necesita el arranque completo, usa `System → Start BIOS` o desactívalo puntualmente.

### ISO del juego

PCSX2 no incluye juegos. Hay que volcar los discos propios a ISO o BIN/CUE. Distribuir ISOs de terceros es ilegal.

```bash
# Crear la carpeta para las ISOs
mkdir --parents ~/Isos/ps2
```

Añade la carpeta en `Settings → Game List` → `Search Directories` → `Add...` y pulsa `Scan For New Games`. También puedes abrir una ISO suelta con `System → Start File...` o arrastrarla a la ventana.

| Formato | Nota |
|---------|------|
| ISO | El más directo: una imagen por disco |
| BIN/CUE | Necesario para juegos en CD con varias pistas |
| CHD | Comprimido. PCSX2 lo lee directamente |
| CSO/ZSO | Comprimido. Útil para juegos pequeños o en CD |

> Para comprimir a CHD hace falta `chdman` (paquete `mame-tools`): `chdman createdvd -i juego.iso -o juego.chd` para DVDs y `chdman createcd -i juego.iso -o juego.chd` para CDs. Conserva la ISO original hasta comprobar que el CHD arranca.

### Primer arranque

```bash
# Abrir PCSX2
pcsx2-qt
```

En el primer arranque, el asistente pide idioma, BIOS y tarjeta de memoria. Si se cierra antes de terminar, esos mismos ajustes están en `Settings → BIOS` y `Settings → Memory Cards`.

Para comprobar que la BIOS funciona, usa `System → Start BIOS`. Para cargar un juego, selecciónalo en la lista o usa `System → Start File...`.

### Gráficos

Ajustes recomendados en `Settings → Graphics`. El orden sigue las pestañas del emulador.

#### Display

| Ajuste | Valor | Motivo |
|--------|-------|--------|
| `Fullscreen Mode` | `Borderless Fullscreen` | Hyprland activa VRR (`vrr = 1`) solo en fullscreen |
| `Aspect Ratio` | `Auto Standard (4:3 Interlaced / 3:2 Progressive)` | Respeta la relación original y los parches 16:9 |
| `FMV Aspect Ratio Override` | `Off (Default)` | Mantiene las FMV con la misma relación que el juego |
| `Deinterlacing` | `Automatic (Default)` | Desentrelaza correctamente la mayoría de títulos |
| `Bilinear Filtering` | `Bilinear (Smooth)` | Suaviza la imagen ya escalada. `Bilinear (Sharp)` para 2D |
| `Integer Scaling` | Desactivado | Solo útil en 2D. Añade bordes y reduce el tamaño de la imagen |
| `Apply Widescreen Patches` | Activado | Aprovecha el panel 16:10. Desactivar por juego si deforma el HUD o las FMV |
| `Apply No-Interlacing Patches` | Desactivado | El desentrelazado automático ya funciona. Activar por juego si se ve entrelazado |
| `Anti-Blur` | Activado | Reduce el desenfoque interno. Es un hack, pero mejora la nitidez |

> `Apply Widescreen Patches` y `Apply No-Interlacing Patches` son parches por juego, no magia universal. Si un título se ve raro, desactívalos en sus propiedades antes de tocar el resto.

#### Rendering

| Ajuste | Valor | Motivo |
|--------|-------|--------|
| `Renderer` | `Vulkan` | Mejor rendimiento y compatibilidad en RDNA3 |
| `Adapter` | `AMD Radeon 780M` | GPU integrada del 8845HS |
| `Internal Resolution` | `4x Native (~1440px/QHD)` | En NTSC renderiza 2560×1792, casi nativo para el panel de 2560×1600. Bajar a 3x en juegos pesados, 5x en ligeros |
| `Texture Filtering` | `Bilinear (PS2)` | Respeta el filtrado original. `Bilinear (Forced)` para un look más limpio |
| `Trilinear Filtering` | `Automatic (Default)` | Corrige el blur en superficies inclinadas |
| `Anisotropic Filtering` | `16x` | Nitidez en superficies en ángulo, sin coste apreciable |
| `Dithering` | `Unscaled (Default)` | Mantiene el dithering original sin ampliar los puntos al escalar |
| `Blending Accuracy` | `Basic (Recommended)` | Equilibrio precisión/rendimiento en la 780M. Subir solo si hay artefactos |
| `Mipmapping` | Activado | Algunos juegos lo necesitan para renderizar bien |
| `Accurate Alpha Test` | Desactivado | Solo si hay transparencias rotas. Cuesta rendimiento |
| `AA1` | Desactivado | Antialiasing de PS2 muy caro y útil solo en unos pocos juegos |
| `Rasterizer Ordered View` | Desactivado | Solo para juegos con feedback loops. No es necesario por defecto |

> Si un juego no mantiene los 60 fps, baja `Internal Resolution` a `3x Native (~1080px/FHD)` antes de tocar los hacks. La diferencia en 16 pulgadas es pequeña.

#### Advanced

| Ajuste | Valor | Motivo |
|--------|-------|--------|
| `Texture Preloading` | `Full (Hash Cache)` | Evita subidas redundantes de texturas |

> `Hardware Download Mode` se oculta en los ajustes globales de las builds de release. Si un juego tiene efectos raros, cámbialo en sus ajustes por juego, no globalmente. El valor recomendado es `Accurate (Recommended)`.

### Emulación y rendimiento

`Settings → Emulation`.

| Ajuste | Valor | Motivo |
|--------|-------|--------|
| `Normal Speed` | `100%` | Velocidad real de la consola |
| `Fast-Forward Speed` | `200%` | Avance rápido sin disparar CPU/temperatura. `Unlimited` si lo prefieres |
| `Slow-Motion Speed` | `50%` | Solo se usa con el atajo de cámara lenta |
| `EE Cycle Rate` | `100% (Normal Speed)` | Sin underclock ni overclock. La 780M no lo necesita |
| `EE Cycle Skipping` | `Disabled` | Solo ayuda a juegos concretos y suele perjudicar |
| `Enable Multithreaded VU1 (MTVU)` | Activado | Aprovecha los 16 hilos. Unos pocos juegos cuelgan, desactivar por juego |
| `Enable CDVD Precaching` | Desactivado | Carga la ISO en RAM. No aporta en NVMe y retrasa el arranque |
| `Enable Thread Pinning` | Desactivado | Solo para CPU con núcleos P/E. El 8845HS es homogéneo |
| `Vertical Sync (VSync)` | Activado | Frame pacing estable a 60 fps en un panel de 120 Hz |
| `Sync to Host Refresh Rate` | Desactivado | Recomendado para VRR. No fuerces la velocidad del juego |
| `Use Host VSync Timing` | Desactivado | Solo se usa con `Sync to Host`. Añade latencia |
| `Optimal Frame Pacing` | Desactivado | Reduce latencia a costa de más CPU/GPU. Activar solo si sobra potencia |
| `Maximum Frame Latency` | `2 frames` | Equilibrio latencia/suavidad. Bajar a 1 en juegos de ritmo |
| `Skip Presenting Duplicate Frames` | Activado | Suaviza juegos de 30 fps |

> Con VRR en Hyprland, `Sync to Host Refresh Rate` debe estar desactivado. Si notas parpadeo o tirones, prueba a desactivar también `Vertical Sync (VSync)` y deja que el panel sincronice.

> `Enable Fast CDVD` no está disponible globalmente: actívalo solo en los ajustes por juego si sus cargas son muy largas. Puede romper juegos.

### Audio

`Settings → Audio`.

| Ajuste | Valor | Motivo |
|--------|-------|--------|
| `Backend` | `Cubeb` | Menor latencia. `SDL` si hay problemas con el dispositivo |
| `Output Device` | Predeterminado del sistema | Evita perder el audio al cambiar de salida |
| `Expansion` | `Disabled (Stereo)` | Los juegos de PS2 son estéreo. El surround solo para Pro Logic II |
| `Synchronization` | `TimeStretch (Recommended)` | Suaviza el audio al 100% y en avance rápido |
| `Buffer Size` | `50 ms` | Equilibrio latencia/estabilidad |
| `Output Latency` | `20 ms` | Latencia hasta la salida |

> Si el audio cruje, sube `Buffer Size` a 75–100 ms. Si usas auriculares y quieres menos latencia, bájalo a 30–40 ms. Por debajo puede aparecer crackling.

### Mandos

`Settings → Controllers`. En `Controller Port 1` selecciona `DualShock 2` y asigna los botones, o pulsa `Automatic Mapping` con el mando conectado. Para DualShock 4/DualSense, deja `Enable SDL Input Source` activado en `Global Settings`. SDL gestiona vibración y LED en Bluetooth.

| Ajuste | Valor | Motivo |
|--------|-------|--------|
| `Controller Port 1` | `DualShock 2` | Tipo estándar de la mayoría de juegos |
| `Controller Port 2` | `None` | Solo para multijugador local |
| `Multitap on Console Port 1` | Desactivado | Solo para juegos de 3–4 jugadores compatibles |
| `Enable SDL Input Source` | Activado | Detecta mandos modernos y DualSense por Bluetooth |

> Si el mando no aparece, prueba a conectarlo por USB antes de Bluetooth y revisa `Detected Devices`.

### Guardado

`Settings → Memory Cards` → `Create`. Pon un nombre, elige `Folder [Recommended]` y asigna la tarjeta a `Slot 1`. La tarjeta de tipo `Folder` guarda los datos como archivos, así que es más fácil hacer copias de seguridad y no hace falta convertir imágenes.

| Ajuste | Valor | Motivo |
|--------|-------|--------|
| `Slot 1` | Activado, tarjeta de tipo `Folder` | Guarda en el sistema de archivos. Más fácil de respaldar |
| `Slot 2` | Desactivado | La mayoría de juegos solo usan el slot 1 |
| `Folder` | `~/.config/PCSX2/memcards` | Ruta por defecto de las memory cards |

> Algunos juegos no son compatibles con las tarjetas de tipo `Folder`. Si un juego no guarda o no detecta la tarjeta, crea una tarjeta de 8 MB (`8 MB [Most Compatible]`) y úsala en ese juego.

> Los save states (`System → Save State` / `Load State`) no sustituyen al guardado de la memory card. Un save state puede dejar de cargar tras actualizar PCSX2. Guarda también desde el juego.

> Para una copia de seguridad, cierra PCSX2 y copia `~/.config/PCSX2/memcards/` a otro disco.

### Parches

PCSX2 incluye parches de widescreen y de no-interlacing para muchos juegos. Se activan globalmente en `Settings → Graphics → Display` y se pueden desactivar por juego en `Game Properties → Patches`.

| Ajuste | Valor | Motivo |
|--------|-------|--------|
| `Apply Widescreen Patches` | Activado | Aprovecha el panel 16:10. Desactivar si el HUD o las FMV se deforman |
| `Apply No-Interlacing Patches` | Desactivado | El desentrelazado automático ya da buena imagen. Activar por juego si aparece entrelazado |

> Los parches son hacks: si un juego se ve peor, desactívalos en `Game Properties → Patches` antes de cambiar la configuración global. No mezcles parches de versiones distintas del juego.

### Problemas comunes

- **La BIOS no aparece:** revisa `BIOS Directory`, que los ficheros estén directamente en `~/.config/PCSX2/bios` y pulsa `Refresh List`.
- **Un juego no arranca:** comprueba el volcado de la ISO, prueba otro renderer (`OpenGL`) y desactiva `Enable Multithreaded VU1 (MTVU)` en los ajustes por juego.
- **Va lento:** baja `Internal Resolution` a 3x, deja `Blending Accuracy` en `Basic`, desactiva `AA1` y `Accurate Alpha Test`. `radeontop` en otra terminal muestra si el límite es la GPU.
- **La ventana se comporta raro en Wayland:** ejecuta `QT_QPA_PLATFORM=xcb pcsx2-qt` para usar XWayland. El AppImage oficial también usa XWayland.

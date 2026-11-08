# Post-instalación: Paquetes AUR

## Tabla de contenidos
- [AUR (Arch User Repository)](#aur-arch-user-repository)
- [Paru (AUR helper)](#paru-aur-helper)
- [Brave Browser](#brave-browser)
- [LocalSend](#localsend)
- [Exam Environment (freeCodeCamp)](#exam-environment-freecodecamp)
- [Minecraft (Java Edition)](#minecraft-java-edition)
- [Servidor de Minecraft (Java Edition)](#servidor-de-minecraft-java-edition)

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

# tar suele venir en el grupo base; comprobar que está instalado
pacman -Q tar
```

| Paquete | Propósito |
|---------|-----------|
| `minecraft-server` | Servidor vanilla oficial, usuario `minecraft`, `/srv/minecraft`, script `minecraftd` y unidades systemd |
| `nmap` | Aporta `ncat`, necesario para suspender el servidor con `IDLE_SERVER` |
| `tar` | Necesario para crear backups; suele estar instalado por defecto |

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

```bash
# Arrancar de nuevo, ahora con la EULA aceptada
sudo minecraftd start
```

### Arranque y control

```bash
# Arrancar cuando lo necesites
sudo systemctl start minecraftd.service

# Alternativa sin systemd
sudo minecraftd start

# Estado del servidor
sudo minecraftd status

# Consola interactiva (tmux; se sale con Ctrl+b y luego d)
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

Cierra sesión y vuelve a entrar para aplicar el grupo. Todos los archivos de `/srv/minecraft` deben pertenecer al usuario `minecraft` o, como mínimo, ser legibles y escribibles por él. Si el servidor no puede acceder a un archivo, fallará; y si los permisos son muy restrictivos, puede que ni siquiera pueda escribir el error en el log.

### Configuración del servidor

El primer arranque ya genera un `server.properties` con valores por defecto. Cambia solo lo que necesites; lo que no aparezca aquí se queda con su valor por defecto.

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

Los comentarios son solo documentación: el servidor reescribe `server.properties` en cada arranque y los elimina.

- La whitelist viene activada por defecto en 26.3 (`white-list=true`); si no añades nombres, no entra nadie. Los añades en la sección de seguridad. Para expulsar a los que no estén en la lista al recargarla, añade `enforce-whitelist=true` (por defecto `false`).

### RAM y suspensión

```bash
# Configuración del script de gestión
sudo vim /etc/conf.d/minecraft
```

```bash
# RAM inicial y máxima (usar el mismo valor evita reajustes)
SERVER_START_CMD="java -Xms4G -Xmx4G -jar ./${MAIN_EXECUTABLE} nogui"

# Suspender el servidor si no hay jugadores
IDLE_SERVER=true
IDLE_IF_TIME=1200
```

| Variable | Propósito |
|----------|-----------|
| `SERVER_START_CMD` | Comando de arranque; aquí se ajustan `-Xms` (RAM inicial) y `-Xmx` (RAM máxima) |
| `IDLE_SERVER` | Suspende el servidor cuando no hay jugadores; al primer intento de conexión arranca solo |
| `IDLE_IF_TIME` | Segundos sin jugadores antes de suspender (por defecto 1200, 20 minutos) |
| `GAME_PORT` | Puerto que escucha `ncat` mientras el servidor está suspendido |

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

Copia los backups también fuera del equipo (otro disco, NAS o nube): un backup en el mismo SSD no protege de un fallo de disco.

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
    # Filtrar paquetes entrantes; por defecto, descartar
    type filter hook input priority filter
    policy drop

    # Loopback (localhost) siempre permitido
    iif "lo" accept comment "allow from loopback"

    # ct Connections Tracking
    # Conexiones ya establecidas o relacionadas (respuestas a tus conexiones salientes)
    ct state {established, related} accept comment "allow tracked connections"

    # Descartar paquetes malformados o que no encajan en ninguna conexión conocida
    ct state invalid drop comment "early drop of invalid connections"

    # Curiosidad: no responder a ping, como Windows (opcional)
    # Descomenta estas dos líneas para bloquear el eco entrante.
    # Deben ir ANTES del accept de ICMP; el resto de ICMP sigue permitido.
    icmp type echo-request drop
    icmpv6 type echo-request drop

    # ICMP (ping, IPv4) e ICMPv6 (ping, IPv6, MTU)
    # meta l4proto es agnóstico de familia: una regla cubre IPv4 e IPv6
    meta l4proto { icmp, icmpv6 } accept comment "allow icmp"

    # DHCP (obtener IP por DCHP / DHCPv6)
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

# Para revertir los cambios
sudo systemctl stop nftables.service
```

### Acceso desde Internet

#### Comprobar CGNAT

```bash
# IP pública vista desde tu red
curl -s https://ifconfig.me; echo
```

Compara esa IP con la IP WAN del router. Si son distintas, o la del router está en el rango `100.64.0.0/10`, el ISP usa CGNAT y el port forwarding no funcionará. Alternativas: IPv6, un túnel (Tailscale, playit.gg) o un VPS.

#### IP local fija

```bash
# Ver la IP local del equipo
ip -4 addr show
```

Anota la IP (por ejemplo `192.168.1.50`) y crea una reserva DHCP para esa MAC en el router, o configura una IP estática con systemd-networkd. Si la IP cambia, el port forwarding deja de apuntar al equipo.

#### Port forwarding en el router

En la administración del router, dentro de *Port Forwarding* o *NAT*:

| Campo | Valor |
|-------|-------|
| Puerto externo | `25565` |
| Puerto interno | `25565` |
| Protocolo | `TCP` |
| Destino | IP local del equipo (`192.168.1.50`) |

Abre solo `25565/TCP`. El puerto de rcon no se abre nunca.

#### DDNS (IP dinámica)

Si el ISP cambia la IP pública, configura un dominio DDNS (DuckDNS, Cloudflare, No-IP) en el router o con un cliente DDNS. Así los jugadores usan `tuservidor.duckdns.org:25565` en lugar de una IP que cambia.

#### IPv6 (opcional)

Si tienes IPv6 pública, puedes abrir `25565/tcp` para IPv6 en nftables y conectar mediante `[tu-ipv6]:25565`, evitando el CGNAT. Requiere que el cliente también tenga IPv6.

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

- `online-mode=true`, whitelist activa y `enforce-whitelist=true`.
- rcon desactivado.
- El servidor corre como usuario `minecraft`, nunca como root.
- Sistema y paquete actualizados con `paru -Syu`.
- Backups copiados fuera del equipo.

### Verificación

```bash
# Puerto a la escucha
ss -tulpn | grep 25565

# Prueba local
nc -vz 127.0.0.1 25565

# Estado del servicio
sudo minecraftd status
```

Desde fuera de la red (móvil con datos o un amigo):

```bash
nc -vz TU_IP_PUBLICA 25565
```

También puedes comprobarlo en `mcsrvstat.us` con `TU_IP:25565`. En el cliente: *Multijugador → Añadir servidor → `TU_IP:25565`*.

### Actualización

```bash
# Actualizar el paquete y reiniciar el servidor
paru -Syu
sudo minecraftd restart
```

El mundo y la configuración se conservan en `/srv/minecraft`.

Si el paquete AUR va por detrás del último release, sustituye el `.jar` manualmente:

```bash
# Parar el servidor
sudo minecraftd stop

# Copiar el .jar descargado de minecraft.net/download/server
sudo cp minecraft_server.1.21.x.jar /srv/minecraft/minecraft_server.jar
sudo chown minecraft:minecraft /srv/minecraft/minecraft_server.jar

# Arrancar de nuevo
sudo minecraftd start
```

### Diagnóstico

```bash
# Estado y logs del servicio
sudo systemctl status minecraftd.service
journalctl -u minecraftd -e

# Log del servidor
tail -f /srv/minecraft/logs/latest.log

# Permisos
ls -la /srv/minecraft

# Puerto ocupado o a la escucha
ss -tulpn | grep 25565

# Firewall
sudo nft list ruleset
```

| Síntoma | Causa probable |
|---------|----------------|
| `You need to agree to the EULA` | `eula.txt` en `false` o sin generar |
| `Permission denied` en logs o mundo | dueño o permisos incorrectos en `/srv/minecraft` |
| `Address already in use` | otro proceso en `25565` o dos instancias |
| `UnsupportedClassVersionError` | Java demasiado antiguo |
| Se conecta en LAN pero no desde fuera | port forwarding, CGNAT o firewall |
| `Connection refused` desde Internet | el router no redirige o nftables bloquea |

### Alternativas

| Necesidad | Paquete | Script |
|-----------|---------|--------|
| Plugins y mejor rendimiento | `papermc` | `papermc` |
| Plugins clásicos | `spigot` | `spigot` |
| Mods ligeros | `fabric-server` | `fabricd` |
| Mods pesados | `forge-server` | `forged` |
| Fork de Fabric | `quilt-server` | `quiltd` |
| Servidor en C++ | `cuberite` | `cuberite` |

El resto del flujo es idéntico: sustituye `minecraftd` por el script correspondiente y `/etc/conf.d/minecraft` por `/etc/conf.d/<script>`.

Para más información: [ArchWiki: Minecraft/Java Edition server](https://wiki.archlinux.org/title/Minecraft/Java_Edition_server), [Minecraft Wiki: Server.properties](https://minecraft.wiki/w/Server.properties) y [Minecraft Wiki: Setting up a server](https://minecraft.wiki/w/Tutorial:Setting_up_a_Java_Edition_server).

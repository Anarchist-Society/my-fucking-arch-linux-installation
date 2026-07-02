# Post-instalación: Primera conexión Wi-Fi con iwctl

[iwd (Arch Wiki)](https://wiki.archlinux.org/title/Iwd) es el daemon de Wi-Fi nativo de systemd. Es ligero, no tiene dependencias externas y se gestiona con `iwctl` desde TTY. A diferencia de NetworkManager, no necesita un gestor de red adicional — iwd + systemd-networkd son suficientes para la conectividad completa.

### Verificar que iwd está activo

```bash
# Verificar estado del servicio iwd
systemctl status iwd
```

Si no está activo, iniciarlo y habilitarlo:

```bash
# Habilitar iwd para que arranque automáticamente al iniciar el sistema
systemctl enable iwd

# Iniciar iwd ahora
systemctl start iwd
```

### Escanear redes disponibles

```bash
# Escanear redes Wi-Fi
iwctl station <device> scan

# Listar las redes encontradas
iwctl station <device> get-networks
```

`<device>` es el nombre de tu interfaz Wi-Fi (por ejemplo `wlan0`). Si no aparece, usa:

```bash
# Listar dispositivos de red disponibles
iwctl device list
```

### Conectarse a una red

```bash
# Conectarse a la red (iwctl pedirá la contraseña interactivamente)
iwctl station <device> connect <SSID>
```

Sustituye `<SSID>` por el nombre de la red. `iwctl` solicitará la contraseña. La red se guarda automáticamente en `iwd` para reconexiones futuras.

### Configurar red (asignación de IP)

[systemd-networkd](https://wiki.archlinux.org/title/Systemd-networkd) necesita ficheros `.network` para asignar IP por DHCP. Sin esto, `iwd` se conecta al Wi-Fi pero la interfaz no obtiene dirección IP:

```bash
sudo vim /etc/systemd/network/20-ethernet.network
```

```ini
# Red cableada: se aplica a interfaces de tipo ether (enp2s0, eth0...)
# Type=ether sin Kind=!* también matchearía interfaces virtuales (veth*) de contenedores
# https://bugs.archlinux.org/task/70892
[Match]
Type=ether

# Excluye interfaces virtuales (bridges, VLANs, veth...)
Kind=!* 

[Link]
# Esperar a que tenga una ruta por defecto antes de marcar el sistema como online
RequiredForOnline=routable

[Network]
# Obtener IP, puerta de enlace y DNS automáticamente desde el router
DHCP=yes

# Resolver nombres .local en la LAN
MulticastDNS=yes

# Métrica baja = prioridad alta. Ethernet es la interfaz preferida.
# systemd-networkd no asigna métricas por tipo de interfaz automáticamente:
# https://github.com/systemd/systemd/issues/17698
[DHCPv4]
RouteMetric=100

[IPv6AcceptRA]
RouteMetric=100
```

```bash
sudo vim /etc/systemd/network/20-wlan.network
```

```ini
# Red Wi-Fi: se aplica a interfaces de tipo wlan (wlan0, wlp2s0...)
[Match]
Type=wlan

[Link]
# Esperar a que tenga una ruta por defecto antes de marcar el sistema como online
RequiredForOnline=routable

[Network]
# Obtener IP, puerta de enlace y DNS automáticamente desde el router
DHCP=yes

# Resolver nombres .local en la LAN
MulticastDNS=yes

# Métrica media. Si Ethernet está disponible, el tráfico sale por Ethernet.
# systemd-networkd no asigna métricas por tipo de interfaz automáticamente:
# https://github.com/systemd/systemd/issues/17698
[DHCPv4]
RouteMetric=600

[IPv6AcceptRA]
RouteMetric=600
```

```bash
sudo vim /etc/systemd/network/20-wwan.network
```

```ini
# Red móvil (WWAN): se aplica a interfaces de tipo wwan (wwan0...)
[Match]
Type=wwan

[Link]
# Esperar a que tenga una ruta por defecto antes de marcar el sistema como online
RequiredForOnline=routable

[Network]
# Obtener IP, puerta de enlace y DNS automáticamente desde el router
DHCP=yes

# Resolver nombres .local en la LAN
MulticastDNS=yes

# Métrica alta = prioridad baja. Solo se usa si no hay Ethernet ni Wi-Fi.
# systemd-networkd no asigna métricas por tipo de interfaz automáticamente:
# https://github.com/systemd/systemd/issues/17698
[DHCPv4]
RouteMetric=900

[IPv6AcceptRA]
RouteMetric=900
```

Luego habilitar e iniciar systemd-networkd:

```bash
sudo systemctl enable --now systemd-networkd
```

Estos ficheros `.network` están basados en los ejemplos del [archiso oficial](https://gitlab.archlinux.org/archlinux/archiso/-/blob/master/configs/releng/airootfs/etc/systemd/network/) con las métricas de ruta y opciones adicionales de la [guía de systemd-networkd](https://wiki.archlinux.org/title/Systemd-networkd#Configure_a_wired_network_with_DHCP).

### Verificar conexión

```bash
# Probar conectividad
ping -c 3 ping.archlinux.org
```

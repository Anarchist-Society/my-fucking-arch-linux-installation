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

```
[Match]
Name=en*

[Network]
DHCP=yes
```

```bash
sudo vim /etc/systemd/network/20-wlan.network
```

```
[Match]
Name=wl*

[Network]
DHCP=yes
```

```bash
sudo vim /etc/systemd/network/20-wwan.network
```

```
[Match]
Name=ww*

[Network]
DHCP=yes
```

Luego habilitar e iniciar systemd-networkd:

```bash
sudo systemctl enable --now systemd-networkd
```

Estos ficheros `.network` están basados en los ejemplos del [archiso oficial](https://gitlab.archlinux.org/archlinux/archiso/-/blob/master/configs/releng/airootfs/etc/systemd/network/).

### Verificar conexión

```bash
# Probar conectividad
ping -c 3 ping.archlinux.org
```

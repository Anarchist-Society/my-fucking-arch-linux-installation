# Post-instalación: Primera conexión Wi-Fi con iwctl

[iwd (Arch Wiki)](https://wiki.archlinux.org/title/Iwd) es el daemon de Wi-Fi nativo de systemd. Es ligero, no tiene dependencias externas y se gestiona con `iwctl` desde TTY. A diferencia de NetworkManager, no necesita un gestor de red adicional — iwd + systemd-networkd son suficientes para la conectividad completa.

### Verificar que iwd está activo

```bash
# Verificar estado del servicio iwd
systemctl status iwd
```

Si no está activo, iniciarlo y habilitarlo:

```bash
# Iniciar y habilitar iwd automáticamente al arrancar
systemctl enable --now iwd
```

### Escanear redes disponibles

```bash
# Escanear redes Wi-Fi
iwctl station wlan0 scan
# Listar las redes encontradas
iwctl station wlan0 get-networks
```

`wlan0` es la interfaz Wi-Fi habitual. Si no aparece, usa:

```bash
# Listar dispositivos de red disponibles
iwctl device list
```

### Conectarse a una red

```bash
# Conectarse a la red (se guarda automáticamente)
iwctl --passphrase "<CONTRASEÑA>" station wlan0 connect "<SSID>"
```

Sustituye `<SSID>` por el nombre de la red y `<CONTRASEÑA>` por su clave. La red se guarda automáticamente en `iwd` para reconexiones futuras.

### Verificar conexión

```bash
# Probar conectividad
ping -c 4 archlinux.org
```

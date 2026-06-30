# Post-instalación: Primera conexión Wi-Fi con iwctl

[iwd (Arch Wiki)](https://wiki.archlinux.org/title/Iwd). Conectarse a una red Wi-Fi desde TTY usando `iwctl`.

### Verificar que iwd está activo

```bash
systemctl status iwd
```

Si no está activo, iniciarlo y habilitarlo:

```bash
systemctl enable --now iwd
```

### Escanear redes disponibles

```bash
iwctl station wlan0 scan && iwctl station wlan0 get-networks
```

`wlan0` es la interfaz Wi-Fi habitual. Si no aparece, usa `iwctl device list` para ver el nombre de tu interfaz.

### Conectarse a una red

```bash
iwctl --passphrase "<CONTRASEÑA>" station wlan0 connect "<SSID>"
```

Sustituye `<SSID>` por el nombre de la red y `<CONTRASEÑA>` por su clave. La red se guarda automáticamente en `iwd` para reconexiones futuras.

### Verificar conexión

```bash
ping -c 4 archlinux.org
```

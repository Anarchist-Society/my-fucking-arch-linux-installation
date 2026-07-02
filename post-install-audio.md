# Post-instalación: Audio

[PipeWire](https://wiki.archlinux.org/title/PipeWire) es un servidor multimedia que gestiona flujos de audio y vídeo en Linux. A diferencia de ALSA (nivel de kernel) y PulseAudio (servidor de sonido tradicional), PipeWire ofrece baja latencia, gestión segura de permisos (esencial en Wayland) y manejo unificado de audio y vídeo mediante un grafo de nodos enrutables.

WirePlumber actúa como gestor de sesiones: decide qué rutas de audio se conectan, maneja perfiles de dispositivos (altavoz, auriculares, HDMI) y aplica reglas de enrutamiento configuradas por el usuario o por el propio dispositivo. Es el reemplazo moderno de `pipewire-media-session`.

```bash
pacman --sync pipewire wireplumber pipewire-pulse pipewire-jack pipewire-alsa alsa-utils
```

| Paquete | Propósito |
|---------|-----------|
| `pipewire` | Servidor de audio/video |
| `wireplumber` | Gestor de sesiones de PipeWire, maneja rutas y perfiles |
| `pipewire-pulse` | Sustituye PulseAudio, permite que apps PulseAudio usen PipeWire |
| `pipewire-jack` | Compatibilidad con JACK, permite usar apps de audio profesional |
| `pipewire-alsa` | Capa de compatibilidad ALSA sobre PipeWire |
| `alsa-utils` | Herramientas ALSA como `alsamixer`, `amixer` |

Habilitar servicios de usuario:

```bash
systemctl --user enable --now pipewire.service
systemctl --user enable --now pipewire-pulse.service
systemctl --user enable --now wireplumber.service
```

### Firmware SOF (portátiles con DSP)

Los portátiles modernos (Ryzen 7000/8000, Intel Tiger Lake en adelante) suelen necesitar Sound Open Firmware para el DSP de audio:

```bash
pacman --sync sof-firmware
```


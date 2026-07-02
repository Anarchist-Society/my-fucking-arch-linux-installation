# Post-instalación: Audio

[PipeWire](https://wiki.archlinux.org/title/PipeWire) es un servidor multimedia que gestiona flujos de audio y vídeo en Linux. A diferencia de ALSA (nivel de kernel) y PulseAudio (servidor de sonido tradicional), PipeWire ofrece baja latencia, gestión segura de permisos (esencial en Wayland) y manejo unificado de audio y vídeo mediante un grafo de nodos enrutables.

WirePlumber actúa como gestor de sesiones: decide qué rutas de audio se conectan, maneja perfiles de dispositivos (altavoz, auriculares, HDMI) y aplica reglas de enrutamiento configuradas por el usuario o por el propio dispositivo. Es el reemplazo moderno de `pipewire-media-session`.

```bash
pacman -S pipewire wireplumber pipewire-pulse pipewire-alsa alsa-utils
```

- `pipewire` — servidor de audio/video
- `wireplumber` — gestor de sesiones
- `pipewire-pulse` — reemplazo de PulseAudio
- `pipewire-alsa` — compatibilidad ALSA
- `alsa-utils` — `alsamixer`, `amixer`

Habilitar servicios de usuario:

```bash
systemctl --user enable --now pipewire.socket pipewire-pulse.socket wireplumber
```

### Firmware SOF (AMD)

Los Ryzen 7000/8000 necesitan Sound Open Firmware para el DSP de audio:

```bash
pacman -S sof-firmware
```

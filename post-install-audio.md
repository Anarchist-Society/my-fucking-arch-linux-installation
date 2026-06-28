# Post-instalación: Audio

[PipeWire](https://wiki.archlinux.org/title/PipeWire) es el servidor de audio para Linux.

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

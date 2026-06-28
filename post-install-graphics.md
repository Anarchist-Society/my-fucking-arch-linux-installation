# Post-instalación: Drivers gráficos AMD

[AMDGPU](https://wiki.archlinux.org/title/AMDGPU) es el driver oficial para GPUs Radeon modernas (incluyendo la Radeon 780M del Ryzen 8845HS). El paquete `mesa` ya incluye los drivers de VA-API/VDPAU para aceleración de video.

```bash
pacman -S mesa vulkan-radeon
```

- `mesa` — OpenGL, Vulkan y aceleración de video (VA-API/VDPAU)
- `vulkan-radeon` — driver Vulkan para AMD

Para verificar que la aceleración de video funciona, instala `libva-utils` y ejecuta `vainfo`:

```bash
pacman -S libva-utils
vainfo
```

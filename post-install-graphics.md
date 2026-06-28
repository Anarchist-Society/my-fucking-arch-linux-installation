# Post-instalación: Drivers gráficos AMD

[AMDGPU](https://wiki.archlinux.org/title/AMDGPU) es el driver oficial para GPUs Radeon modernas (incluyendo la Radeon 780M del Ryzen 8845HS).

```bash
pacman -S mesa vulkan-radeon libva-mesa-driver
```

- `mesa` — implementación OpenGL/Vulkan
- `vulkan-radeon` — driver Vulkan para AMD
- `libva-mesa-driver` — aceleración VA-API (video)

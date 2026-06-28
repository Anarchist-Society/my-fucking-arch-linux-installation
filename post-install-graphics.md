# Post-instalación: Drivers gráficos AMD

[AMDGPU](https://wiki.archlinux.org/title/AMDGPU) es el driver oficial para GPUs Radeon modernas (incluyendo la Radeon 780M del Ryzen 8845HS).

```bash
pacman -S mesa vulkan-radeon
```

- `mesa` — OpenGL, Vulkan y aceleración de video (VA-API/VDPAU)
- `vulkan-radeon` — driver Vulkan para AMD

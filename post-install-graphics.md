# Post-instalación: Drivers gráficos AMD

[AMDGPU (Arch Wiki)](https://wiki.archlinux.org/title/AMDGPU) es el driver oficial para GPUs Radeon modernas (incluyendo la Radeon 780M del Ryzen 8845HS). OpenGL, Vulkan y aceleración de video (VA-API/VDPAU) están incluidos en mesa.

```bash
# Instalar drivers gráficos AMD
pacman --sync mesa vulkan-radeon
```

| Paquete | Propósito |
|---------|-----------|
| `mesa` | OpenGL, Vulkan y VA-API |
| `vulkan-radeon` | Driver Vulkan específico para AMD |

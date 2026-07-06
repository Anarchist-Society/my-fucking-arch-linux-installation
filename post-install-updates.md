# Post-instalación: Actualización del sistema

## Actualización completa

Actualizar paquetes y sistema con parámetros largos:

```bash
sudo pacman --sync --refresh --sysupgrade
```

| Parámetro | Función |
|-----------|---------|
| `--sync` | Sincronizar paquetes desde los repositorios |
| `--refresh` | Actualizar la base de datos de paquetes |
| `--sysupgrade` | Actualizar todos los paquetes desactualizados |

## Notas

- Ejecutar periódicamente para mantener el sistema actualizado
- Revisar los cambios antes de confirmar la instalación
- Si hay actualizaciones de base, leer [Arch Wiki](https://wiki.archlinux.org/title/System_maintenance)

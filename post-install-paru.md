# Post-instalación: Paru (AUR helper)

[Paru](https://github.com/Morganamilo/paru) es un asistente para AUR escrito en Rust, sucesor de yay. Permite instalar paquetes desde los repositorios oficiales y desde AUR con un solo comando.

> **Nota:** No se recomienda ejecutar `makepkg` como root. Ejecuta estos pasos con un usuario no root.

```bash
# Instalar dependencias de compilación
sudo pacman -S --needed base-devel git

# Clonar y compilar paru desde AUR
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg --syncdeps --install --clean
```

Paru sincroniza automáticamente la base de datos de paquetes con `--syncdeps` y elimina los fuentes tras la instalación con `--clean`.

| Paquete | Propósito |
|---------|-----------|
| `paru` | Asistente para AUR escrito en Rust. Permite instalar paquetes desde repos oficiales y AUR con un solo comando |


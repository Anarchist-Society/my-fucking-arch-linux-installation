# Post-instalación: Paru (AUR helper)

[Paru](https://github.com/Morganamilo/paru) es un asistente para AUR escrito en Rust, sucesor de yay. Permite instalar paquetes desde los repositorios oficiales y desde AUR con un solo comando.

> **Nota:** No se recomienda ejecutar `makepkg` como root. Si estás en chroot, espera al primer arranque o ejecuta estos pasos con un usuario no root.

```bash
# Instalar dependencias de compilación
pacman -S --needed base-devel git

# Clonar y compilar paru desde AUR
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg --syncdeps --install --clean
```

Paru sincroniza automáticamente la base de datos de paquetes con `--syncdeps` y elimina los fuentes tras la instalación con `--clean`.

### Uso básico

| Comando | Descripción |
|---------|-------------|
| `paru -S <paquete>` | Instalar desde repos o AUR |
| `paru -Rns <paquete>` | Eliminar paquete y dependencias no necesarias |
| `paru -Syu` | Actualizar sistema + AUR |
| `paru -Qs <texto>` | Buscar paquete instalado |
| `paru -G <paquete>` | Descargar PKGBUILD de AUR |
| `paru -Si <paquete>` | Mostrar información del paquete |

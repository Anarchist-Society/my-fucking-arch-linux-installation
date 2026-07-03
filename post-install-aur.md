# Post-instalación: Paquetes AUR

## AUR (Arch User Repository)

[AUR](https://wiki.archlinux.org/title/Arch_User_Repository) es un repositorio comunitario donde los usuarios comparten [PKGBUILDs](https://wiki.archlinux.org/title/PKGBUILD) para instalar software no incluido en los repositorios oficiales de Arch. A diferencia de `pacman`, que instala binarios precompilados, los paquetes AUR se compilan desde el código fuente en tu máquina.

> **Nota:** Necesitas [paru](post-install-paru.md) instalado para seguir estos pasos. No ejecutes `paru` como root — aunque el comando `paru --sync` se asemeja a `pacman --sync`, internamente compila desde fuente con `makepkg`, y este no debe ejecutarse como root por seguridad.

## Brave Browser

[Brave (Linux)](https://brave.com/linux/). Navegador web basado en Chromium con bloqueador de anuncios integrado, protección contra rastreo y énfasis en privacidad. Compatible con extensiones de Chrome.

```bash
# Instalar Brave
paru --sync brave-bin
```

| Paquete | Propósito |
|---------|-----------|
| `brave-bin` | Navegador Chromium con bloqueador de anuncios y protección antirrastreo (binario precompilado) |

## LocalSend

[LocalSend](https://localsend.org/). Aplicación de código abierto para compartir archivos entre dispositivos en la red local de forma peer-to-peer, sin servidor central. Multiplataforma (Linux, Windows, macOS, Android, iOS).

```bash
# Instalar LocalSend
paru --sync localsend
```

| Paquete | Propósito |
|---------|-----------|
| `localsend` | Compartición de archivos local peer-to-peer multiplataforma |

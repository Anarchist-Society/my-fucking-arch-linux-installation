# Post-instalación: Paquetes AUR

## Tabla de contenidos
- [AUR (Arch User Repository)](#aur-arch-user-repository)
- [Paru (AUR helper)](#paru-aur-helper)
- [Brave Browser](#brave-browser)
- [LocalSend](#localsend)
- [Exam Environment (freeCodeCamp)](#exam-environment-freecodecamp)
- [Minecraft (Java Edition)](#minecraft-java-edition)

---

## AUR (Arch User Repository)

[AUR](https://wiki.archlinux.org/title/Arch_User_Repository) es un repositorio comunitario donde los usuarios comparten [PKGBUILDs](https://wiki.archlinux.org/title/PKGBUILD) para instalar software no incluido en los repositorios oficiales de Arch. A diferencia de `pacman`, que instala binarios precompilados, los paquetes AUR se compilan desde el código fuente en tu máquina.

## Paru (AUR helper)

[Paru](https://github.com/Morganamilo/paru) es un asistente para AUR escrito en Rust, sucesor de yay. Permite instalar paquetes desde los repositorios oficiales y desde AUR con un solo comando.

```bash
# Instalar dependencias de compilación
sudo pacman -S --needed base-devel git

# Clonar y compilar paru desde AUR
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg --syncdeps --install --clean

# Paru sincroniza automáticamente la base de datos de paquetes con `--syncdeps` y elimina los fuentes tras la instalación con `--clean`.
```

| Paquete | Propósito |
|---------|-----------|
| `base-devel` | Herramientas de compilación (make, gcc, pkg-config, etc.) necesarias para `makepkg` |
| `git` | Sistema de control de versiones, necesario para clonar el repositorio de paru |

## Brave Browser

[Brave](https://brave.com/linux/) es un navegador web basado en Chromium con bloqueador de anuncios integrado, protección contra rastreo y énfasis en privacidad. Compatible con extensiones de Chrome.

```bash
# Instalar Brave
paru --sync brave-bin
```

| Paquete | Propósito |
|---------|-----------|
| `brave-bin` | Navegador Chromium con bloqueador de anuncios y protección antirrastreo (binario precompilado) |

## LocalSend

[LocalSend](https://localsend.org/) es una aplicación de código abierto para compartir archivos entre dispositivos en la red local de forma peer-to-peer, sin servidor central. Multiplataforma (Linux, Windows, macOS, Android, iOS).

```bash
# Instalar LocalSend
paru --sync localsend-bin
```

| Paquete | Propósito |
|---------|-----------|
| `localsend-bin` | Compartición de archivos local peer-to-peer multiplataforma (binario precompilado) |

## Exam Environment (freeCodeCamp)

[Exam Environment](https://github.com/freeCodeCamp/exam-env) es la aplicación de escritorio (Tauri) que usa [freeCodeCamp](https://www.freecodecamp.org/) para los exámenes certificados de su plataforma.

```bash
# Instalar Exam Environment
paru --sync exam-env
```

| Paquete | Propósito |
|---------|-----------|
| `exam-env` | Aplicación de escritorio de freeCodeCamp para los exámenes certificados |

## Minecraft (Java Edition)

[Minecraft Java Edition](https://www.minecraft.net/) es el juego original de construcción y supervivencia. El launcher oficial de Mojang se distribuye en AUR como `minecraft-launcher` e incluye el cliente, un script de lanzamiento y una entrada `.desktop`.

```bash
# Instalar el launcher oficial de Minecraft
paru --sync minecraft-launcher
```

| Paquete | Propósito |
|---------|-----------|
| `minecraft-launcher` | Launcher oficial de Minecraft Java Edition |

# Post-instalación: Paquetes AUR

## Tabla de contenidos
- [AUR (Arch User Repository)](#aur-arch-user-repository)
- [Paru (AUR helper)](#paru-aur-helper)
- [Brave Browser](#brave-browser)
- [LocalSend](#localsend)
- [Exam Environment (freeCodeCamp)](#exam-environment-freecodecamp)
- [Minecraft (Java Edition)](#minecraft-java-edition)
- [HolyC](#holyc)

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

## HolyC

[HolyC](https://holyc-lang.com) es el lenguaje de programación creado por Terry Davis para TempleOS. `holyc-lang` es un compilador (`hcc`) reescrito desde cero en C, que compila código HolyC a binarios nativos x86_64/arm64 e incluye la librería estándar `tos` (cadenas, tablas hash, I/O, matemáticas, parsing JSON, etc.).

```bash
# Instalar el compilador de HolyC
paru --sync holyc-lang-git
```

| Paquete | Propósito |
|---------|-----------|
| `holyc-lang-git` | Compilador HolyC (`hcc`) con la librería estándar `tos` |

#### Nota: PKGBUILD roto en AUR (v0.0.15-beta)

El PKGBUILD de AUR actualmente falla al compilar con dos errores:

1. **`pkgver() ha generado una versión no válida`** — upstream cambió el formato de sus tags git de `beta-v0.0.10` a `v0.0.15-beta` y la función `pkgver()` del PKGBUILD no lo interpreta, generando una versión con guiones que pacman rechaza.
2. **`referencia a 'asm_encode' sin definir`** — el PKGBUILD no compila con `-DHCC_ENABLE_JIT=on`. Sin esa flag, la librería del ensamblador (`tasm`) no se enlaza con `hcc`. El Makefile oficial del proyecto sí la usa.

Solución: parchear el PKGBUILD en la caché de paru y compilar con `makepkg`:

```bash
# Editar el PKGBUILD
vim ~/.cache/paru/clone/holyc-lang-git/PKGBUILD
```

| Fix | Dónde | Cambio |
|-----|-------|--------|
| 1 | función `pkgver()` | `local version=$(git describe --tags --no-abbrev \| sed -e 's/^v//' -e 's/^beta-v//' -e 's/-beta$//')` |
| 2 | función `build()` | añadir `-DHCC_ENABLE_JIT=on \` a las flags de `cmake` |

```bash
# Compilar e instalar desde la caché de paru
cd ~/.cache/paru/clone/holyc-lang-git
makepkg --cleanbuild --syncdeps --install --clean
```

> `--cleanbuild` es importante: si hay un `src/holyc-lang/src/build` de un intento anterior, la caché de CMake puede estar configurada sin el JIT.

> `-DHCC_ENABLE_JIT=on` además habilita el REPL y `hcc -jit`. Al ser un paquete `-git`, si lo reconstruyes hay que volver a aplicar el fix hasta que el maintainer actualice el PKGBUILD de AUR.

#### Observaciones del PKGBUILD corregido

| Tema | Detalle |
|------|---------|
| `.SRCINFO` desactualizado | Sigue indicando `pkgver = beta_v0.0.10`. No afecta a `makepkg`, solo a helpers/AUR; regenerar con `makepkg --printsrcinfo > .SRCINFO`. |
| Dependencia implícita de `gcc` | `hcc` invoca `cc` para ensamblar/enlazar los programas HolyC, pero el PKGBUILD solo declara `glibc`. En un sistema con `base-devel` está cubierto. `clang` solo hace falta para cross-compilar (`--target`). |
| Sin optimización | `-DCMAKE_BUILD_TYPE:STRING='None'` compila sin `-O2`; el Makefile oficial usa `Release`. Opcional cambiarlo para un `hcc` más rápido. |
| Caché de paru | `paru --sync holyc-lang-git` puede resetear el PKGBUILD parcheado; por eso se compila con `makepkg` directamente desde esa carpeta. |

```bash
# Verificar la instalación con un hola mundo
printf '"#Hello, HolyC!\n";' > hello.HC
hcc -o hello hello.HC && ./hello
```

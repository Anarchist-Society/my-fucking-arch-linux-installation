# Post-instalación: Paquetes AUR

## AUR (Arch User Repository)

[AUR](https://wiki.archlinux.org/title/Arch_User_Repository) es un repositorio comunitario donde los usuarios comparten [PKGBUILDs](https://wiki.archlinux.org/title/PKGBUILD) para instalar software no incluido en los repositorios oficiales de Arch. A diferencia de `pacman`, que instala binarios precompilados, los paquetes AUR se compilan desde el código fuente en tu máquina.

## Paru

[Paru](post-install-paru.md) es el asistente de AUR que instalé tras la instalación base siguiendo [`post-install-paru.md`](post-install-paru.md). Con `paru --sync <paquete>` (o `paru -S <paquete>`) se descarga el PKGBUILD, se resuelven dependencias (incluyendo otras dependencias AUR), se compila y se instala automáticamente — mismo flujo que `pacman -S` pero extendido a AUR.

```bash
# Sintaxis: instalar paquete desde AUR
paru --sync <paquete>
```

## Brave Browser

[Brave (Linux)](https://brave.com/linux/). Navegador web basado en Chromium con bloqueador de anuncios integrado, protección contra rastreo y énfasis en privacidad. Compatible con extensiones de Chrome.

```bash
# Instalar Brave
paru --sync brave-bin
```

| Paquete | Propósito |
|---------|-----------|
| `brave-bin` | Navegador Chromium con bloqueador de anuncios y protección antirrastreo (binario precompilado) |

# Post-instalación: Programas

## opencode

CLI interactiva de IA para desarrollo de software. Ejecuta comandos, edita archivos y responde preguntas sobre el código directamente en la terminal.

```bash
curl -fsSL https://opencode.ai/install | bash
```

## Git

[Git (Arch Wiki)](https://wiki.archlinux.org/title/Git). Sistema de control de versiones distribuido.

```bash
pacman -S git
```

### Configuración global

```bash
git config --global user.name "<NOMBRE>"
git config --global user.email "<EMAIL>"
git config --global init.defaultBranch main
git config --global pull.ff only
```

### Autenticación por SSH

Generar una clave SSH (usa el mismo email que en `user.email`):

```bash
ssh-keygen -t ed25519 -C "<EMAIL>"
```

Añadir la clave pública al agente SSH y configurar el cliente para GitHub:

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

```bash
mkdir --parents ~/.ssh && chmod 700 ~/.ssh
cat >> ~/.ssh/config << 'EOF'
Host github.com
    HostName github.com
    IdentityFile ~/.ssh/id_ed25519
    IdentitiesOnly yes
EOF
chmod 600 ~/.ssh/config
```

Ver la clave pública para añadir a GitHub:

```bash
cat ~/.ssh/id_ed25519.pub
```

Agrega la clave en [github.com/settings/keys](https://github.com/settings/keys). Verificar conexión:

```bash
ssh -T git@github.com
```

# DiskAgent

Analizador de disco con interfaz Liquid Glass para macOS, Linux y Windows:
mide qué ocupa el espacio, sugiere qué se puede limpiar con seguridad y
ofrece un asistente MCP.

Este repositorio distribuye únicamente binarios compilados. El código fuente
vive en un repositorio privado.

## Instalar

macOS (Apple Silicon o Intel) y Linux (x86_64):

```
curl -fsSL https://raw.githubusercontent.com/RemLiquit/disk-agent-releases/master/install.sh | sh
```

Windows (PowerShell):

```
irm https://raw.githubusercontent.com/RemLiquit/disk-agent-releases/master/install.ps1 | iex
```

## Instalación manual

Descarga desde [Releases](https://github.com/RemLiquit/disk-agent-releases/releases/latest):

- macOS: `DiskAgent-macos-arm64.zip` (o `.app.tar.gz`); arrastra `DiskAgent.app` a `/Applications`.
- Linux: `disk-agent-linux-x86_64`; haz `chmod +x` y ejecútalo.
- Windows: `disk-agent-windows-x86_64.exe`.

## Gatekeeper (macOS)

La app no está firmada con un certificado Developer ID de pago. El instalador
quita la cuarentena por ti. Si instalas a mano y macOS avisa, haz clic derecho
sobre la app y elige Abrir, o ejecuta `xattr -cr /Applications/DiskAgent.app`.

## Actualizaciones

Las nuevas versiones llegan dentro de la app: DiskAgent comprueba este
repositorio, verifica la firma Ed25519 de cada descarga y se actualiza con
"Actualizar y reiniciar". No hace falta volver a ejecutar el instalador.

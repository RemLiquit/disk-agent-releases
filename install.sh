#!/usr/bin/env bash
# Instala DiskAgent desde el último Release de GitHub (macOS y Linux).
#
#   curl -fsSL https://raw.githubusercontent.com/RemLiquit/disk-agent-releases/master/install.sh | sh
#
# macOS: instala DiskAgent.app en /Applications y le quita la cuarentena
# (com.apple.quarantine) porque la app no tiene certificado Developer ID de
# pago. Solo actúa porque tú ejecutas este instalador.
# Linux: deja el binario en ~/.local/bin y crea el lanzador .desktop.
set -euo pipefail

BASE="https://github.com/RemLiquit/disk-agent-releases/releases/latest/download"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

case "$(uname -s)" in
  Darwin)
    case "$(uname -m)" in
      arm64) arch=arm64 ;;
      x86_64) arch=x86_64 ;;
      *) echo "Arquitectura no soportada: $(uname -m)" >&2; exit 1 ;;
    esac
    asset="DiskAgent-macos-${arch}.app.tar.gz"
    echo "› Descargando ${asset}…"
    curl -fsSL "$BASE/$asset" -o "$tmp/$asset"
    tar -xzf "$tmp/$asset" -C "$tmp"
    [[ -d "$tmp/DiskAgent.app" ]] || { echo "El archivo no contiene DiskAgent.app." >&2; exit 1; }
    echo "› Instalando en /Applications…"
    rm -rf /Applications/DiskAgent.app
    cp -R "$tmp/DiskAgent.app" /Applications/DiskAgent.app
    xattr -cr /Applications/DiskAgent.app
    /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f /Applications/DiskAgent.app >/dev/null 2>&1 || true
    mdimport /Applications/DiskAgent.app >/dev/null 2>&1 || true
    mkdir -p "$HOME/.local/bin"
    rm -f "$HOME/.local/bin/disk-agent"
    cp /Applications/DiskAgent.app/Contents/MacOS/disk-agent "$HOME/.local/bin/disk-agent"
    echo "Listo: abre DiskAgent desde Launchpad o ejecuta 'disk-agent'."
    ;;
  Linux)
    if [[ "$(uname -m)" != "x86_64" ]]; then
      echo "Por ahora solo se publica build para Linux x86_64." >&2; exit 1
    fi
    echo "› Descargando disk-agent-linux-x86_64…"
    curl -fsSL "$BASE/disk-agent-linux-x86_64" -o "$tmp/disk-agent"
    mkdir -p "$HOME/.local/bin" "$HOME/.local/share/applications"
    rm -f "$HOME/.local/bin/disk-agent"
    cp "$tmp/disk-agent" "$HOME/.local/bin/disk-agent"
    chmod +x "$HOME/.local/bin/disk-agent"
    cat > "$HOME/.local/share/applications/disk-agent.desktop" <<DESKTOP
[Desktop Entry]
Type=Application
Name=DiskAgent
Comment=Analizador de disco
Exec=$HOME/.local/bin/disk-agent
Icon=drive-harddisk
Terminal=false
Categories=Utility;System;
DESKTOP
    echo "Listo: ejecuta 'disk-agent' (asegúrate de tener ~/.local/bin en el PATH)."
    ;;
  *)
    echo "Sistema no soportado. En Windows usa install.ps1." >&2; exit 1 ;;
esac

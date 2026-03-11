# n8n Lemon

Instalador de n8n self-hosted para el equipo de Lemon.

## Instalación (una sola vez)

Abrí la Terminal y ejecutá:

```bash
curl -fsSL https://raw.githubusercontent.com/patriciovallerino/n8n-lemon/main/instalar.sh | bash
```

El script instala todo automáticamente y te pide que elijas tu contraseña.

## Uso diario

Para iniciar n8n:

```bash
cd ~/Documents/n8n\ Lemon && ./iniciar.sh
```

Luego abrí **http://localhost:5678** en tu navegador.

## Archivos

| Archivo | Descripción |
|---------|-------------|
| `instalar.sh` | Script de instalación (correr una sola vez) |
| `iniciar.sh` | Script para iniciar n8n |
| `.env` | Configuración y contraseñas (se crea al instalar, no se sube al repo) |
| `data/` | Base de datos y workflows (local, no se sube al repo) |

## Requisitos

- macOS
- Conexión a internet (solo para la instalación)

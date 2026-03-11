#!/bin/bash
# Script para iniciar n8n con la configuración segura

# Activar Node.js 20 via nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
nvm use 20 --silent

# Cargar variables de entorno
set -a
source "$(dirname "$0")/.env"
set +a

echo "Iniciando n8n Lemon..."
echo "Abrí tu navegador en: http://localhost:$N8N_PORT"
echo "Usuario: $N8N_BASIC_AUTH_USER"
echo ""

n8n

#!/bin/bash
# ─────────────────────────────────────────────
#  Instalador de n8n Lemon
#  Corré este script una sola vez en tu Mac
# ─────────────────────────────────────────────

set -e

CARPETA="$HOME/Documents/n8n Lemon"

echo ""
echo "======================================"
echo "   Instalador de n8n Lemon"
echo "======================================"
echo ""

# ── 1. Verificar Node.js ──────────────────────
echo "[1/4] Verificando Node.js..."

instalar_node() {
  echo "  Node.js no encontrado. Instalando nvm + Node 20..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  source "$NVM_DIR/nvm.sh"
  nvm install 20
  nvm use 20
}

if command -v nvm &>/dev/null || [ -s "$HOME/.nvm/nvm.sh" ]; then
  export NVM_DIR="$HOME/.nvm"
  source "$NVM_DIR/nvm.sh"
  nvm install 20 --silent
  nvm use 20 --silent
elif command -v node &>/dev/null; then
  NODE_VERSION=$(node -e "process.exit(parseInt(process.versions.node))")
  if [ $? -lt 20 ]; then
    instalar_node
  fi
else
  instalar_node
fi

echo "  Node.js $(node --version) listo."

# ── 2. Instalar n8n ──────────────────────────
echo ""
echo "[2/4] Instalando n8n (puede tardar 2-3 minutos)..."
npm install n8n -g --silent
echo "  n8n $(n8n --version) instalado."

# ── 3. Crear carpeta y configuración ─────────
echo ""
echo "[3/4] Configurando n8n Lemon..."

mkdir -p "$CARPETA/data"

# Pedir contraseña
echo ""
echo "  Elegí una contraseña para acceder a n8n:"
read -s -p "  Contraseña: " PASSWORD
echo ""
read -s -p "  Repetir contraseña: " PASSWORD2
echo ""

if [ "$PASSWORD" != "$PASSWORD2" ]; then
  echo "  Error: las contraseñas no coinciden. Volvé a correr el instalador."
  exit 1
fi

if [ ${#PASSWORD} -lt 8 ]; then
  echo "  Error: la contraseña debe tener al menos 8 caracteres."
  exit 1
fi

# Generar clave de encriptación aleatoria
ENCRYPTION_KEY=$(openssl rand -base64 32)

# Crear .env
cat > "$CARPETA/.env" <<EOF
# ── SEGURIDAD ──────────────────────────────────────────
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=$PASSWORD

# Clave de encriptación (no compartir)
N8N_ENCRYPTION_KEY=$ENCRYPTION_KEY

# ── CONFIGURACIÓN GENERAL ──────────────────────────────
N8N_PORT=5678
N8N_PROTOCOL=http
N8N_HOST=localhost
N8N_USER_FOLDER="$CARPETA/data"

# ── LOGS ───────────────────────────────────────────────
N8N_LOG_LEVEL=warn
N8N_LOG_OUTPUT=console
EOF

chmod 600 "$CARPETA/.env"

# Crear script de inicio
cat > "$CARPETA/iniciar.sh" <<'SCRIPT'
#!/bin/bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
nvm use 20 --silent

CARPETA="$(dirname "$0")"
set -a
source "$CARPETA/.env"
set +a

echo ""
echo "n8n Lemon corriendo en: http://localhost:$N8N_PORT"
echo "Para detenerlo: Ctrl + C"
echo ""

n8n
SCRIPT

chmod +x "$CARPETA/iniciar.sh"

# ── 4. Iniciar n8n ───────────────────────────
echo ""
echo "[4/4] Todo listo. Iniciando n8n..."
echo ""
echo "======================================"
echo "  Abre tu navegador en:"
echo "  http://localhost:5678"
echo ""
echo "  Usuario:    admin"
echo "  Contraseña: la que elegiste"
echo "======================================"
echo ""
echo "Para iniciarlo en el futuro:"
echo "  cd \"$CARPETA\" && ./iniciar.sh"
echo ""

cd "$CARPETA"
./iniciar.sh

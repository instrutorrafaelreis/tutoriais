#!/usr/bin/env bash
# =====================================================================
# Cyber SENAI Porto - Lab Tudo-em-Um (Kali + Docker)
# Instala o Docker + Compose e sobe TODOS os alvos de treino numa unica
# VM Kali. Feito para rodar do zero, mesmo em redes que bloqueiam HTTP,
# e funciona tanto como root quanto com um usuario normal (sudo).
#
# Uso:
#   1) mkdir -p ~/lab && cd ~/lab
#   2) wget https://raw.githubusercontent.com/instrutorrafaelreis/tutoriais/main/lab/docker-compose.yml \
#           https://raw.githubusercontent.com/instrutorrafaelreis/tutoriais/main/lab/setup-lab.sh
#   3) bash setup-lab.sh
# =====================================================================

echo "[*] Cyber SENAI Porto - preparando o laboratorio tudo-em-um..."

# Usa sudo so quando NAO for root (como root, sudo atrapalha o PATH)
if [ "$(id -u)" -eq 0 ]; then SUDO=""; else SUDO="sudo"; fi

# 0) O docker-compose.yml precisa estar na mesma pasta
if [ ! -f "docker-compose.yml" ]; then
  echo "[!] docker-compose.yml nao encontrado nesta pasta."
  echo "    Baixe os DOIS arquivos (docker-compose.yml e setup-lab.sh) juntos e rode de novo."
  exit 1
fi

# 1) Forcar o apt para o mirror oficial da Cloudflare via HTTPS.
#    Muitas redes (escola/empresa) bloqueiam HTTP (porta 80), e algumas
#    instalacoes do Kali vem com mirrors so-HTTP (ex.: elmirror.cl) que
#    falham nessas redes. Apontar para https://kali.download resolve os
#    dois casos de uma vez.
echo "[*] Apontando o apt para o mirror oficial (HTTPS / Cloudflare)..."
$SUDO cp /etc/apt/sources.list /etc/apt/sources.list.bak 2>/dev/null || true
echo 'deb https://kali.download/kali kali-rolling main contrib non-free non-free-firmware' | $SUDO tee /etc/apt/sources.list >/dev/null

echo "[*] Atualizando a lista de pacotes (pode pedir a sua senha)..."
$SUDO apt-get update -y || true

# 2) Docker Engine
if ! command -v docker >/dev/null 2>&1; then
  echo "[*] Instalando o Docker (docker.io)..."
  $SUDO apt-get install -y docker.io
fi
$SUDO systemctl enable --now docker 2>/dev/null || true
[ -n "$SUDO" ] && $SUDO usermod -aG docker "$USER" 2>/dev/null || true

if ! command -v docker >/dev/null 2>&1; then
  echo "[!] Nao consegui instalar o Docker."
  echo "    Confirme que a VM tem internet (ex.: ping -c3 8.8.8.8) e rode de novo."
  exit 1
fi

# 3) Docker Compose: escolhe um que REALMENTE executa (nao so que existe)
#    Ordem: plugin v2 -> docker-compose -> apt -> binario do GitHub (HTTPS)
COMPOSE=""
if docker compose version >/dev/null 2>&1; then
  COMPOSE="docker compose"
elif docker-compose version >/dev/null 2>&1; then
  COMPOSE="docker-compose"
else
  $SUDO apt-get install -y docker-compose >/dev/null 2>&1 || true
  hash -r 2>/dev/null || true
  if docker-compose version >/dev/null 2>&1; then
    COMPOSE="docker-compose"
  else
    echo "[*] Baixando o Docker Compose v2 do GitHub (HTTPS)..."
    $SUDO wget -qO /usr/local/bin/docker-compose \
      https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64
    $SUDO chmod +x /usr/local/bin/docker-compose
    hash -r 2>/dev/null || true
    COMPOSE="docker-compose"
  fi
fi

# Verificacao final: o Compose escolhido precisa rodar de fato
if ! $SUDO $COMPOSE version >/dev/null 2>&1; then
  echo "[!] O Docker Compose nao esta executando corretamente."
  echo "    Teste manualmente:  $COMPOSE version"
  exit 1
fi
echo "[*] Usando o Compose: '$COMPOSE'"

# 4) Sobe os alvos (baixa as imagens do Docker Hub via HTTPS na 1a vez)
echo "[*] Subindo os containers (na primeira vez demora alguns minutos)..."
$SUDO $COMPOSE up -d

# 5) Mostra os enderecos
echo ""
echo "============================================================"
echo "  Laboratorio pronto! Acesse pelo navegador do Kali:"
echo "    DVWA        ->  http://localhost:8081    (admin / password)"
echo "    Juice Shop  ->  http://localhost:3000"
echo "    WebGoat     ->  http://localhost:8080/WebGoat"
echo "    WordPress   ->  http://localhost:8082"
echo "------------------------------------------------------------"
echo "  Confira:   $SUDO docker ps"
echo "  Desligar:  $SUDO $COMPOSE down"
echo "============================================================"

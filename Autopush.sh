#!/bin/bash

# Cores
VERDE='\033[0;32m'
CIANO='\033[0;36m'
RESET='\033[0m'

echo -e "${CIANO}=== Enviando para o GitHub (Sincronizado) ===${RESET}"

# 1. Configurações Globais
git config --global credential.helper store
git config --global init.defaultBranch main

[ -z "$(git config --global user.name)" ] && read -p "Usuário GitHub: " user && git config --global user.name "$user"
[ -z "$(git config --global user.email)" ] && read -p "E-mail GitHub: " mail && git config --global user.email "$mail"

# 2. Inicializar se não existir
if [ ! -d ".git" ]; then
    git init
fi

# 3. GARANTIA: Salva os arquivos locais ANTES de baixar do servidor
git branch -M main
git add .
read -p "Mensagem do commit (vazio para 'update'): " mensagem
[[ -z "$mensagem" ]] && mensagem="Update automático"

# Faz o commit local primeiro (isso protege seu Autopush.sh)
git commit -m "$mensagem" || echo "Sem mudanças novas no momento."

# 4. Configurar Remote
url_repo=$(git remote get-url origin 2>/dev/null)
if [ -z "$url_repo" ]; then
    read -p "URL do repositório (HTTPS): " url_repo
    git remote add origin "$url_repo"
else
    echo -e "Usando URL existente: ${CIANO}$url_repo${RESET}"
fi

# 5. SINCRONIZAÇÃO SEGURA
echo -e "${VERDE}Baixando README/LICENSE do servidor...${RESET}"
# O pull agora vem DEPOIS do commit, então seus arquivos não somem
git pull origin main --rebase

# 6. Push final
echo -e "${VERDE}Enviando tudo para o GitHub...${RESET}"
git push -u origin main

echo -e "${CIANO}=== Processo Finalizado! Verifique seu GitHub. ===${RESET}"

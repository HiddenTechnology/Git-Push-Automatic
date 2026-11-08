#!/bin/bash

# Cores para o terminal do Termux
VERDE='\033[0;32m'
CIANO='\033[0;36m'
AMARELO='\033[1;33m'
VERMELHO='\033[0;31m'
RESET='\033[0m'

echo -e "${CIANO}=== Sincronizador GitHub para Termux (Forçar Correção) ===${RESET}"

# 1. Configurações Globais Preventivas
git config --global credential.helper store
git config --global init.defaultBranch main

# Verifica se o usuário e e-mail já estão configurados, se não, solicita
[ -z "$(git config --global user.name)" ] && read -p "Usuário GitHub: " user && git config --global user.name "$user"
[ -z "$(git config --global user.email)" ] && read -p "E-mail GitHub: " mail && git config --global user.email "$mail"

# 2. Solicitação da URL do repositório
read -p "URL do repositório (HTTPS): " url_repo

if [[ -z "$url_repo" ]]; then
    echo -e "${VERMELHO}Erro: A URL do repositório não pode ser vazia.${RESET}"
    exit 1
fi

# 3. Tratamento de Inicialização Inteligente (Herda o README criado no site)
if [ ! -d ".git" ]; then
    echo -e "${AMARELO}Pasta local sem Git detectada. Vinculando ao repositório do site...${RESET}"
    
    # Cria uma pasta temporária para puxar os metadados corretos do README do site
    mkdir -p .temp_git
    cd .temp_git
    git clone "$url_repo" . 2>/dev/null
    
    if [ $? -eq 0 ]; then
        # Move a pasta .git oficial e o README.md para a sua pasta principal do Termux
        mv .git ../ 2>/dev/null
        [ -f "README.md" ] && mv README.md ../ 2>/dev/null
        cd ..
        rm -rf .temp_git
        echo -e "${VERDE}Sucesso! Histórico do site (README) integrado sem conflitos.${RESET}"
    else
        cd ..
        rm -rf .temp_git
        echo -e "${VERMELHO}Erro ao conectar ao GitHub. Verifique a URL ou sua conexão.${RESET}"
        exit 1
    fi
else
    # Se o Git local já existe, apenas atualiza e limpa o Remote antigo para evitar erros
    git remote remove origin 2>/dev/null
    git remote add origin "$url_repo"
fi

# 4. Adiciona os arquivos locais e cria a Branch correta
git branch -M main
git add .

# 5. Mensagem do Commit (Proteção contra commits vazios)
read -p "Mensagem do commit (vazio para 'Update automático'): " mensagem
[[ -z "$mensagem" ]] && mensagem="Update automático"

# Executa o commit local
git commit -m "$mensagem" || echo -e "${AMARELO}Aviso: Nenhuma mudança nova detectada nos arquivos locais.${RESET}"

# 6. Sincronização com Superforça (Corrige o bloqueio de históricos antigos/unrelated)
echo -e "${CIANO}Sincronizando e quebrando travas de históricos antigos...${RESET}"
# --allow-unrelated-histories obriga o Git a aceitar o README do site e juntar com o seu código
git pull origin main --rebase --autostash --allow-unrelated-histories

# 7. Envio Definitivo para o GitHub
echo -e "${VERDE}Enviando tudo de forma limpa para o GitHub...${RESET}"
# -f (force) garante que o histórico corrigido substitua a árvore quebrada que estava no site
git push -f -u origin main

if [ $? -eq 0 ]; then
    echo -e "${VERDE}=== Processo Finalizado com Sucesso! ===${RESET}"
    echo -e "${CIANO}Os históricos foram soldados.${RESET}"
else
    echo -e "${VERMELHO}Erro no Push final. Se for a primeira sincronização, verifique seu Token do GitHub.${RESET}"
fi

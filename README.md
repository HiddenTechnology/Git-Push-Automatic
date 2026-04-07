# Git-Push-Automatico
Suba seus projetos de maneira fácil e rápido apenas rodando uma script.

----------------------------------------
Define a configuração local
----------------------------------------

- Usuário GitHub:

- E-mail GitHub:

Mensagem do commit: (qualquer descrição da sua alteração ou aperte enter para seguir o padrão)

----------------------------------------
Define a configuração do servidor
----------------------------------------

URL do repositório (HTTPS):
https://github.com

Username for 'https://github.com':

Password for 'https://...': ghp_************************************ (Não é senha, é token)

Caso você erre a senha, é só rodar o comando 
```
rm ~/.git-credentials
```

# 🛠 Instalação Kali
```
sudo apt install git -y

git clone https://github.com/HiddenTechnology/Git-Push-Automatic

cd Git-Push-Automatic

mv Autopush.sh /usr/local/bin/Autopush

chmod +x /usr/local/bin/Autopush

cd

rm -rf Git-Push-Automatic
```
```
Autopush
```

# 📱 Instalação Termux
```
pkg install git -y

git clone https://github.com/HiddenTechnology/Git-Push-Automatic

cd Git-Push-Automatic

mv Autopush.sh $PREFIX/bin/Autopush

chmod +x $PREFIX/bin/Autopush

cd

rm -rf Git-Push-Automatic
```
```
Autopush
```

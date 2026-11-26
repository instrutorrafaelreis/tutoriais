# Cyber SENAI Porto — Tutoriais (Lab Web)

Material **público** de treino para os alunos: a página com a **explicação do desafio**
e o **tutorial passo a passo** de exploração web (DVWA + Juice Shop), mais os arquivos
para **montar o laboratório** em uma única VM Kali.

> ⚠️ Esta versão **não** contém a prova nem o gabarito — apenas o conteúdo didático.

## 📄 Página do tutorial (`index.html`)
Arquivo único, estático. Abas **Sobre o Desafio** e **Tutorial**.
Depois de publicado no GitHub Pages, fica acessível em:
`https://instrutorrafaelreis.github.io/tutoriais/`

## 🧪 Montar o laboratório (`lab/`)
Uma VM Kali nova (≈80 GB de disco, 8 GB de RAM, rede NAT durante a montagem).
No terminal do Kali:

```
mkdir -p ~/lab && cd ~/lab
wget -O docker-compose.yml https://raw.githubusercontent.com/instrutorrafaelreis/tutoriais/main/lab/docker-compose.yml
wget -O setup-lab.sh https://raw.githubusercontent.com/instrutorrafaelreis/tutoriais/main/lab/setup-lab.sh
bash setup-lab.sh
```

O instalador ajusta o apt para HTTPS, instala o Docker + Compose e sobe os alvos:
DVWA (`:8081`), Juice Shop (`:3000`), WebGoat (`:8080`) e WordPress (`:8082`).
Deu erro? Veja `lab/resolver-docker.txt`.

## Como colocar a página online (GitHub Pages)
1. Com este repositório no GitHub, vá em **Settings → Pages**.
2. Em **Branch**, escolha `main` e a pasta `/ (root)` → **Save**.
3. Em ~1 min a página fica no ar no endereço acima.

## Uso
Material **autorizado apenas** para laboratório local de treino.

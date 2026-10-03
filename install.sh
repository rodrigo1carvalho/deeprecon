#!/usr/bin/env bash
# DeepRecon - instalador para Kali Linux
set -e

echo "[*] Atualizando pacotes..."
sudo apt update

echo "[*] Instalando Tor (necessário p/ módulo darkweb) e pip..."
sudo apt install -y tor python3-pip

echo "[*] Habilitando e iniciando serviço Tor..."
sudo systemctl enable tor
sudo systemctl start tor

echo "[*] Instalando o DeepRecon e dependências Python..."
pip3 install --break-system-packages -e .

echo "[+] Instalação concluída."
echo "    Teste o Tor:        curl --socks5-hostname 127.0.0.1:9050 https://check.torproject.org"
echo "    Rodar a ferramenta: deeprecon exemplo.com.br"
echo "    (ou, sem instalar:  python3 -m deeprecon.cli exemplo.com.br)"

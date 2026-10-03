# 🕵️ DeepRecon

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Python](https://img.shields.io/badge/python-3.9%2B-blue.svg)
![Platform](https://img.shields.io/badge/platform-Kali%20Linux-557C94.svg)
![Status](https://img.shields.io/badge/status-beta-yellow.svg)

**DeepRecon** é uma ferramenta OSINT **100% open source**, feita para a fase
de **reconhecimento (recon)** em testes de intrusão (pentest) — inspirada em
soluções comerciais de inteligência estilo i2/Maltego/InnateVault, mas
construída inteiramente com bibliotecas livres e pensada para rodar nativamente
no **Kali Linux**.

Ela automatiza três frentes que normalmente são feitas manualmente:

1. **Google Hacking (dorks)** — encontra arquivos expostos, painéis de
   administração, credenciais vazadas em repositórios públicos e mais;
2. **Enumeração de infraestrutura** — subdomínios (via Certificate
   Transparency) e WHOIS do alvo;
3. **Dark & Deep Web** — busca o nome/domínio do alvo em motores de busca que
   indexam serviços `.onion`, via Tor;

...e consolida tudo em um **relatório único (HTML + JSON)**.

---

## ⚠️ Aviso legal — leia antes de usar

> Esta ferramenta deve ser usada **apenas em ativos para os quais você tem
> autorização explícita e por escrito** (contrato de pentest, programa de bug
> bounty com escopo definido, ou ativos próprios).
>
> Buscar informações sobre terceiros sem autorização pode violar leis como a
> **LGPD** (Lei 13.709/2018) e a **Lei de Crimes Cibernéticos** (Lei
> 12.737/2012) no Brasil, além de legislações equivalentes em outros países
> (ex.: CFAA nos EUA). Os mantenedores deste projeto **não se
> responsabilizam** por uso indevido. Veja [SECURITY.md](SECURITY.md).

---

## 📦 O que a ferramenta faz

| Módulo       | Descrição                                                                                          | Precisa de quê? |
|--------------|-----------------------------------------------------------------------------------------------------|------------------|
| `dorks`      | Google Hacking automatizado: `filetype:`, `intitle:"index of"`, painéis de login, segredos em GitHub/Pastebin | Nada (ou API key opcional do Google) |
| `subdomain`  | Enumeração via Certificate Transparency (crt.sh) + resolução de DNS                                 | Nada |
| `whois`      | Dados de registro (WHOIS) do domínio alvo                                                           | Nada |
| `darkweb`    | Busca o alvo em motores que indexam `.onion` (ex.: Ahmia)                                           | Tor rodando localmente |
| `breach`     | Checagem de vazamentos de credenciais via Have I Been Pwned                                         | API key da HIBP (paga) |
| `full`       | Roda todos os módulos acima e gera o relatório consolidado                                          | — |

Gera relatório em:
- **HTML** — visual, tema escuro, pronto para anexar a um relatório de pentest;
- **JSON** — estruturado, para integrar com outros scripts/ferramentas.

---

## 🖥️ Instalação (Kali Linux)

```bash
git clone https://github.com/SEU_USUARIO/deeprecon.git
cd deeprecon
chmod +x install.sh
./install.sh
```

O instalador:
1. Instala o pacote `tor` e inicia o serviço (SOCKS5 em `127.0.0.1:9050`);
2. Instala o DeepRecon e suas dependências Python via `pip3 install -e .`.

### Instalação manual (qualquer distro Linux)

```bash
git clone https://github.com/SEU_USUARIO/deeprecon.git
cd deeprecon
pip3 install -e .
# Para o módulo darkweb, instale e inicie o Tor:
sudo apt install tor -y && sudo systemctl start tor
```

---

## 🚀 Como usar

Depois de instalado, o comando `deeprecon` fica disponível globalmente:

```bash
# Reconhecimento completo (todos os módulos)
deeprecon exemplo.com.br

# Apenas Google Dorks
deeprecon exemplo.com.br -m dorks

# Apenas enumeração de subdomínios
deeprecon exemplo.com.br -m subdomain

# Apenas WHOIS
deeprecon exemplo.com.br -m whois

# Apenas dark web (requer Tor ativo)
deeprecon exemplo.com.br -m darkweb

# Usando a Google Custom Search API (recomendado, evita bloqueio/captcha)
deeprecon exemplo.com.br -m dorks --google-api-key SUA_KEY --google-cse-id SEU_CSE_ID

# Checagem de vazamentos (requer chave paga da HIBP)
deeprecon exemplo.com.br -m breach --hibp-key SUA_KEY

# Sem instalar (rodando direto do código-fonte)
python3 -m deeprecon.cli exemplo.com.br
```

Todas as opções:

```bash
deeprecon --help
```

Os relatórios são salvos por padrão em `./reports/` (ajustável com `--outdir`).

---

## 🔧 Notas técnicas importantes

- **Google Dorks via scraping**: o Google pode mostrar captcha/bloquear IPs
  que fazem muitas buscas automatizadas em pouco tempo. A ferramenta já
  inclui delay entre requisições, mas para uso profissional/recorrente, use a
  **Google Custom Search JSON API** (gratuita até 100 consultas/dia):
  - Crie uma API key em https://console.cloud.google.com/
  - Crie um mecanismo de busca em https://programmablesearchengine.google.com/

- **Dark Web**: o módulo usa o Tor como proxy SOCKS5 (`127.0.0.1:9050`).
  Verifique se está ativo com:
  ```bash
  sudo systemctl status tor
  curl --socks5-hostname 127.0.0.1:9050 https://check.torproject.org
  ```
  O motor padrão incluso é o **Ahmia** (https://ahmia.fi). Novos motores
  podem ser adicionados em `deeprecon/modules/darkweb.py`, no dicionário
  `ONION_SEARCH_ENGINES`.

- **Subdomínios**: usa a base pública de Certificate Transparency (crt.sh) —
  **não** faz brute-force ativo contra o alvo (menos intrusivo, menor chance
  de disparar WAF/IDS).

- **Arquitetura modular**: cada fonte de dados é um módulo independente em
  `deeprecon/modules/`, facilitando adicionar novas integrações.

---

## 🗂️ Estrutura do projeto

```
deeprecon/
├── deeprecon/
│   ├── __init__.py
│   ├── __main__.py
│   ├── cli.py              # interface de linha de comando
│   ├── utils.py             # sessão HTTP, Tor, logging
│   └── modules/
│       ├── dorks.py         # Google Hacking
│       ├── subdomain.py     # crt.sh + DNS
│       ├── whois_lookup.py  # WHOIS
│       ├── darkweb.py       # busca via Tor
│       ├── breach.py        # Have I Been Pwned
│       └── report.py        # geração HTML/JSON
├── tests/                   # testes unitários (pytest)
├── examples/                # exemplos de uso
├── .github/workflows/ci.yml # CI (lint + testes)
├── install.sh
├── pyproject.toml
├── requirements.txt
├── SECURITY.md
├── CONTRIBUTING.md
└── LICENSE (MIT)
```

---

## 🛣️ Roadmap / ideias de expansão

- [ ] Integração com Shodan/Censys (requer API key)
- [ ] Módulo baseado em `theHarvester` (coleta de e-mails/funcionários)
- [ ] Detecção de buckets S3/Azure Blob expostos
- [ ] Suporte a rotação de exit nodes Tor
- [ ] Exportação compatível com Maltego (CSV/graph)

Contribuições são bem-vindas! Veja [CONTRIBUTING.md](CONTRIBUTING.md).

---

## 🤝 Contribuindo

1. Fork o repositório
2. Crie uma branch (`git checkout -b feature/minha-feature`)
3. Commit suas mudanças (`git commit -m 'Adiciona minha feature'`)
4. Push para a branch (`git push origin feature/minha-feature`)
5. Abra um Pull Request

---

## 📄 Licença

Distribuído sob a licença MIT. Veja [LICENSE](LICENSE) para mais detalhes.

---

## 👤 Autor

**Rodrigo Pereira Carvalho** — profissional de AppSec/DevSecOps.

Se este projeto te ajudou na fase de recon, considere deixar uma ⭐ no repositório!

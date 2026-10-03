# Política de Segurança e Uso Responsável

## ⚠️ Uso autorizado apenas

O DeepRecon é uma ferramenta de **reconhecimento ofensivo** (OSINT) destinada
exclusivamente a:

- Testes de intrusão (pentest) com **autorização explícita e por escrito** do
  proprietário do ativo;
- Programas de **bug bounty** dentro do escopo definido pela organização;
- Pesquisa em **ativos próprios**.

O uso desta ferramenta contra sistemas de terceiros sem autorização pode
constituir crime em diversas jurisdições (ex.: Lei 12.737/2012 e
Lei 13.709/2018 - LGPD, no Brasil; Computer Fraud and Abuse Act, nos EUA;
Computer Misuse Act, no Reino Unido, entre outras). Os mantenedores deste
projeto não se responsabilizam por uso indevido.

## Reportando vulnerabilidades na ferramenta em si

Se você encontrar uma vulnerabilidade de segurança **no código do
DeepRecon** (não no alvo que você está testando), por favor:

1. **Não abra uma issue pública** com detalhes de exploração.
2. Envie um e-mail para o mantenedor do projeto com os detalhes.
3. Aguarde confirmação antes de divulgar publicamente (divulgação
   responsável).

## Boas práticas ao usar a ferramenta

- Sempre tenha um documento de autorização (contrato, termo de escopo) antes
  de rodar qualquer módulo contra um alvo.
- Prefira a Google Custom Search API ao invés do scraping direto do Google
  quando for usar em produção/alta frequência.
- Mantenha o Tor atualizado se for usar o módulo `darkweb`.

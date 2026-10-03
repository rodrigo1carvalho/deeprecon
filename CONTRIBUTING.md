# Contribuindo com o DeepRecon

Contribuições são muito bem-vindas! Este projeto é mantido pela comunidade de
segurança ofensiva e OSINT.

## Como contribuir

1. Faça um fork do repositório
2. Crie uma branch para sua feature/correção:
   ```bash
   git checkout -b feature/nome-da-feature
   ```
3. Siga o estilo de código já existente (PEP8, type hints quando possível)
4. Adicione/atualize testes em `tests/` se aplicável
5. Rode os testes localmente:
   ```bash
   python -m pytest tests/
   ```
6. Abra um Pull Request descrevendo:
   - O que foi alterado e por quê
   - Como testar a mudança
   - Se adiciona dependência nova, justifique

## Ideias de contribuição (ver também o README)

- Integração com Shodan/Censys
- Módulo baseado em theHarvester (coleta de e-mails/funcionários)
- Detecção de buckets S3/Azure Blob expostos
- Mais motores de busca .onion em `deeprecon/modules/darkweb.py`
- Exportação de relatório em formato compatível com Maltego (CSV/graph)
- Suporte a rotação de proxies/exit nodes Tor

## Código de conduta

Seja respeitoso. Este projeto existe para apoiar pesquisa de segurança
**ética e autorizada** — PRs que adicionem funcionalidades claramente
voltadas a abuso (ex.: automação de ataques não autorizados) serão
rejeitados.

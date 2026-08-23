# Mindi Printer — prévia visual

App de teste só com as **telas novas** do Mindi Printer (nada conecta em servidor de verdade).

## Como usar

1. Crie um repositório novo no GitHub (ex.: `printer-preview`)
2. Suba **todos** os arquivos deste zip (com as pastas `app_src` e `.github`)
3. O build começa sozinho — acompanhe em **Actions → Gerar APK de teste**
4. Quando terminar, abra a execução e baixe o **mindi-printer-teste-apk** em *Artifacts*
5. Instale o APK no Android e navegue pelas telas

## O que tem na prévia

- Tela de primeira abertura (Como conectar + API Key com botão Colar)
- Aba **Início**: toggle Online/Offline no header, card do servidor com
  Revalidar + Ver detalhes (bottom sheet), radar "Aguardando pedidos" e
  pedidos de exemplo no modo offline
- Aba **Impressoras**: busca na rede, cards das impressoras, tela de
  edição com os 4 tipos de conexão e a lixeira no header
- Aba **Ajustes**: API Key (alterar em bottom sheet), Erros locais
  (lista, menu ⋯ e detalhe) e o card de versão
- "Deseja sair?" no botão voltar do Android

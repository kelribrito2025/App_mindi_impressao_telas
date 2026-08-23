import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'tema.dart';
import 'icones.dart';

/* ================================================================== *
 *  ABA AJUSTES — API Key, erros locais e versão do app
 * ================================================================== */

class ErroLocal {
  final String titulo;
  final bool grave; // true = ERROR, false = WARNING
  final String hora;
  const ErroLocal(this.titulo, this.grave, this.hora);
}

const _erros = [
  ErroLocal('GET https://app.mindi.com.br/api/printer/status', false, '23:58'),
  ErroLocal('Erro ao registrar dispositivo USB', true, '23:58'),
  ErroLocal('Falha ao sincronizar impressoras', false, '23:58'),
  ErroLocal('POST https://app.mindi.com.br/api/printer/ack', false, '23:58'),
  ErroLocal('Erro ao buscar recibo HTML', true, '23:57'),
];

class TelaAjustes extends StatefulWidget {
  const TelaAjustes({super.key});

  @override
  State<TelaAjustes> createState() => _TelaAjustesState();
}

class _TelaAjustesState extends State<TelaAjustes> {
  void _alterarChave() {
    final campo = TextEditingController();
    abrirSheet(
      context,
      StatefulBuilder(
        builder: (ctx, setSheet) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                QuadIcone(icone: Ico.chave, fundo: T.roxoSuave, cor: T.roxo),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Alterar API Key',
                          style: TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w800,
                              color: T.ink)),
                      const SizedBox(height: 1),
                      Text('A chave conecta o app ao seu estabelecimento',
                          style:
                              TextStyle(fontSize: 11.5, color: T.inkSoft)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _rotulo('Chave atual'),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
              decoration: BoxDecoration(
                color: T.campo,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: T.borda),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text('pk_72xw•••••••••••cg8g',
                        style:
                            TextStyle(fontSize: 13.5, color: T.inkSoft)),
                  ),
                  Icon(Ico.copiar, size: 15, color: T.fraco),
                ],
              ),
            ),
            _rotulo('Nova chave'),
            Container(
              padding: const EdgeInsets.fromLTRB(13, 4, 6, 4),
              decoration: BoxDecoration(
                color: T.campo,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: T.borda),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: campo,
                      style: TextStyle(fontSize: 13.5, color: T.ink),
                      decoration: InputDecoration(
                        hintText: 'pk_xxxxxxxxxxxx',
                        hintStyle: TextStyle(color: T.fraco),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () async {
                      final dado =
                          await Clipboard.getData(Clipboard.kTextPlain);
                      campo.text = dado?.text?.trim() ?? '';
                      setSheet(() {});
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 11, vertical: 8),
                      decoration: BoxDecoration(
                        color: T.redSuave,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: T.redBorda),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Ico.colar, size: 14, color: T.redDark),
                          const SizedBox(width: 5),
                          Text('Colar',
                              style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w800,
                                  color: T.redDark)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 50,
              child: FilledButton(
                onPressed: () => Navigator.pop(ctx),
                style: FilledButton.styleFrom(
                  backgroundColor: T.redDark,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Salvar',
                    style: TextStyle(
                        fontSize: 14.5, fontWeight: FontWeight.w800)),
              ),
            ),
            SizedBox(
              height: 48,
              child: TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text('Cancelar',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: T.inkMedio)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rotulo(String texto) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 12, 2, 6),
      child: Text(texto,
          style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: T.inkSoft)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const HeaderVermelho(
          child: Row(
            children: [
              SizedBox(width: 40),
              Expanded(
                child: Text('Ajustes',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -.3)),
              ),
              SizedBox(width: 40),
            ],
          ),
        ),
        Expanded(
          child: Transform.translate(
            offset: const Offset(0, -44),
            child: Container(
              decoration: BoxDecoration(
                color: T.bg,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: const EdgeInsets.fromLTRB(kSide, 18, kSide, 0),
              child: ListView(
                padding: EdgeInsets.only(
                    bottom:
                        120 + MediaQuery.viewPaddingOf(context).bottom),
                children: [
                  const TituloSecao('Conexão'),
                  AfundaAoTocar(
                    escala: .98,
                    onTap: _alterarChave,
                    child: CardBranco(
                      child: LinhaCard(
                        icone: Ico.chave,
                        fundo: T.roxoSuave,
                        cor: T.roxo,
                        titulo: 'API Key',
                        sub: 'Configurada · toque para alterar',
                        direita: Badge2(
                            texto: 'CONFIGURADA',
                            fundo: T.greenSuave,
                            borda: T.greenBorda,
                            cor: T.greenEscuro),
                      ),
                    ),
                  ),

                  const TituloSecao('Diagnóstico'),
                  AfundaAoTocar(
                    escala: .98,
                    onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const TelaErros())),
                    child: CardBranco(
                      child: LinhaCard(
                        icone: Ico.alerta,
                        fundo: T.amareloSuave,
                        cor: T.amarelo,
                        titulo: 'Erros locais',
                        sub: 'Registros de falhas do app',
                        direita: Badge2(
                            texto: '${_erros.length * 8 - 2}',
                            fundo: T.campo,
                            borda: T.borda,
                            cor: T.inkMedio),
                      ),
                    ),
                  ),

                  const TituloSecao('Sobre o app'),
                  CardBranco(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        LinhaCard(
                          icone: Ico.pacote,
                          fundo: T.campo2,
                          cor: T.inkMedio,
                          titulo: 'Versão do app',
                          sub: 'Atualizações via Shorebird',
                        ),
                        const SizedBox(height: 10),
                        _linhaKv('Versão', '1.4.0+14'),
                        _linhaKv('Correção atual', '—'),
                        _linhaKv('Última verificação', 'há 2 min',
                            ultima: true),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 40,
                          child: OutlinedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: const Text(
                                    'Você já está na versão mais recente'),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: T.dark2,
                              ));
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: T.borda),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(14)),
                            ),
                            child: Text('Verificar atualização',
                                style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w800,
                                    color: T.inkMedio)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _linhaKv(String k, String v, {bool ultima = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7),
      decoration: BoxDecoration(
        border:
            ultima ? null : Border(bottom: BorderSide(color: T.line)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(k,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: T.inkSoft)),
          Text(v,
              style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w700, color: T.ink)),
        ],
      ),
    );
  }
}

/* ================================================================== *
 *  ERROS LOCAIS — lista + menu ⋯ + detalhe
 * ================================================================== */
class TelaErros extends StatelessWidget {
  const TelaErros({super.key});

  void _abrirMenu(BuildContext context) {
    abrirSheet(
      context,
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _opcao(context, Ico.atualizar, T.campo, T.inkMedio, 'Atualizar',
              'Recarrega a lista de erros'),
          _opcao(context, Ico.copiar, T.azulSuave, T.azul, 'Exportar todos',
              'Copia todos os erros para enviar'),
          _opcao(context, Ico.lixeira, T.redSuave, T.redDark, 'Limpar todos',
              'Apaga todos os registros',
              vermelho: true),
        ],
      ),
    );
  }

  Widget _opcao(BuildContext context, IconData icone, Color fundo, Color cor,
      String titulo, String sub,
      {bool vermelho = false}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.pop(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            QuadIcone(icone: icone, fundo: fundo, cor: cor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titulo,
                      style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: vermelho ? T.redDark : T.ink)),
                  const SizedBox(height: 1),
                  Text(sub,
                      style: TextStyle(fontSize: 11.5, color: T.inkSoft)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TelaInterna(
      titulo: 'Erros locais (38)',
      acao: Builder(
        builder: (ctx) =>
            BotaoDoHeader(icone: Ico.maisOpcoes, aoTocar: () => _abrirMenu(ctx)),
      ),
      child: Column(
        children: [
          for (final e in _erros)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AfundaAoTocar(
                escala: .98,
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => TelaDetalheErro(erro: e))),
                child: CardBranco(
                  child: Row(
                    children: [
                      QuadIcone(
                        icone: e.grave ? Ico.erro : Ico.alerta,
                        fundo: e.grave ? T.redSuave : T.amareloSuave,
                        cor: e.grave ? T.redDark : T.amarelo,
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e.titulo,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: T.ink)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Badge2(
                                  texto: e.grave ? 'ERROR' : 'WARNING',
                                  fundo:
                                      e.grave ? T.redSuave : T.amareloSuave,
                                  borda:
                                      e.grave ? T.redBorda : T.amareloBorda,
                                  cor: e.grave ? T.redDark : T.amarelo,
                                ),
                                const SizedBox(width: 6),
                                Text(e.hora,
                                    style: TextStyle(
                                        fontSize: 11.5, color: T.inkSoft)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      _BotaoMini(icone: Ico.copiar, aoTocar: () {}),
                      const SizedBox(width: 6),
                      _BotaoMini(
                          icone: Ico.lixeira, vermelho: true, aoTocar: () {}),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BotaoMini extends StatelessWidget {
  final IconData icone;
  final bool vermelho;
  final VoidCallback aoTocar;
  const _BotaoMini(
      {required this.icone, this.vermelho = false, required this.aoTocar});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: aoTocar,
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: vermelho ? T.redSuave : T.campo,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: vermelho ? T.redBorda : T.borda),
        ),
        child: Icon(icone,
            size: 14, color: vermelho ? T.redDark : T.inkMedio),
      ),
    );
  }
}

/* ---------- detalhe do erro ---------- */
class TelaDetalheErro extends StatelessWidget {
  final ErroLocal erro;
  const TelaDetalheErro({super.key, required this.erro});

  @override
  Widget build(BuildContext context) {
    return TelaInterna(
      titulo: 'Detalhe do erro',
      acao: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          BotaoDoHeader(icone: Ico.copiar, aoTocar: () {}),
          const SizedBox(width: 8),
          BotaoDoHeader(
              icone: Ico.lixeira,
              aoTocar: () => Navigator.of(context).maybePop()),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CardBranco(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Badge2(
                  texto: erro.grave ? 'ERROR' : 'WARNING',
                  fundo: erro.grave ? T.redSuave : T.amareloSuave,
                  borda: erro.grave ? T.redBorda : T.amareloBorda,
                  cor: erro.grave ? T.redDark : T.amarelo,
                ),
                const SizedBox(height: 10),
                Text('${erro.titulo} → HTTP 401',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: T.ink,
                        height: 1.5)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          CardBranco(
            child: Column(
              children: [
                _kv('Severidade', erro.grave ? 'error' : 'warning'),
                _kv('Tipo', 'HttpError'),
                _kv('Tratado', 'sim'),
                _kv('Versão', '1.4.0'),
                _kv('Quando', '22/07 · ${erro.hora}'),
                _kv('Fingerprint', '31d759f740d8a8b1…', ultima: true),
              ],
            ),
          ),
          const TituloSecao('Tags'),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _tag('app_name: Mindi Printer'),
              _tag('http_method: GET'),
              _tag('http_status: 401'),
              _tag('http_url: https://app.mindi.com.br/…'),
            ],
          ),
          const TituloSecao('Extra'),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: T.campo,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: T.borda),
            ),
            child: Text(
              'duration_ms: 466\n'
              'request_headers: {"Authorization":"***"}\n'
              'request_body: null\n'
              'response_headers: {"ratelimit-limit":"200",'
              '"server":"cloudflare","date":"Thu, 23 Jul 2026…',
              style: TextStyle(
                  fontSize: 10,
                  height: 1.55,
                  color: T.inkMedio,
                  fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _kv(String k, String v, {bool ultima = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7),
      decoration: BoxDecoration(
        border:
            ultima ? null : Border(bottom: BorderSide(color: T.line)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(k,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: T.inkSoft)),
          Flexible(
            child: Text(v,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: T.ink)),
          ),
        ],
      ),
    );
  }

  Widget _tag(String texto) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: T.campo,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: T.borda),
      ),
      child: Text(texto,
          style: TextStyle(
              fontSize: 10, fontWeight: FontWeight.w700, color: T.inkMedio)),
    );
  }
}

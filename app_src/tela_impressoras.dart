import 'package:flutter/material.dart';
import 'tema.dart';
import 'icones.dart';

/* ================================================================== *
 *  ABA IMPRESSORAS — busca na rede + lista + edição
 * ================================================================== */

/// impressora de exemplo (a prévia guarda só em memória)
class Impressora {
  String apelido;
  String conexao; // 'rede' | 'windows' | 'macos' | 'android'
  String detalhe;
  bool ativa;
  Impressora(this.apelido, this.conexao, this.detalhe, this.ativa);
}

const kConexoes = {
  'rede': ('Rede (TCP/IP)', 'Impressora no Wi-Fi ou cabo de rede', Ico.wifi),
  'windows': ('USB Windows (Spooler)', 'Ligada em um computador Windows',
      Ico.computador),
  'macos': ('USB macOS (CUPS)', 'Ligada em um Mac', Ico.notebook),
  'android': ('USB Android (Serial)', 'Ligada direto no celular via cabo OTG',
      Ico.celular),
};

final _impressoras = <Impressora>[
  Impressora('Cozinha', 'android', 'USB Android (Serial)', true),
  Impressora('Balcão', 'rede', 'Rede · 192.168.0.45', false),
];

class TelaImpressoras extends StatefulWidget {
  const TelaImpressoras({super.key});

  @override
  State<TelaImpressoras> createState() => _TelaImpressorasState();
}

class _TelaImpressorasState extends State<TelaImpressoras> {
  bool _buscando = false;

  Future<void> _buscar() async {
    setState(() => _buscando = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _buscando = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Nenhuma impressora nova encontrada'),
      behavior: SnackBarBehavior.floating,
      backgroundColor: T.dark2,
    ));
  }

  void _abrirEdicao([Impressora? imp]) {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (_) => TelaEditarImpressora(impressora: imp)))
        .then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    // padrão admin: página inteira rola e o card da busca
    // flutua por cima do header vermelho
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(
          bottom: 130 + MediaQuery.of(context).padding.bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HeaderVermelho(
            // mesma altura do header da aba Inicio
            child: SizedBox(
              height: 46,
              child: Row(
                children: [
                  const SizedBox(width: 40),
                  const Expanded(
                    child: Text('Impressoras',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -.3)),
                  ),
                  BotaoDoHeader(
                      icone: Ico.mais, aoTocar: () => _abrirEdicao()),
                ],
              ),
            ),
          ),
          // o card da busca flutua sobre o header (padrão admin)
          Transform.translate(
            offset: const Offset(0, -44),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kSide),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ---- busca na rede ----
                  CardBranco(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        LinhaCard(
                          icone: Ico.busca,
                          fundo: T.azulSuave,
                          cor: T.azul,
                          titulo: 'Busca na rede',
                          sub: 'Procura impressoras na porta 9100',
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 13, vertical: 11),
                                decoration: BoxDecoration(
                                  color: T.campo,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: T.borda),
                                ),
                                child: Text('9100',
                                    style: TextStyle(
                                        fontSize: 13.5, color: T.ink)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 92,
                              height: 42,
                              child: FilledButton(
                                onPressed: _buscando ? null : _buscar,
                                style: FilledButton.styleFrom(
                                  backgroundColor: T.redDark,
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(14)),
                                ),
                                child: _buscando
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2.2,
                                            color: Colors.white))
                                    : const Text('Buscar',
                                        style: TextStyle(
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.w800)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const TituloSecao('Minhas impressoras'),

                  for (final imp in _impressoras)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AfundaAoTocar(
                        escala: .98,
                        onTap: () => _abrirEdicao(imp),
                        child: CardBranco(
                          child: LinhaCard(
                            icone: Ico.impressora,
                            fundo: imp.ativa ? T.greenSuave : T.campo2,
                            cor: imp.ativa ? T.greenEscuro : T.inkMedio,
                            titulo: imp.apelido,
                            sub: imp.detalhe,
                            direita: ToggleMindi(
                              ligado: imp.ativa,
                              aoMudar: (v) =>
                                  setState(() => imp.ativa = v),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ================================================================== *
 *  EDITAR / NOVA IMPRESSORA — título no header + lixeira
 * ================================================================== */
class TelaEditarImpressora extends StatefulWidget {
  final Impressora? impressora;
  const TelaEditarImpressora({super.key, this.impressora});

  @override
  State<TelaEditarImpressora> createState() => _TelaEditarImpressoraState();
}

class _TelaEditarImpressoraState extends State<TelaEditarImpressora> {
  late final _apelido =
      TextEditingController(text: widget.impressora?.apelido ?? '');
  late String _conexao = widget.impressora?.conexao ?? 'android';
  bool _listando = false;
  String? _resultadoLista;

  bool get _editando => widget.impressora != null;

  @override
  void dispose() {
    _apelido.dispose();
    super.dispose();
  }

  void _escolherConexao() {
    abrirSheet(
      context,
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Tipo de conexão',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w800,
                  color: T.ink)),
          const SizedBox(height: 12),
          for (final e in kConexoes.entries)
            _OpcaoConexao(
              titulo: e.value.$1,
              sub: e.value.$2,
              icone: e.value.$3,
              selecionada: _conexao == e.key,
              aoTocar: () {
                Navigator.pop(context);
                setState(() {
                  _conexao = e.key;
                  _resultadoLista = null;
                });
              },
            ),
        ],
      ),
    );
  }

  Future<void> _listar() async {
    setState(() {
      _listando = true;
      _resultadoLista = null;
    });
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() {
      _listando = false;
      _resultadoLista = switch (_conexao) {
        'windows' =>
          'Nenhuma impressora encontrada. Certifique-se de que há impressoras instaladas no Windows.',
        'macos' =>
          'Nenhuma impressora encontrada no CUPS. Conecte a impressora USB e adicione-a em System Settings → Printers & Scanners.',
        _ => 'Nenhum dispositivo USB encontrado.',
      };
    });
  }

  void _confirmarExclusao() {
    abrirSheet(
      context,
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Excluir impressora?',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: T.ink)),
          const SizedBox(height: 6),
          Text('“${_apelido.text}” será removida do app.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: T.inkSoft)),
          const SizedBox(height: 16),
          SizedBox(
            height: 52,
            child: FilledButton(
              onPressed: () {
                _impressoras.remove(widget.impressora);
                Navigator.pop(context); // fecha o sheet
                Navigator.pop(context); // volta pra lista
              },
              style: FilledButton.styleFrom(
                backgroundColor: T.redDark,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Sim, excluir',
                  style: TextStyle(
                      fontSize: 15.5, fontWeight: FontWeight.w800)),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 48,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: T.inkMedio)),
            ),
          ),
        ],
      ),
    );
  }

  void _salvar() {
    final nome =
        _apelido.text.trim().isEmpty ? 'Impressora' : _apelido.text.trim();
    if (_editando) {
      widget.impressora!.apelido = nome;
      widget.impressora!.conexao = _conexao;
      widget.impressora!.detalhe = kConexoes[_conexao]!.$1;
    } else {
      _impressoras
          .add(Impressora(nome, _conexao, kConexoes[_conexao]!.$1, true));
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return TelaInterna(
      titulo: _editando ? 'Editar impressora' : 'Nova impressora',
      acao: _editando
          ? BotaoDoHeader(icone: Ico.lixeira, aoTocar: _confirmarExclusao)
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _rotulo('Apelido'),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            decoration: BoxDecoration(
              color: T.campo,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: T.borda),
            ),
            child: TextField(
              controller: _apelido,
              style: TextStyle(fontSize: 13.5, color: T.ink),
              decoration: InputDecoration(
                hintText: 'Ex.: Cozinha',
                hintStyle: TextStyle(color: T.fraco),
                border: InputBorder.none,
              ),
            ),
          ),

          _rotulo('Conexão'),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _escolherConexao,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 13, vertical: 12),
              decoration: BoxDecoration(
                color: T.campo,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: T.borda),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(kConexoes[_conexao]!.$1,
                        style: TextStyle(fontSize: 13.5, color: T.ink)),
                  ),
                  Icon(Ico.abaixo, size: 16, color: T.fraco),
                ],
              ),
            ),
          ),

          // ---- área que muda conforme o tipo de conexão ----
          if (_conexao == 'rede') ...[
            _rotulo('Endereço IP'),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 13, vertical: 12),
              decoration: BoxDecoration(
                color: T.campo,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: T.borda),
              ),
              child: Text('192.168.0.45',
                  style: TextStyle(fontSize: 13.5, color: T.ink)),
            ),
          ] else ...[
            _rotulo(_conexao == 'android'
                ? 'Dispositivo USB'
                : 'Impressoras do computador'),
            AfundaAoTocar(
              escala: .98,
              onTap: _listando ? null : _listar,
              child: CardBranco(
                child: LinhaCard(
                  icone: Ico.usb,
                  fundo: T.amareloSuave,
                  cor: T.amarelo,
                  titulo: _listando ? 'Procurando…' : 'Nenhum dispositivo',
                  sub: _conexao == 'android'
                      ? 'Toque para listar os dispositivos USB'
                      : (_conexao == 'macos'
                          ? 'Toque para listar as impressoras CUPS'
                          : 'Toque para listar as impressoras'),
                  direita: _listando
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              strokeWidth: 2.2, color: T.redDark))
                      : Icon(Ico.avancar, size: 16, color: T.fraco),
                ),
              ),
            ),
            if (_resultadoLista != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(_resultadoLista!,
                    style: TextStyle(
                        fontSize: 11.5, color: T.inkSoft, height: 1.4)),
              ),
            if (_conexao == 'android')
              Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: T.amareloSuave,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: T.amareloBorda),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Ico.dica, size: 15, color: T.amarelo),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                          'Conecte a impressora ao celular com um cabo OTG antes de listar.',
                          style: TextStyle(
                              fontSize: 11,
                              color: T.inkMedio,
                              height: 1.4)),
                    ),
                  ],
                ),
              ),
          ],

          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            const Text('Página de teste enviada (prévia)'),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: T.dark2,
                      ));
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: T.borda),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text('Imprimir teste',
                        style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800,
                            color: T.inkMedio)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: FilledButton(
                    onPressed: _salvar,
                    style: FilledButton.styleFrom(
                      backgroundColor: T.redDark,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Salvar',
                        style: TextStyle(
                            fontSize: 13.5, fontWeight: FontWeight.w800)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _rotulo(String texto) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 14, 2, 6),
      child: Text(texto,
          style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: T.inkSoft)),
    );
  }
}

class _OpcaoConexao extends StatelessWidget {
  final String titulo;
  final String sub;
  final IconData icone;
  final bool selecionada;
  final VoidCallback aoTocar;
  const _OpcaoConexao(
      {required this.titulo,
      required this.sub,
      required this.icone,
      required this.selecionada,
      required this.aoTocar});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: aoTocar,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selecionada ? T.redSuave : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: selecionada ? T.redBorda : Colors.transparent,
              width: 1.4),
        ),
        child: Row(
          children: [
            QuadIcone(
              icone: icone,
              fundo: selecionada ? T.redDark : T.campo,
              cor: selecionada ? Colors.white : T.inkMedio,
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titulo,
                      style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: selecionada ? T.redDark : T.ink)),
                  const SizedBox(height: 1),
                  Text(sub,
                      style:
                          TextStyle(fontSize: 11.5, color: T.inkSoft)),
                ],
              ),
            ),
            if (selecionada)
              Icon(Ico.check, size: 18, color: T.redDark),
          ],
        ),
      ),
    );
  }
}

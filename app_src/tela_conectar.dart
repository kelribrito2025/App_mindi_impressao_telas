import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'tema.dart';
import 'icones.dart';
import 'estado.dart';
import 'app_shell.dart';

/* ================================================================== *
 *  PRIMEIRA ABERTURA — como conectar + campo da API Key
 * ================================================================== */
class TelaConectar extends StatefulWidget {
  const TelaConectar({super.key});

  @override
  State<TelaConectar> createState() => _TelaConectarState();
}

class _TelaConectarState extends State<TelaConectar> {
  final _campo = TextEditingController();
  bool _salvando = false;

  @override
  void dispose() {
    _campo.dispose();
    super.dispose();
  }

  Future<void> _colar() async {
    final dado = await Clipboard.getData(Clipboard.kTextPlain);
    final texto = dado?.text?.trim() ?? '';
    if (texto.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Nada copiado para colar'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: T.dark2,
      ));
      return;
    }
    _campo.text = texto;
    setState(() {});
  }

  Future<void> _conectar() async {
    final chave = _campo.text.trim();
    if (chave.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Cole a API Key primeiro'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: T.dark2,
      ));
      return;
    }
    setState(() => _salvando = true);
    // na prévia só guarda no celular (o app real valida no servidor)
    await Future.delayed(const Duration(milliseconds: 600));
    await salvarChave(chave);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AppShell()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: T.bg,
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          // header vermelho grande com a identidade do app
          Container(
            width: double.infinity,
            decoration: BoxDecoration(gradient: kGradRed),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 26, 20, 64),
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(.18),
                        border: Border.all(
                            color: Colors.white.withOpacity(.5), width: 2),
                      ),
                      child: const Icon(Ico.impressora,
                          size: 28, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    const Text('Mindi Printer',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white)),
                    const SizedBox(height: 3),
                    Text('Impressão automática de pedidos',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(.85))),
                  ],
                ),
              ),
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
                padding: EdgeInsets.fromLTRB(kSide, 22, kSide,
                    26 + MediaQuery.viewPaddingOf(context).bottom),
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CardBranco(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LinhaCard(
                              icone: Ico.chave,
                              fundo: T.roxoSuave,
                              cor: T.roxo,
                              titulo: 'Como conectar',
                              sub: 'Gere sua API Key no painel Mindi',
                            ),
                            const SizedBox(height: 12),
                            _passo(1, 'Acesse ', 'app.mindi.com.br', ''),
                            _passo(2, 'Vá em ', 'Configurações', ''),
                            _passo(3, 'Toque em ',
                                'Impressora → Impressão automática', ''),
                            _passo(4, 'Toque em ', 'Gerar API Key',
                                ', copie e insira abaixo'),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2, 14, 2, 6),
                        child: Text('API Key',
                            style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: T.inkSoft)),
                      ),
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
                                controller: _campo,
                                style: TextStyle(
                                    fontSize: 13.5, color: T.ink),
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
                              onTap: _colar,
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
                                    Icon(Ico.colar,
                                        size: 14, color: T.redDark),
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
                      const SizedBox(height: 14),
                      SizedBox(
                        height: 50,
                        child: FilledButton(
                          onPressed: _salvando ? null : _conectar,
                          style: FilledButton.styleFrom(
                            backgroundColor: T.redDark,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                          ),
                          child: _salvando
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2.4,
                                      color: Colors.white))
                              : const Text('Conectar',
                                  style: TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w800)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _passo(int n, String antes, String forte, String depois) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            alignment: Alignment.center,
            decoration:
                BoxDecoration(color: T.redDark, shape: BoxShape.circle),
            child: Text('$n',
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Colors.white)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text.rich(
                TextSpan(
                  style: TextStyle(
                      fontSize: 12.5, color: T.inkMedio, height: 1.4),
                  children: [
                    TextSpan(text: antes),
                    TextSpan(
                        text: forte,
                        style:
                            const TextStyle(fontWeight: FontWeight.w800)),
                    TextSpan(text: depois),
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

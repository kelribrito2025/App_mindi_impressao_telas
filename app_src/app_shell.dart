import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'tema.dart';
import 'estado.dart';
import 'tab_bar_curva.dart';
import 'tela_inicio.dart';
import 'tela_impressoras.dart';
import 'tela_ajustes.dart';

/* ================================================================== *
 *  CASCA DO APP — as 3 abas de baixo
 * ================================================================== */
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final List<Widget> _telas = const [
    TelaInicio(),
    TelaImpressoras(),
    TelaAjustes(),
  ];

  /// o voltar do Android na raiz das abas: pergunta antes de sair.
  Future<void> _confirmarSaida() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: T.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                      color: T.borda,
                      borderRadius: BorderRadius.circular(999)),
                ),
              ),
              Text('Deseja sair?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: T.ink)),
              const SizedBox(height: 6),
              Text('O app vai fechar. Você continua conectado.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: T.inkSoft)),
              const SizedBox(height: 16),
              SizedBox(
                height: 52,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    SystemNavigator.pop();
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: T.redDark,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Sim, sair',
                      style: TextStyle(
                          fontSize: 15.5, fontWeight: FontWeight.w800)),
                ),
              ),
              const SizedBox(height: 10),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final margemInferior = MediaQuery.of(context).padding.bottom;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (jaSaiu, _) {
        if (jaSaiu) return;
        _confirmarSaida();
      },
      child: Scaffold(
        backgroundColor: T.bg,
        body: Stack(
          children: [
            ValueListenableBuilder<int>(
              valueListenable: abaSelecionada,
              builder: (_, aba, __) =>
                  IndexedStack(index: aba, children: _telas),
            ),
            Positioned(
              left: kSide,
              right: kSide,
              bottom: margemInferior + 8,
              child: ValueListenableBuilder<int>(
                valueListenable: abaSelecionada,
                builder: (_, aba, __) => TabBarCurva(
                  indice: aba,
                  aoTrocar: (i) => abaSelecionada.value = i,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

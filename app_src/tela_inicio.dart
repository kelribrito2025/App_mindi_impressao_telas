import 'package:flutter/material.dart';
import 'tema.dart';
import 'icones.dart';
import 'estado.dart';

/* ================================================================== *
 *  ABA INÍCIO — toggle Online/Offline no header + servidor + pedidos
 * ================================================================== */
class TelaInicio extends StatefulWidget {
  const TelaInicio({super.key});

  @override
  State<TelaInicio> createState() => _TelaInicioState();
}

class _TelaInicioState extends State<TelaInicio> {
  bool _revalidando = false;

  // pedidos de exemplo (a prévia não conecta em nada)
  final _pedidos = const [
    ('Pedido #1042', 'há 6 min · Cozinha', true),
    ('Pedido #1041', 'há 18 min · Cozinha', true),
    ('Pedido #1040', 'há 31 min · Cozinha', false),
  ];

  Future<void> _revalidar() async {
    setState(() => _revalidando = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _revalidando = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Servidor OK · 307 ms'),
      behavior: SnackBarBehavior.floating,
      backgroundColor: T.dark2,
    ));
  }

  void _verDetalhes() {
    abrirSheet(
      context,
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              QuadIcone(
                  icone: Ico.wifi, fundo: T.greenSuave, cor: T.greenEscuro),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Status do servidor',
                        style: TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w800,
                            color: T.ink)),
                    const SizedBox(height: 1),
                    Text('Tuchê Restaurante · #210019',
                        style:
                            TextStyle(fontSize: 11.5, color: T.inkSoft)),
                  ],
                ),
              ),
              Badge2(
                  texto: 'ONLINE',
                  fundo: T.greenSuave,
                  borda: T.greenBorda,
                  cor: T.greenEscuro),
            ],
          ),
          const SizedBox(height: 10),
          _linha('HTTP', '200'),
          _linha('Latência', '307 ms'),
          _linha('Sincronização', 'OK'),
          _linha('Impressoras', '1'),
          _linha('Último pedido (ID)', '1560001'),
          _linha('Heartbeat', '12:39:06'),
          _linha('Conexões', '3', ultima: true),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: const [
              _Chip('Auto print: NÃO'),
              _Chip('Novo pedido: NÃO'),
              _Chip('HTML: SIM'),
              _Chip('Beep: NÃO'),
              _Chip('Papel: 80mm'),
            ],
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 48,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Fechar',
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

  Widget _linha(String k, String v, {bool ultima = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: ultima
            ? null
            : Border(bottom: BorderSide(color: T.line)),
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

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: servidorOnline,
      builder: (context, online, _) {
        return Column(
          children: [
            HeaderVermelho(
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(.18),
                      border: Border.all(
                          color: Colors.white.withOpacity(.45), width: 1.5),
                    ),
                    child: const Text('DA',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Bem-vindo,',
                            style: TextStyle(
                                fontSize: 12.5,
                                color: Colors.white.withOpacity(.78))),
                        const Text('Daniel',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  // toggle Online/Offline no header
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => servidorOnline.value = !online,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(12, 6, 10, 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.16),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                            color: Colors.white.withOpacity(.45),
                            width: 1.4),
                      ),
                      child: Row(
                        children: [
                          Text(online ? 'Online' : 'Offline',
                              style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: .2)),
                          const SizedBox(width: 7),
                          ToggleMindi(
                            ligado: online,
                            corDesligado: Colors.white.withOpacity(.35),
                            aoMudar: (v) => servidorOnline.value = v,
                          ),
                        ],
                      ),
                    ),
                  ),
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
                  padding:
                      const EdgeInsets.fromLTRB(kSide, 18, kSide, 0),
                  child: ListView(
                    padding: EdgeInsets.only(
                        bottom: 120 +
                            MediaQuery.viewPaddingOf(context).bottom),
                    children: [
                      // ---- card do servidor ----
                      CardBranco(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            online
                                ? LinhaCard(
                                    icone: Ico.wifi,
                                    fundo: T.greenSuave,
                                    cor: T.greenEscuro,
                                    titulo: 'Servidor conectado',
                                    sub:
                                        'Recebendo pedidos em tempo real',
                                  )
                                : LinhaCard(
                                    icone: Ico.pausa,
                                    fundo: T.redSuave,
                                    cor: T.redDark,
                                    titulo: 'Impressão pausada',
                                    sub:
                                        'Novos pedidos não serão impressos',
                                  ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 38,
                              child: OutlinedButton(
                                onPressed:
                                    _revalidando ? null : _revalidar,
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: T.borda),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(14)),
                                ),
                                child: _revalidando
                                    ? SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2.2,
                                            color: T.redDark))
                                    : Text('Revalidar',
                                        style: TextStyle(
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.w800,
                                            color: T.inkMedio)),
                              ),
                            ),
                            const SizedBox(height: 3),
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: _verDetalhes,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Text('Ver detalhes',
                                        style: TextStyle(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w700,
                                            color: T.inkSoft)),
                                    const SizedBox(width: 4),
                                    Icon(Ico.abaixo,
                                        size: 14, color: T.inkSoft),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Padding(
                        padding: EdgeInsets.zero,
                        child: TituloSecao('Pedidos recentes'),
                      ),

                      if (online)
                        // radar "aguardando pedidos" (igual o entregador)
                        const Padding(
                          padding: EdgeInsets.only(top: 26),
                          child: _RadarPedidos(),
                        )
                      else ...[
                        for (final p in _pedidos)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: CardBranco(
                              child: LinhaCard(
                                icone: Ico.recibo,
                                fundo: T.campo2,
                                cor: T.inkMedio,
                                titulo: p.$1,
                                sub: p.$2,
                                direita: p.$3
                                    ? Badge2(
                                        texto: 'IMPRESSO',
                                        fundo: T.greenSuave,
                                        borda: T.greenBorda,
                                        cor: T.greenEscuro)
                                    : Badge2(
                                        texto: 'FALHOU',
                                        fundo: T.redSuave,
                                        borda: T.redBorda,
                                        cor: T.redDark),
                              ),
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Chip extends StatelessWidget {
  final String texto;
  const _Chip(this.texto);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: T.campo,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: T.borda),
      ),
      child: Text(texto,
          style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: T.inkMedio)),
    );
  }
}

/* ---------- radar com anéis pulsando (mesmo efeito do entregador) ---------- */
class _RadarPedidos extends StatefulWidget {
  const _RadarPedidos();

  @override
  State<_RadarPedidos> createState() => _RadarPedidosState();
}

class _RadarPedidosState extends State<_RadarPedidos>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 120,
          height: 120,
          child: AnimatedBuilder(
            animation: _c,
            builder: (context, _) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  for (var i = 0; i < 3; i++) _anel(i / 3),
                  Container(
                    width: 58,
                    height: 58,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: kGradRed,
                      boxShadow: [
                        BoxShadow(
                          color: T.redDark.withOpacity(.35),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(Ico.recibo,
                        size: 24, color: Colors.white),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 14),
        Text('Aguardando pedidos',
            style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
                color: T.ink)),
        const SizedBox(height: 3),
        Text('Novos pedidos serão impressos aqui',
            style: TextStyle(fontSize: 11.5, color: T.inkSoft)),
      ],
    );
  }

  Widget _anel(double atraso) {
    var t = _c.value - atraso;
    if (t < 0) t += 1;
    final escala = .55 + t * .7;
    final opacidade = (1 - t) * .55;
    return Transform.scale(
      scale: escala,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              color: T.redBorda.withOpacity(opacidade), width: 2),
        ),
      ),
    );
  }
}

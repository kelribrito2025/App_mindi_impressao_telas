import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'icones.dart';
import 'estado.dart';

/* ================================================================== *
 *  TEMA — claro e escuro (mesmo padrão dos outros apps Mindi)
 * ================================================================== */
class T {
  static bool get escuro => modoEscuro.value;
  static Color _c(int claro, int escuroHex) =>
      Color(modoEscuro.value ? escuroHex : claro);

  // ---- superfícies ----
  static Color get bg => _c(0xFFF4F5F7, 0xFF09090B);
  static Color get card => _c(0xFFFFFFFF, 0xFF18181B);
  static Color get campo => _c(0xFFF7F8FA, 0xFF27272A);
  static Color get campo2 => _c(0xFFF1F2F5, 0xFF27272A);
  static Color get borda => _c(0xFFE7E9EE, 0xFF3F3F46);
  static Color get line => _c(0xFFF0F1F4, 0xFF27272A);

  // ---- textos ----
  static Color get ink => _c(0xFF1A1D26, 0xFFFAFAFA);
  static Color get inkMedio => _c(0xFF4A4F5C, 0xFFD4D4D8);
  static Color get rotulo => _c(0xFF6B7180, 0xFFA1A1AA);
  static Color get inkSoft => _c(0xFF8A8F9C, 0xFFA1A1AA);
  static Color get fraco => _c(0xFFB9BCC6, 0xFF52525B);
  static Color get tabOff => _c(0xFFB9BCC6, 0xFF71717A);

  // ---- vermelho da marca ----
  static Color get red => _c(0xFFEC5B57, 0xFFEF4444);
  static Color get redDark => _c(0xFFD8434B, 0xFFDC2626);
  static Color get redSuave => _c(0xFFFDECEC, 0xFF3A1D1F);
  static Color get redBorda => _c(0xFFFAD9D9, 0xFF522427);

  // ---- verde (online / ok) ----
  static Color get green => _c(0xFF16A34A, 0xFF22C55E);
  static Color get greenEscuro => _c(0xFF15803D, 0xFF16A34A);
  static Color get greenSuave => _c(0xFFE8F7EE, 0xFF14301F);
  static Color get greenBorda => _c(0xFFCDEBD8, 0xFF1F5133);

  // ---- amarelo (aviso) ----
  static Color get amarelo => _c(0xFF9A6B0F, 0xFFEAB308);
  static Color get amareloSuave => _c(0xFFFFF6D6, 0xFF3A2E0B);
  static Color get amareloBorda => _c(0xFFF3E2A6, 0xFF5C4A12);

  // ---- outras ----
  static Color get roxo => _c(0xFF7B4FE0, 0xFFA78BFA);
  static Color get roxoSuave => _c(0xFFF3EEFD, 0xFF251E3D);
  static Color get azul => _c(0xFF3B7DED, 0xFF60A5FA);
  static Color get azulSuave => _c(0xFFEAF1FE, 0xFF15243D);
  static Color get dark1 => _c(0xFF252A38, 0xFF27272A);
  static Color get dark2 => _c(0xFF191D28, 0xFF18181B);
}

/// deixa a barra de navegação do Android transparente e com os
/// ícones na cor certa para o tema atual
void aplicarBarrasDoSistema() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: T.bg,
    systemNavigationBarDividerColor: T.bg,
    systemNavigationBarContrastEnforced: false,
    systemNavigationBarIconBrightness:
        T.escuro ? Brightness.light : Brightness.dark,
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  ));
}

const double kBarH = 64;
const double kBarR = 22;
const double kNotchR = 30;
const double kBubble = 56;
const double kSide = 16;

/// Degradê vermelho usado no header e nos botões
LinearGradient get kGradRed => LinearGradient(
      colors: [T.red, T.redDark],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

/// Sombra suave dos cartões brancos
List<BoxShadow> sombraCard(
        {double opacidade = .06, double blur = 10, double y = 2}) =>
    [
      BoxShadow(
        color: (T.escuro ? Colors.black : const Color(0xFF1E233C))
            .withOpacity(T.escuro ? opacidade * 2.4 : opacidade),
        blurRadius: blur,
        offset: Offset(0, y),
      ),
    ];

/* ---------- cabeçalho vermelho reaproveitado pelas telas ---------- */
class HeaderVermelho extends StatelessWidget {
  final Widget child;
  final double alturaExtra;
  const HeaderVermelho({super.key, required this.child, this.alturaExtra = 60});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: kGradRed),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 8, 20, alturaExtra),
          child: child,
        ),
      ),
    );
  }
}

/* ================================================================== *
 *  TELA INTERNA — título no header vermelho + botão redondo de voltar
 *  `acao` (opcional) vira o botão da direita (ex.: lixeira, ⋯)
 * ================================================================== */
class TelaInterna extends StatelessWidget {
  final String titulo;
  final Widget child;
  final bool rolavel;
  final Widget? acao;
  const TelaInterna(
      {super.key,
      required this.titulo,
      required this.child,
      this.rolavel = true,
      this.acao});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: T.bg,
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          HeaderVermelho(
            child: Row(
              children: [
                BotaoDoHeader(
                    icone: Ico.voltar,
                    aoTocar: () => Navigator.of(context).maybePop()),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(titulo,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -.3)),
                  ),
                ),
                acao ?? const SizedBox(width: 40),
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
                padding: EdgeInsets.fromLTRB(kSide, 22, kSide,
                    26 + MediaQuery.viewPaddingOf(context).bottom),
                child: rolavel
                    ? SingleChildScrollView(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        child: child,
                      )
                    : child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ---------- botão redondo branco translúcido do header ---------- */
class BotaoDoHeader extends StatelessWidget {
  final IconData icone;
  final VoidCallback? aoTocar;
  const BotaoDoHeader({super.key, required this.icone, this.aoTocar});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: aoTocar,
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(.14),
        ),
        child: Icon(icone, size: 20, color: Colors.white),
      ),
    );
  }
}

/* ---------- spinner de carregando ---------- */
class Espera extends StatelessWidget {
  final String texto;
  final double tamanho;
  const Espera({super.key, this.texto = 'Carregando...', this.tamanho = 15});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: tamanho,
          height: tamanho,
          child:
              CircularProgressIndicator(strokeWidth: 2.6, color: T.redDark),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(texto,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: tamanho,
                  fontWeight: FontWeight.w800,
                  color: T.ink,
                  letterSpacing: -.3)),
        ),
      ],
    );
  }
}

/* ---------- interruptor no padrão Mindi ---------- */
class ToggleMindi extends StatelessWidget {
  final bool ligado;
  final ValueChanged<bool>? aoMudar;
  final Color? corLigado;
  final Color? corDesligado;

  const ToggleMindi({
    super.key,
    required this.ligado,
    this.aoMudar,
    this.corLigado,
    this.corDesligado,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: aoMudar == null ? null : () => aoMudar!(!ligado),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 38,
        height: 22,
        padding: const EdgeInsets.all(2.5),
        alignment: ligado ? Alignment.centerRight : Alignment.centerLeft,
        decoration: BoxDecoration(
          color: ligado
              ? (corLigado ?? const Color(0xFF2ECC71))
              : (corDesligado ?? T.fraco),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Container(
          width: 17,
          height: 17,
          decoration:
              const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        ),
      ),
    );
  }
}

/* ---------- afunda um pouco quando o dedo toca ---------- */
class AfundaAoTocar extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double escala;

  const AfundaAoTocar({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.escala = .96,
  });

  @override
  State<AfundaAoTocar> createState() => _AfundaAoTocarState();
}

class _AfundaAoTocarState extends State<AfundaAoTocar> {
  bool _pressionado = false;

  void _muda(bool v) {
    if (_pressionado != v && mounted) setState(() => _pressionado = v);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      onTapDown: (_) => _muda(true),
      onTapUp: (_) => _muda(false),
      onTapCancel: () => _muda(false),
      child: AnimatedScale(
        scale: _pressionado ? widget.escala : 1,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

/* ================================================================== *
 *  PEDAÇOS REAPROVEITADOS PELAS TELAS DA PRÉVIA
 * ================================================================== */

/// cartão branco padrão
class CardBranco extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const CardBranco(
      {super.key,
      required this.child,
      this.padding = const EdgeInsets.all(14)});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: T.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: T.borda),
        boxShadow: sombraCard(),
      ),
      child: child,
    );
  }
}

/// título de seção (tipografia padrão dos apps)
class TituloSecao extends StatelessWidget {
  final String texto;
  const TituloSecao(this.texto, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
      child: Text(texto,
          style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              letterSpacing: .1,
              color: T.inkSoft)),
    );
  }
}

/// quadradinho de ícone 36x36 dos cards compactos
class QuadIcone extends StatelessWidget {
  final IconData icone;
  final Color fundo;
  final Color cor;
  const QuadIcone(
      {super.key,
      required this.icone,
      required this.fundo,
      required this.cor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: fundo,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icone, size: 17, color: cor),
    );
  }
}

/// linha padrão dos cards: ícone + título + subtítulo + algo à direita
class LinhaCard extends StatelessWidget {
  final IconData icone;
  final Color fundo;
  final Color cor;
  final String titulo;
  final String? sub;
  final Widget? direita;
  const LinhaCard(
      {super.key,
      required this.icone,
      required this.fundo,
      required this.cor,
      required this.titulo,
      this.sub,
      this.direita});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        QuadIcone(icone: icone, fundo: fundo, cor: cor),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(titulo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: T.ink)),
              if (sub != null) ...[
                const SizedBox(height: 1),
                Text(sub!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11.5, color: T.inkSoft)),
              ],
            ],
          ),
        ),
        if (direita != null) ...[const SizedBox(width: 8), direita!],
      ],
    );
  }
}

/// badge pequeno (ONLINE, WARNING...)
class Badge2 extends StatelessWidget {
  final String texto;
  final Color fundo;
  final Color borda;
  final Color cor;
  const Badge2(
      {super.key,
      required this.texto,
      required this.fundo,
      required this.borda,
      required this.cor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: fundo,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: borda),
      ),
      child: Text(texto,
          style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
              letterSpacing: .4,
              color: cor)),
    );
  }
}

/// abre o bottom sheet padrão do app (alça + cantos redondos)
Future<void> abrirSheet(BuildContext context, Widget child) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: T.card,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            20, 14, 20, 20 + MediaQuery.viewInsetsOf(ctx).bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                    color: T.borda, borderRadius: BorderRadius.circular(999)),
              ),
            ),
            child,
          ],
        ),
      ),
    ),
  );
}

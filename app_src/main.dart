import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tema.dart';
import 'estado.dart';
import 'app_shell.dart';
import 'tela_conectar.dart';

/* ================================================================== *
 *  MINDI PRINTER — PRÉVIA VISUAL
 *  Este app é só para ver as telas novas no celular.
 *  Nada aqui conecta em servidor de verdade.
 * ================================================================== */
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await carregarTema();
  final chave = await lerChave();
  runApp(MeuApp(temChave: chave.isNotEmpty));
}

class MeuApp extends StatelessWidget {
  final bool temChave;
  const MeuApp({super.key, required this.temChave});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: modoEscuro,
      builder: (context, escuro, _) {
        aplicarBarrasDoSistema();
        final brilho = escuro ? Brightness.dark : Brightness.light;

        return MaterialApp(
          key: ValueKey(escuro),
          title: 'Mindi Printer',
          debugShowCheckedModeBanner: false,
          locale: const Locale('pt', 'BR'),
          supportedLocales: const [Locale('pt', 'BR')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: ThemeData(
            useMaterial3: true,
            brightness: brilho,
            fontFamily: GoogleFonts.inter().fontFamily,
            scaffoldBackgroundColor: T.bg,
            canvasColor: T.bg,
            colorScheme: ColorScheme.fromSeed(
              seedColor: T.red,
              brightness: brilho,
            ),
          ),
          home: temChave ? const AppShell() : const TelaConectar(),
        );
      },
    );
  }
}

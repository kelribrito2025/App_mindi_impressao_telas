import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/* ================================================================== *
 *  ESTADO GLOBAL — versão de prévia (tudo de mentirinha)
 * ================================================================== */

/// Tema escuro ligado? (fica salvo no celular)
final modoEscuro = ValueNotifier<bool>(false);

const _kTema = 'modoEscuro';

Future<void> carregarTema() async {
  final p = await SharedPreferences.getInstance();
  modoEscuro.value = p.getBool(_kTema) ?? false;
}

Future<void> salvarTema(bool escuro) async {
  modoEscuro.value = escuro;
  final p = await SharedPreferences.getInstance();
  await p.setBool(_kTema, escuro);
}

/// Aba aberta na barra de baixo (0 Início, 1 Impressoras, 2 Ajustes)
final abaSelecionada = ValueNotifier<int>(0);

/// Online/Offline do toggle no header (só visual nesta prévia)
final servidorOnline = ValueNotifier<bool>(true);

/// API Key "conectada" (a prévia só guarda no celular, não valida)
const _kChave = 'apiKey';

Future<String> lerChave() async {
  final p = await SharedPreferences.getInstance();
  return p.getString(_kChave) ?? '';
}

Future<void> salvarChave(String chave) async {
  final p = await SharedPreferences.getInstance();
  await p.setString(_kChave, chave);
}

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:gs_flutter/data/livros_mock.dart';
import 'package:gs_flutter/models/livro.dart';
import 'package:gs_flutter/models/troca.dart';

class ArmazenamentoService {
  static const String chaveIntro = 'intro_vista';
  static const String chaveLivros = 'livros_cadastrados';
  static const String chaveTrocas = 'trocas_enviadas';

  Future<bool> introJaVista() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(chaveIntro) ?? false;
  }

  Future<void> marcarIntroVista() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(chaveIntro, true);
  }

  Future<List<Livro>> buscarMeusLivros() async {
    final prefs = await SharedPreferences.getInstance();
    final lista = prefs.getStringList(chaveLivros) ?? [];

    return lista.map((item) => Livro.fromJson(jsonDecode(item))).toList();
  }

  Future<List<Livro>> buscarTodosLivros() async {
    final meusLivros = await buscarMeusLivros();
    return [...meusLivros, ...livrosMock];
  }

  Future<void> adicionarLivro(Livro livro) async {
    final livros = await buscarMeusLivros();
    livros.insert(0, livro);
    await _salvarLivros(livros);
  }

  Future<void> removerLivro(String id) async {
    final livros = await buscarMeusLivros();
    livros.removeWhere((livro) => livro.id == id);
    await _salvarLivros(livros);
  }

  Future<void> _salvarLivros(List<Livro> livros) async {
    final prefs = await SharedPreferences.getInstance();
    final lista = livros.map((livro) => jsonEncode(livro.toJson())).toList();
    await prefs.setStringList(chaveLivros, lista);
  }


  Future<List<Troca>> buscarTrocas() async {
    final prefs = await SharedPreferences.getInstance();
    final lista = prefs.getStringList(chaveTrocas) ?? [];

    return lista.map((item) => Troca.fromJson(jsonDecode(item))).toList();
  }

  Future<void> adicionarTroca(Troca troca) async {
    final trocas = await buscarTrocas();
    trocas.insert(0, troca);
    await _salvarTrocas(trocas);
  }

  Future<void> removerTroca(String id) async {
    final trocas = await buscarTrocas();
    trocas.removeWhere((troca) => troca.id == id);
    await _salvarTrocas(trocas);
  }

  Future<void> _salvarTrocas(List<Troca> trocas) async {
    final prefs = await SharedPreferences.getInstance();
    final lista = trocas.map((troca) => jsonEncode(troca.toJson())).toList();
    await prefs.setStringList(chaveTrocas, lista);
  }
}

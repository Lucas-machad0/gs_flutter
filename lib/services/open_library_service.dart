import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:gs_flutter/models/livro_api.dart';

class OpenLibraryService {
  static const String urlBase = 'https://openlibrary.org';

  Future<LivroApi?> buscarLivro(String titulo) async {
    final url = Uri.parse(
      '$urlBase/search.json?title=${Uri.encodeComponent(titulo)}&limit=1',
    );

    final resposta = await http.get(url);

    if (resposta.statusCode != 200) {
      throw Exception('Erro ao buscar o livro.');
    }

    // utf8.decode para os acentos aparecerem certos.
    final json = jsonDecode(utf8.decode(resposta.bodyBytes));
    final docs = json['docs'] as List;

    if (docs.isEmpty) {
      return null;
    }

    return LivroApi.fromJson(docs.first);
  }
}

import 'package:flutter/material.dart';
import 'package:gs_flutter/ui/app_cores.dart';

class CapaLivro extends StatelessWidget {
  final String imagem;
  final double largura;
  final double altura;

  const CapaLivro({
    super.key,
    required this.imagem,
    this.largura = 60,
    this.altura = 90,
  });

  @override
  Widget build(BuildContext context) {
    Widget conteudo;

    if (imagem.isEmpty) {
      conteudo = const Icon(Icons.menu_book, color: AppCores.verde);
    } else if (imagem.startsWith('http')) {
      conteudo = Image.network(
        imagem,
        fit: BoxFit.cover,
        webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.menu_book, color: AppCores.verde),
      );
    } else {
      conteudo = Image.asset(imagem, fit: BoxFit.cover);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: largura,
        height: altura,
        color: AppCores.salvia,
        child: conteudo,
      ),
    );
  }
}

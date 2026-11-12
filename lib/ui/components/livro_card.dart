import 'package:flutter/material.dart';
import 'package:gs_flutter/models/livro.dart';
import 'package:gs_flutter/ui/app_cores.dart';
import 'package:gs_flutter/ui/components/capa_livro.dart';
import 'package:gs_flutter/ui/components/etiqueta.dart';

class LivroCard extends StatelessWidget {
  final Livro livro;
  final VoidCallback aoTocar;

  const LivroCard({super.key, required this.livro, required this.aoTocar});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: InkWell(
        onTap: aoTocar,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CapaLivro(imagem: livro.imagem),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      livro.titulo,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      livro.autor,
                      style: const TextStyle(color: AppCores.textoSecundario),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'De: ${livro.dono}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppCores.textoSecundario,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Etiqueta(texto: livro.estado),
                        if (livro.ehMeu) ...[
                          const SizedBox(width: 6),
                          const Etiqueta(texto: 'Seu livro', cor: AppCores.lima),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

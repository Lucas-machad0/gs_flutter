import 'package:flutter/material.dart';
import 'package:gs_flutter/models/livro.dart';
import 'package:gs_flutter/navigation/app_routes.dart';
import 'package:gs_flutter/services/armazenamento_service.dart';
import 'package:gs_flutter/ui/app_cores.dart';
import 'package:gs_flutter/ui/components/capa_livro.dart';
import 'package:gs_flutter/ui/components/etiqueta.dart';
import 'package:gs_flutter/ui/components/top_bar.dart';

class DetalhesScreen extends StatelessWidget {
  final Livro livro;

  const DetalhesScreen({super.key, required this.livro});

  Future<void> _removerLivro(BuildContext context) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remover livro'),
        content: Text('Deseja remover "${livro.titulo}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remover'),
          ),
        ],
      ),
    );

    if (confirmou != true) return;

    await ArmazenamentoService().removerLivro(livro.id);

    if (!context.mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        titulo: 'Detalhes do livro',
        acoes: [
          if (livro.ehMeu)
            IconButton(
              tooltip: 'Remover livro',
              icon: const Icon(Icons.delete),
              onPressed: () => _removerLivro(context),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: CapaLivro(imagem: livro.imagem, largura: 150, altura: 225),
          ),
          const SizedBox(height: 16),
          Text(
            livro.titulo,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            livro.autor,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: AppCores.textoSecundario,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: Colors.white,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Leitor'),
                  subtitle: Text(livro.dono),
                ),
                ListTile(
                  leading: const Icon(Icons.auto_stories),
                  title: const Text('Estado'),
                  trailing: Etiqueta(texto: livro.estado),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          if (livro.ehMeu)
            const Text(
              'Este livro é seu. Outros leitores podem propor uma troca.',
              textAlign: TextAlign.center,
            )
          else
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(
                context,
                AppRoutes.proporTroca,
                arguments: livro,
              ),
              icon: const Icon(Icons.swap_horiz),
              label: const Text('Propor troca'),
            ),
        ],
      ),
    );
  }
}

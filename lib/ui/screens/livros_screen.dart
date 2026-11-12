import 'package:flutter/material.dart';
import 'package:gs_flutter/models/livro.dart';
import 'package:gs_flutter/navigation/app_routes.dart';
import 'package:gs_flutter/services/armazenamento_service.dart';
import 'package:gs_flutter/ui/components/livro_card.dart';
import 'package:gs_flutter/ui/components/mensagem.dart';
import 'package:gs_flutter/ui/components/top_bar.dart';

class LivrosScreen extends StatefulWidget {
  const LivrosScreen({super.key});

  @override
  State<LivrosScreen> createState() => _LivrosScreenState();
}

class _LivrosScreenState extends State<LivrosScreen> {
  final ArmazenamentoService _armazenamento = ArmazenamentoService();

  List<Livro> _livros = [];
  String _busca = '';
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarLivros();
  }

  Future<void> _carregarLivros() async {
    final resultado = await _armazenamento.buscarTodosLivros();

    if (!mounted) return;

    setState(() {
      _livros = resultado;
      _carregando = false;
    });
  }

  List<Livro> get _livrosFiltrados {
    final texto = _busca.toLowerCase();

    return _livros.where((livro) {
      return livro.titulo.toLowerCase().contains(texto) ||
          livro.autor.toLowerCase().contains(texto) ||
          livro.dono.toLowerCase().contains(texto);
    }).toList();
  }

  Future<void> _abrirDetalhes(Livro livro) async {
    await Navigator.pushNamed(context, AppRoutes.detalhes, arguments: livro);
    _carregarLivros();
  }

  @override
  Widget build(BuildContext context) {
    final lista = _livrosFiltrados;

    return Scaffold(
      appBar: const TopBar(titulo: 'EntrePáginas'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Buscar livro, autor ou leitor',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (valor) {
                setState(() {
                  _busca = valor;
                });
              },
            ),
          ),
          Expanded(
            child: _carregando
                ? const Center(child: CircularProgressIndicator())
                : lista.isEmpty
                    ? const Mensagem(
                        icone: Icons.search_off,
                        texto: 'Nenhum livro encontrado.',
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: lista.length,
                        itemBuilder: (context, indice) {
                          final livro = lista[indice];

                          return LivroCard(
                            livro: livro,
                            aoTocar: () => _abrirDetalhes(livro),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gs_flutter/models/livro.dart';
import 'package:gs_flutter/navigation/app_routes.dart';
import 'package:gs_flutter/services/armazenamento_service.dart';
import 'package:gs_flutter/ui/app_cores.dart';
import 'package:gs_flutter/ui/components/livro_card.dart';
import 'package:gs_flutter/ui/components/mensagem.dart';
import 'package:gs_flutter/ui/components/top_bar.dart';

class MeusLivrosScreen extends StatefulWidget {
  const MeusLivrosScreen({super.key});

  @override
  State<MeusLivrosScreen> createState() => _MeusLivrosScreenState();
}

class _MeusLivrosScreenState extends State<MeusLivrosScreen> {
  final ArmazenamentoService _armazenamento = ArmazenamentoService();

  List<Livro> _livros = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarLivros();
  }

  Future<void> _carregarLivros() async {
    final resultado = await _armazenamento.buscarMeusLivros();

    if (!mounted) return;

    setState(() {
      _livros = resultado;
      _carregando = false;
    });
  }

  Future<void> _abrirCadastro() async {
    final salvou = await Navigator.pushNamed(context, AppRoutes.cadastro);

    if (salvou == true) {
      _carregarLivros();
    }
  }

  Future<void> _abrirDetalhes(Livro livro) async {
    await Navigator.pushNamed(context, AppRoutes.detalhes, arguments: livro);
    _carregarLivros();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(titulo: 'Meus livros'),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppCores.terracota,
        foregroundColor: Colors.white,
        onPressed: _abrirCadastro,
        icon: const Icon(Icons.add),
        label: const Text('Cadastrar livro'),
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _livros.isEmpty
              ? Mensagem(
                  icone: Icons.menu_book,
                  texto: 'Você ainda não cadastrou nenhum livro.',
                  textoBotao: 'Cadastrar livro',
                  aoPressionar: _abrirCadastro,
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                  itemCount: _livros.length,
                  itemBuilder: (context, indice) {
                    final livro = _livros[indice];

                    return LivroCard(
                      livro: livro,
                      aoTocar: () => _abrirDetalhes(livro),
                    );
                  },
                ),
    );
  }
}

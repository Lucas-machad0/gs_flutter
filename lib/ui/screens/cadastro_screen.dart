import 'package:flutter/material.dart';
import 'package:gs_flutter/models/livro.dart';
import 'package:gs_flutter/models/livro_api.dart';
import 'package:gs_flutter/models/status_busca.dart';
import 'package:gs_flutter/services/armazenamento_service.dart';
import 'package:gs_flutter/services/open_library_service.dart';
import 'package:gs_flutter/ui/app_cores.dart';
import 'package:gs_flutter/ui/components/capa_livro.dart';
import 'package:gs_flutter/ui/components/mensagem.dart';
import 'package:gs_flutter/ui/components/top_bar.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final OpenLibraryService _api = OpenLibraryService();
  final ArmazenamentoService _armazenamento = ArmazenamentoService();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _tituloController = TextEditingController();

  final List<String> _estados = ['Novo', 'Bom estado', 'Usado', 'Desgastado'];

  StatusBusca _status = StatusBusca.inicial;
  LivroApi? _livroEncontrado;
  String? _estadoEscolhido;

  @override
  void dispose() {
    _nomeController.dispose();
    _tituloController.dispose();
    super.dispose();
  }

  Future<void> _buscarLivro() async {
    final titulo = _tituloController.text.trim();

    if (titulo.isEmpty) {
      _mostrarMensagem('Digite o nome do livro.');
      return;
    }

    setState(() {
      _status = StatusBusca.carregando;
      _livroEncontrado = null;
    });

    try {
      final resultado = await _api.buscarLivro(titulo);

      if (!mounted) return;

      setState(() {
        _livroEncontrado = resultado;
        _status = StatusBusca.sucesso;
      });
    } catch (erro) {
      if (!mounted) return;

      setState(() {
        _status = StatusBusca.erro;
      });
    }
  }

  Future<void> _salvarLivro() async {
    final nome = _nomeController.text.trim();
    final livro = _livroEncontrado;

    if (nome.isEmpty) {
      _mostrarMensagem('Informe seu nome.');
      return;
    }

    if (livro == null) {
      _mostrarMensagem('Busque um livro antes de salvar.');
      return;
    }

    if (_estadoEscolhido == null) {
      _mostrarMensagem('Escolha o estado do livro.');
      return;
    }

    await _armazenamento.adicionarLivro(
      Livro(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        titulo: livro.titulo,
        autor: livro.autor,
        imagem: livro.capaUrl,
        dono: nome,
        estado: _estadoEscolhido!,
        ehMeu: true,
      ),
    );

    if (!mounted) return;

    _mostrarMensagem('Livro cadastrado!');
    Navigator.pop(context, true); // true = salvou
  }

  void _mostrarMensagem(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(titulo: 'Cadastrar livro'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _nomeController,
            decoration: const InputDecoration(
              labelText: 'Seu nome',
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _tituloController,
                  decoration: const InputDecoration(
                    labelText: 'Nome do livro',
                    hintText: 'Ex.: Dom Casmurro',
                    prefixIcon: Icon(Icons.menu_book),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                tooltip: 'Buscar',
                icon: const Icon(Icons.search),
                onPressed:
                    _status == StatusBusca.carregando ? null : _buscarLivro,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _resultadoDaBusca(),
          const SizedBox(height: 16),
          const Text(
            'Estado do livro',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _estados.map((estado) {
              return ChoiceChip(
                label: Text(estado),
                selected: _estadoEscolhido == estado,
                selectedColor: AppCores.lima,
                onSelected: (_) {
                  setState(() {
                    _estadoEscolhido = estado;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _salvarLivro,
            icon: const Icon(Icons.save),
            label: const Text('Salvar livro'),
          ),
        ],
      ),
    );
  }

  Widget _resultadoDaBusca() {
    switch (_status) {
      case StatusBusca.inicial:
        return const Mensagem(
          icone: Icons.travel_explore,
          texto: 'Digite o nome do livro e toque na lupa.',
        );

      case StatusBusca.carregando:
        return const Center(child: CircularProgressIndicator());

      case StatusBusca.erro:
        return Mensagem(
          icone: Icons.wifi_off,
          texto: 'Não foi possível buscar o livro. Verifique a internet.',
          textoBotao: 'Tentar novamente',
          aoPressionar: _buscarLivro,
        );

      case StatusBusca.sucesso:
        final livro = _livroEncontrado;

        if (livro == null) {
          return const Mensagem(
            icone: Icons.search_off,
            texto: 'Nenhum livro encontrado com esse nome.',
          );
        }

        return Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CapaLivro(imagem: livro.capaUrl),
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
                      Text(livro.autor),
                    ],
                  ),
                ),
                const Icon(Icons.check_circle, color: Colors.green),
              ],
            ),
          ),
        );
    }
  }
}

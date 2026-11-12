import 'package:flutter/material.dart';
import 'package:gs_flutter/models/livro.dart';
import 'package:gs_flutter/models/troca.dart';
import 'package:gs_flutter/navigation/app_routes.dart';
import 'package:gs_flutter/services/armazenamento_service.dart';
import 'package:gs_flutter/ui/app_cores.dart';
import 'package:gs_flutter/ui/components/mensagem.dart';
import 'package:gs_flutter/ui/components/top_bar.dart';

class ProporTrocaScreen extends StatefulWidget {
  final Livro livroDesejado;

  const ProporTrocaScreen({super.key, required this.livroDesejado});

  @override
  State<ProporTrocaScreen> createState() => _ProporTrocaScreenState();
}

class _ProporTrocaScreenState extends State<ProporTrocaScreen> {
  final ArmazenamentoService _armazenamento = ArmazenamentoService();

  List<Livro> _meusLivros = [];
  Livro? _livroEscolhido;
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarMeusLivros();
  }

  Future<void> _carregarMeusLivros() async {
    final resultado = await _armazenamento.buscarMeusLivros();

    if (!mounted) return;

    setState(() {
      _meusLivros = resultado;
      _carregando = false;
    });
  }

  Future<void> _abrirCadastro() async {
    final salvou = await Navigator.pushNamed(context, AppRoutes.cadastro);

    if (salvou == true) {
      _carregarMeusLivros();
    }
  }

  Future<void> _enviarProposta() async {
    final meuLivro = _livroEscolhido;

    if (meuLivro == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escolha um livro seu para oferecer.')),
      );
      return;
    }

    await _armazenamento.adicionarTroca(
      Troca(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        livroOferecido: meuLivro.titulo,
        livroDesejado: widget.livroDesejado.titulo,
        donoDesejado: widget.livroDesejado.dono,
      ),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Proposta enviada para ${widget.livroDesejado.dono}! '
          'Veja na aba Trocas.',
        ),
      ),
    );

    Navigator.popUntil(context, ModalRoute.withName(AppRoutes.principal));
  }

  @override
  Widget build(BuildContext context) {
    final desejado = widget.livroDesejado;

    return Scaffold(
      appBar: const TopBar(titulo: 'Propor troca'),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Livro que você quer',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Card(
                  color: Colors.white,
                  child: ListTile(
                    leading: const Icon(Icons.menu_book),
                    title: Text(desejado.titulo),
                    subtitle: Text('De ${desejado.dono} • ${desejado.estado}'),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Escolha um livro seu para oferecer',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                if (_meusLivros.isEmpty)
                  Mensagem(
                    icone: Icons.menu_book,
                    texto: 'Você ainda não cadastrou nenhum livro.',
                    textoBotao: 'Cadastrar livro',
                    aoPressionar: _abrirCadastro,
                  )
                else
                  Card(
                    color: Colors.white,
                    child: Column(
                      children: _meusLivros.map((livro) {
                        final escolhido = _livroEscolhido?.id == livro.id;

                        return ListTile(
                          title: Text(livro.titulo),
                          subtitle: Text(livro.autor),
                          trailing: Icon(
                            escolhido
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: escolhido ? AppCores.terracota : Colors.grey,
                          ),
                          onTap: () {
                            setState(() {
                              _livroEscolhido = livro;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                const SizedBox(height: 16),

                if (_livroEscolhido != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppCores.salvia,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.swap_horiz, color: AppCores.terracota),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Troca ${_livroEscolhido!.titulo} por ${desejado.titulo}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _meusLivros.isEmpty ? null : _enviarProposta,
                  icon: const Icon(Icons.send),
                  label: const Text('Enviar proposta'),
                ),
              ],
            ),
    );
  }
}

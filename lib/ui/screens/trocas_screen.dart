import 'package:flutter/material.dart';
import 'package:gs_flutter/models/troca.dart';
import 'package:gs_flutter/services/armazenamento_service.dart';
import 'package:gs_flutter/ui/app_cores.dart';
import 'package:gs_flutter/ui/components/etiqueta.dart';
import 'package:gs_flutter/ui/components/mensagem.dart';
import 'package:gs_flutter/ui/components/top_bar.dart';

class TrocasScreen extends StatefulWidget {
  const TrocasScreen({super.key});

  @override
  State<TrocasScreen> createState() => _TrocasScreenState();
}

class _TrocasScreenState extends State<TrocasScreen> {
  final ArmazenamentoService _armazenamento = ArmazenamentoService();

  List<Troca> _trocas = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarTrocas();
  }

  Future<void> _carregarTrocas() async {
    final resultado = await _armazenamento.buscarTrocas();

    if (!mounted) return;

    setState(() {
      _trocas = resultado;
      _carregando = false;
    });
  }

  Future<void> _cancelarTroca(Troca troca) async {
    await _armazenamento.removerTroca(troca.id);
    await _carregarTrocas();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Proposta cancelada.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(titulo: 'Minhas trocas'),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _trocas.isEmpty
              ? const Mensagem(
                  icone: Icons.swap_horiz,
                  texto:
                      'Você ainda não propôs nenhuma troca.\n'
                      'Escolha um livro na aba Livros.',
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _trocas.length,
                  itemBuilder: (context, indice) {
                    final troca = _trocas[indice];

                    return Card(
                      color: Colors.white,
                      child: ListTile(
                        leading: const Icon(
                          Icons.swap_horiz,
                          color: AppCores.terracota,
                          size: 32,
                        ),
                        title: Text(
                          'Troca ${troca.livroOferecido} por ${troca.livroDesejado}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text('Com ${troca.donoDesejado}'),
                              Etiqueta(texto: troca.status),
                            ],
                          ),
                        ),
                        trailing: IconButton(
                          tooltip: 'Cancelar proposta',
                          icon: const Icon(Icons.close),
                          onPressed: () => _cancelarTroca(troca),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

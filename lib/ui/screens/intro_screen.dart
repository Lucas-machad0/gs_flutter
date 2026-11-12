import 'package:flutter/material.dart';
import 'package:gs_flutter/navigation/app_routes.dart';
import 'package:gs_flutter/services/armazenamento_service.dart';
import 'package:gs_flutter/ui/app_cores.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final ArmazenamentoService _armazenamento = ArmazenamentoService();

  int _paginaAtual = 0;
  bool _naoMostrarNovamente = false;

  final List<Map<String, String>> _paginas = [
    {
      'imagem': 'assets/images/onboarding_cadastre.jpg',
      'titulo': 'Cadastre seus livros',
      'descricao':
          'Informe seu nome, busque o livro pelo título e diga em que estado ele está.',
    },
    {
      'imagem': 'assets/images/onboarding_encontre.jpg',
      'titulo': 'Encontre na comunidade',
      'descricao': 'Veja os livros que outros leitores querem trocar.',
    },
    {
      'imagem': 'assets/images/onboarding_troque.jpg',
      'titulo': 'Proponha uma troca',
      'descricao': 'Ofereça um livro seu e ganhe uma nova leitura.',
    },
  ];

  void _avancar() {
    if (_paginaAtual < _paginas.length - 1) {
      setState(() {
        _paginaAtual++;
      });
    } else {
      _finalizar();
    }
  }

  void _voltar() {
    if (_paginaAtual > 0) {
      setState(() {
        _paginaAtual--;
      });
    }
  }

  Future<void> _finalizar() async {
    if (_naoMostrarNovamente) {
      await _armazenamento.marcarIntroVista();
    }

    if (!mounted) return;

    Navigator.pushReplacementNamed(context, AppRoutes.principal);
  }

  @override
  Widget build(BuildContext context) {
    final pagina = _paginas[_paginaAtual];
    final ultimaPagina = _paginaAtual == _paginas.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    pagina['imagem']!,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                pagina['titulo']!,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppCores.verde,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                pagina['descricao']!,
                style: const TextStyle(fontSize: 15, height: 1.6),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Bolinhas indicando a página atual
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _paginas.length,
                  (indice) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _paginaAtual == indice ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: _paginaAtual == indice
                          ? AppCores.terracota
                          : Colors.grey.shade400,
                    ),
                  ),
                ),
              ),

              CheckboxListTile(
                value: _naoMostrarNovamente,
                title: const Text('Não mostrar novamente'),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                onChanged: (valor) {
                  setState(() {
                    _naoMostrarNovamente = valor ?? false;
                  });
                },
              ),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _paginaAtual > 0 ? _voltar : null,
                      child: const Text('Voltar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _avancar,
                      child: Text(ultimaPagina ? 'Começar' : 'Avançar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

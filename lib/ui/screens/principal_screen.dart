import 'package:flutter/material.dart';
import 'package:gs_flutter/ui/screens/livros_screen.dart';
import 'package:gs_flutter/ui/screens/meus_livros_screen.dart';
import 'package:gs_flutter/ui/screens/trocas_screen.dart';

class PrincipalScreen extends StatefulWidget {
  const PrincipalScreen({super.key});

  @override
  State<PrincipalScreen> createState() => _PrincipalScreenState();
}

class _PrincipalScreenState extends State<PrincipalScreen> {
  int _abaAtual = 0;

  final List<Widget> _telas = const [
    LivrosScreen(),
    MeusLivrosScreen(),
    TrocasScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _telas[_abaAtual],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _abaAtual,
        onDestinationSelected: (indice) {
          setState(() {
            _abaAtual = indice;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Livros',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book),
            label: 'Meus livros',
          ),
          NavigationDestination(
            icon: Icon(Icons.swap_horiz),
            label: 'Trocas',
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;
  final List<Widget>? acoes;

  const TopBar({super.key, required this.titulo, this.acoes});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(titulo),
      actions: acoes,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

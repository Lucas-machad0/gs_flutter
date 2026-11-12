import 'package:flutter/material.dart';
import 'package:gs_flutter/ui/app_cores.dart';

class Etiqueta extends StatelessWidget {
  final String texto;
  final Color cor;

  const Etiqueta({
    super.key,
    required this.texto,
    this.cor = AppCores.salvia,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: cor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        texto,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppCores.verde,
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:gs_flutter/ui/app_cores.dart';

class Mensagem extends StatelessWidget {
  final IconData icone;
  final String texto;
  final String? textoBotao;
  final VoidCallback? aoPressionar;

  const Mensagem({
    super.key,
    required this.icone,
    required this.texto,
    this.textoBotao,
    this.aoPressionar,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icone, size: 56, color: AppCores.textoSecundario),
            const SizedBox(height: 12),
            Text(
              texto,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppCores.textoSecundario),
            ),
            if (textoBotao != null && aoPressionar != null) ...[
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: aoPressionar,
                child: Text(textoBotao!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

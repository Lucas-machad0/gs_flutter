import 'package:flutter/material.dart';
import 'package:gs_flutter/navigation/app_routes.dart';
import 'package:gs_flutter/services/armazenamento_service.dart';
import 'package:gs_flutter/ui/app_cores.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final ArmazenamentoService _armazenamento = ArmazenamentoService();

  @override
  void initState() {
    super.initState();
    _irParaProximaTela();
  }

  Future<void> _irParaProximaTela() async {
    await Future.delayed(const Duration(seconds: 3));

    final introVista = await _armazenamento.introJaVista();

    if (!mounted) return;

    Navigator.pushReplacementNamed(
      context,
      introVista ? AppRoutes.principal : AppRoutes.intro,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppCores.verde,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/logo.png',
                width: 160,
                height: 160,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'EntrePáginas',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Troca de livros na sua comunidade',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

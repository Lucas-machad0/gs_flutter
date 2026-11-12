import 'package:flutter/material.dart';
import 'package:gs_flutter/models/livro.dart';
import 'package:gs_flutter/navigation/app_routes.dart';
import 'package:gs_flutter/ui/screens/cadastro_screen.dart';
import 'package:gs_flutter/ui/screens/detalhes_screen.dart';
import 'package:gs_flutter/ui/screens/intro_screen.dart';
import 'package:gs_flutter/ui/screens/principal_screen.dart';
import 'package:gs_flutter/ui/screens/propor_troca_screen.dart';
import 'package:gs_flutter/ui/screens/splash_screen.dart';

class AppNavigation {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutes.intro:
        return MaterialPageRoute(builder: (_) => const IntroScreen());
      case AppRoutes.principal:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const PrincipalScreen(),
        );
      case AppRoutes.cadastro:
        return MaterialPageRoute(builder: (_) => const CadastroScreen());
      case AppRoutes.detalhes:

        final livro = settings.arguments as Livro;
        return MaterialPageRoute(
          builder: (_) => DetalhesScreen(livro: livro),
        );
      case AppRoutes.proporTroca:
        final livro = settings.arguments as Livro;
        return MaterialPageRoute(
          builder: (_) => ProporTrocaScreen(livroDesejado: livro),
        );
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Rota não encontrada'))),
        );
    }
  }
}

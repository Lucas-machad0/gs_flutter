import 'package:flutter/material.dart';
import 'package:gs_flutter/navigation/app_navigation.dart';
import 'package:gs_flutter/navigation/app_routes.dart';
import 'package:gs_flutter/ui/app_cores.dart';

void main() {
  runApp(const EntrePaginasApp());
}

class EntrePaginasApp extends StatelessWidget {
  const EntrePaginasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EntrePáginas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppCores.verde,
          primary: AppCores.verde,
        ),
        scaffoldBackgroundColor: AppCores.fundo,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppCores.verde,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppCores.terracota,
            foregroundColor: Colors.white,
            minimumSize: const Size(0, 50),
          ),
        ),
      ),
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppNavigation.generateRoute,
    );
  }
}

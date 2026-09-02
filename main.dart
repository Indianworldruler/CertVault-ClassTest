import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'home_screen.dart';
import 'add_certification_screen.dart';
import 'details_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: CertVaultApp(),
    ),
  );
}

class CertVaultApp extends StatelessWidget {
  const CertVaultApp({super.key});

  static const Color navy = Color(0xFF101A36);
  static const Color blue = Color(0xFF2878F0);
  static const Color cyan = Color(0xFF39C6E8);

  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
      initialLocation: '/',
      routes: [
        // HOME
        GoRoute(
          path: '/',
          builder: (context, state) {
            return const HomeScreen();
          },
        ),

        // ADD CERTIFICATION
        GoRoute(
          path: '/add',
          builder: (context, state) {
            return const AddCertificationScreen();
          },
        ),

        // CERTIFICATION DETAILS
        GoRoute(
          path: '/details/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;

            return DetailsScreen(
              id: id,
            );
          },
        ),
      ],
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,

      title: 'CertVault',

      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: blue,
          brightness: Brightness.light,
        ),

        scaffoldBackgroundColor: navy,

        appBarTheme: const AppBarTheme(
          backgroundColor: navy,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(18),
            ),
            borderSide: BorderSide.none,
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: cyan,
            foregroundColor: navy,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      ),

      routerConfig: router,
    );
  }
}

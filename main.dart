import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'add_certification_screen.dart';
import 'details_screen.dart';
import 'home_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: CertVaultApp(),
    ),
  );
}

class CertVaultApp extends StatelessWidget {
  const CertVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) {
            return const HomeScreen();
          },
        ),

        GoRoute(
          path: '/add',
          builder: (context, state) {
            return const AddCertificationScreen();
          },
        ),

        GoRoute(
          path: '/details/:id',
          builder: (context, state) {
            final String id = state.pathParameters['id']!;

            return DetailsScreen(
              id: id,
            );
          },
        ),
      ],
    );

    return MaterialApp.router(
      title: 'CertVault',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
      ),
      routerConfig: router,
    );
  }
}

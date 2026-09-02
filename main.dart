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

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
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
            final id = state.pathParameters['id']!;

            return DetailsScreen(id: id);
          },
        ),
      ],
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'CertVault',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff2864d7),
        ),
      ),
      routerConfig: router,
    );
  }
}
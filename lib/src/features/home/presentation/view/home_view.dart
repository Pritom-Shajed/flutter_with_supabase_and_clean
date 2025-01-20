import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_with_supabase/src/features/auth/presentation/provider/auth_provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  static const String name = 'home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          Consumer(
            builder: (context, ref, child) {
              ref.watch(authProvider);
              final notifier = ref.watch(authProvider.notifier);
              return IconButton(
                onPressed: () async => await notifier.signOut(context),
                icon: const Icon(Icons.logout),
              ); // Replace with your widget
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Home'),
      ),
    );
  }
}

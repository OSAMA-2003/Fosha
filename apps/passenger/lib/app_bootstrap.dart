import 'package:flutter/material.dart';
import 'package:fosha_shared/fosha_shared.dart';

import 'firebase_options.dart';

class AppBootstrap extends StatelessWidget {
  const AppBootstrap({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseBootstrap.ensureInitialized(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snap) {
        if (snap.hasError) {
          return FoshaApp(
            title: 'فسحة للركاب',
            home: _BootstrapError(error: snap.error),
          );
        }
        if (snap.connectionState != ConnectionState.done) {
          return const FoshaApp(
            title: 'فسحة للركاب',
            home: _BootstrapLoading(),
          );
        }
        return child;
      },
    );
  }
}

class _BootstrapLoading extends StatelessWidget {
  const _BootstrapLoading();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class _BootstrapError extends StatelessWidget {
  const _BootstrapError({this.error});

  final Object? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'إعداد Firebase غير مكتمل',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              error?.toString() ?? '',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}


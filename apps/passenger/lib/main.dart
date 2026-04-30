import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fosha_shared/fosha_shared.dart';

import 'app_bootstrap.dart';
import 'src/core/router/app_router.dart';

void main() {
  runApp(const ProviderScope(child: PassengerApp()));
}

class PassengerApp extends StatelessWidget {
  const PassengerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBootstrap(child: const _PassengerAppShell());
  }
}

class _PassengerAppShell extends ConsumerWidget {
  const _PassengerAppShell();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(passengerRouterProvider);
    return FoshaApp(
      title: 'فسحة للركاب',
      routerConfig: router,
    );
  }
}

class PassengerHomeScreen extends StatelessWidget {
  const PassengerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('فسحة للركاب')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'أهلاً بك في فسحة',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            const ArabicIndicText('المدن المتاحة: 3 (أسيوط، سوهاج، قنا)'),
            const SizedBox(height: 12),
            ArabicIndicText('مثال تسعير: ${ArabicIndic.moneyEgp(52.5)}'),
            const Spacer(),
            FilledButton(
              onPressed: () {},
              child: const Text('ابدأ طلب رحلة'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fosha_shared/fosha_shared.dart';

import 'app_bootstrap.dart';
import 'src/core/router/app_router.dart';

void main() {
  runApp(const ProviderScope(child: AdminApp()));
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBootstrap(child: const _AdminAppShell());
  }
}

class _AdminAppShell extends ConsumerWidget {
  const _AdminAppShell();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(adminRouterProvider);
    return FoshaApp(
      title: 'لوحة تحكم فسحة',
      routerConfig: router,
    );
  }
}

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('لوحة التحكم')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('مؤشرات فورية', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 12),
            const ArabicIndicText('الرحلات النشطة: ١٢'),
            const ArabicIndicText('السائقون المتصلون: ٣٤'),
            const ArabicIndicText('إيراد اليوم: ٢٬٤٥٠ ج.م'),
            const Spacer(),
            FilledButton(
              onPressed: () {},
              child: const Text('فتح لوحة SOS'),
            ),
          ],
        ),
      ),
    );
  }
}

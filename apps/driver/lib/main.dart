import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fosha_shared/fosha_shared.dart';

import 'app_bootstrap.dart';
import 'src/core/router/app_router.dart';

void main() {
  runApp(const ProviderScope(child: DriverApp()));
}

class DriverApp extends StatelessWidget {
  const DriverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBootstrap(child: const _DriverAppShell());
  }
}

class _DriverAppShell extends ConsumerWidget {
  const _DriverAppShell();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(driverRouterProvider);
    return FoshaApp(
      title: 'فسحة للسواقين',
      routerConfig: router,
    );
  }
}

class DriverHomeScreen extends StatelessWidget {
  const DriverHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('فسحة للسواقين')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('خطوة أولى: صلاحيات الموقع (Always Allow)'),
            const SizedBox(height: 12),
            const ArabicIndicText('الرصيد الحالي (مثال): -١٠٠ ج.م'),
            const Spacer(),
            FilledButton(
              onPressed: () {},
              child: const Text('إرشادات تفعيل التتبع'),
            ),
          ],
        ),
      ),
    );
  }
}

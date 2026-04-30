import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fosha_shared/fosha_shared.dart';
import 'package:go_router/go_router.dart';

import '../../providers/admin_providers.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kpi = ref.watch(kpiProvider);
    return FoshaScaffold(
      appBar: AppBar(title: const Text('لوحة التحكم')),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('لوحة التحكم — مؤشرات فورية', style: TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          kpi.when(
            data: (data) {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _KpiTile(
                          title: 'رحلات الآن',
                          value: ArabicIndic.intValue(data['activeTrips'] ?? 0),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: _KpiTile(title: 'سواقين متاحين', value: '٠'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const _KpiTile(title: 'إيراد اليوم', value: '٠ ج.م'),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text(e.toString()),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 54,
                  child: OutlinedButton(
                    onPressed: () => context.go('/sos'),
                    child: const Text('لوحة SOS'),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 54,
                  child: FilledButton(
                    onPressed: () => context.go('/pricing'),
                    child: const Text('التسعير والعروض'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _KpiTile extends StatelessWidget {
  const _KpiTile({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return FoshaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: FoshaColors.primaryPink,
            ),
          ),
        ],
      ),
    );
  }
}


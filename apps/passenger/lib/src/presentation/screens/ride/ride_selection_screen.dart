import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fosha_shared/fosha_shared.dart';
import 'package:go_router/go_router.dart';

import '../../providers/pricing_providers.dart';
import '../../providers/ride_flow_provider.dart';

class RideSelectionScreen extends ConsumerWidget {
  const RideSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rideType = ref.watch(selectedRideTypeProvider);
    final payment = ref.watch(selectedPaymentMethodProvider);
    final surgeAsync = ref.watch(surgeConfigProvider);

    // Stub distance/time until routing service is added.
    const distanceKm = 3.2;
    const durationMin = 12.0;
    final now = DateTime.now();
    final surge = surgeAsync.value ?? PricingEngine.defaultSurge;

    final xFare = PricingEngine.calculate(
      rideType: RideType.x,
      distanceKm: distanceKm,
      durationMinutes: durationMin,
      whenLocal: now,
      surge: surge,
    );
    final cFare = PricingEngine.calculate(
      rideType: RideType.comfort,
      distanceKm: distanceKm,
      durationMinutes: durationMin,
      whenLocal: now,
      surge: surge,
    );

    final isSurge = surge.isSurgeActive(now);

    return FoshaScaffold(
      appBar: AppBar(title: const Text('اختيار الفسحة')),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FoshaCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ArabicIndicText('المسافة: $distanceKm كم • الوقت: $durationMin دقيقة'),
                const SizedBox(height: 10),
                _RideCard(
                  title: 'فسحة X',
                  subtitle: 'اقتصادي',
                  selected: rideType == RideType.x,
                  price: xFare.totalArabicEgp(),
                  showSurge: isSurge,
                  onTap: () => ref.read(selectedRideTypeProvider.notifier).state = RideType.x,
                ),
                const SizedBox(height: 10),
                _RideCard(
                  title: 'فسحة Comfort',
                  subtitle: 'أوسع و أريح',
                  selected: rideType == RideType.comfort,
                  price: cFare.totalArabicEgp(),
                  showSurge: isSurge,
                  onTap: () => ref
                      .read(selectedRideTypeProvider.notifier)
                      .state = RideType.comfort,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          FoshaCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('طريقة الدفع', style: TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _PaymentChip(
                      label: 'كاش 💵',
                      selected: payment == PaymentMethod.cash,
                      onTap: () => ref.read(selectedPaymentMethodProvider.notifier).state =
                          PaymentMethod.cash,
                    ),
                    _PaymentChip(
                      label: 'فودافون كاش 📱',
                      selected: payment == PaymentMethod.vodafoneCash,
                      onTap: () => ref
                          .read(selectedPaymentMethodProvider.notifier)
                          .state = PaymentMethod.vodafoneCash,
                    ),
                    _PaymentChip(
                      label: 'إنستا باي 🏦',
                      selected: payment == PaymentMethod.instapay,
                      onTap: () => ref
                          .read(selectedPaymentMethodProvider.notifier)
                          .state = PaymentMethod.instapay,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          SizedBox(
            height: 54,
            child: FilledButton(
              onPressed: () => context.go('/matching'),
              child: const Text('تأكيد الفسحة 🚗'),
            ),
          ),
        ],
      ),
    );
  }
}

class _RideCard extends StatelessWidget {
  const _RideCard({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.selected,
    required this.onTap,
    required this.showSurge,
  });

  final String title;
  final String subtitle;
  final String price;
  final bool selected;
  final VoidCallback onTap;
  final bool showSurge;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOutCubic,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: FoshaColors.surfaceAlt.withValues(alpha: 0.70),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? FoshaColors.primaryPink : Colors.white12,
            width: selected ? 2.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.directions_car_rounded, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                      if (showSurge)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: FoshaColors.highlightOrange.withValues(alpha: 0.22),
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: FoshaColors.highlightOrange.withValues(alpha: 0.4),
                            ),
                          ),
                          child: const Text(
                            '×٢ ذروة',
                            style: TextStyle(
                              color: FoshaColors.highlightOrange,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(color: Colors.white60)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              price,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: FoshaColors.primaryPink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentChip extends StatelessWidget {
  const _PaymentChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? FoshaColors.primaryPink.withValues(alpha: 0.18)
              : Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: selected ? FoshaColors.primaryPink : Colors.white12,
          ),
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
      ),
    );
  }
}


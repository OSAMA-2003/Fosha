import 'package:flutter/material.dart';
import 'package:fosha_shared/fosha_shared.dart';

class PaymentRatingScreen extends StatefulWidget {
  const PaymentRatingScreen({super.key});

  @override
  State<PaymentRatingScreen> createState() => _PaymentRatingScreenState();
}

class _PaymentRatingScreenState extends State<PaymentRatingScreen> {
  int rating = 5;

  @override
  Widget build(BuildContext context) {
    final fare = PricingEngine.calculate(
      rideType: RideType.x,
      distanceKm: 3.2,
      durationMinutes: 12,
      whenLocal: DateTime.now(),
      surge: PricingEngine.defaultSurge,
    );

    return FoshaScaffold(
      appBar: AppBar(title: const Text('وصلت!')),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          const Center(
            child: Icon(Icons.check_circle, size: 72, color: Colors.greenAccent),
          ),
          const SizedBox(height: 10),
          const Text(
            'وصلت! 🎉',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 16),
          FoshaCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Row('الأساس', PricingEngine.formatEgp(fare.base)),
                _Row('المسافة', PricingEngine.formatEgp(fare.distanceFare)),
                _Row('الوقت', PricingEngine.formatEgp(fare.timeFare)),
                _Row('خدمة ١٠٪', PricingEngine.formatEgp(fare.serviceFee)),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: FoshaColors.primaryPink.withValues(alpha: 0.20),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'الإجمالي',
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                      Text(
                        fare.totalArabicEgp(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: FoshaColors.primaryPink,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'قيّم الرحلة',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final v = i + 1;
              final active = v <= rating;
              return IconButton(
                onPressed: () => setState(() => rating = v),
                icon: Icon(
                  active ? Icons.star_rounded : Icons.star_border_rounded,
                  color: active ? FoshaColors.highlightOrange : Colors.white24,
                  size: 34,
                ),
              );
            }),
          ),
          const Spacer(),
          SizedBox(
            height: 54,
            child: FilledButton(
              onPressed: () {},
              child: const Text('إرسال التقييم'),
            ),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: Colors.white70))),
          Text(value, style: const TextStyle(color: FoshaColors.highlightOrange)),
        ],
      ),
    );
  }
}


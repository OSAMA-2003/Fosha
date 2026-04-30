import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fosha_shared/fosha_shared.dart';

class PricingPromoManagementScreen extends StatefulWidget {
  const PricingPromoManagementScreen({super.key});

  @override
  State<PricingPromoManagementScreen> createState() =>
      _PricingPromoManagementScreenState();
}

class _PricingPromoManagementScreenState
    extends State<PricingPromoManagementScreen> {
  bool saving = false;

  @override
  Widget build(BuildContext context) {
    final pricingRef = FirebaseFirestore.instance.collection('config').doc('pricing');

    return FoshaScaffold(
      appBar: AppBar(title: const Text('التسعير والعروض')),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: pricingRef.snapshots(),
            builder: (context, snap) {
              final data = snap.data?.data() ?? const {};
              final surgeMult = (data['surgeMultiplier'] as num?)?.toDouble() ?? 2.0;
              final isSurge = (data['isSurgeActive'] as bool?) ?? false;
              return FoshaCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('الذروة (Surge)', style: TextStyle(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 10),
                    SwitchListTile(
                      value: isSurge,
                      onChanged: (v) => pricingRef.set({'isSurgeActive': v}, SetOptions(merge: true)),
                      title: const Text('تفعيل الذروة'),
                    ),
                    const SizedBox(height: 6),
                    Text('المضاعف الحالي: ×$surgeMult'),
                    const SizedBox(height: 10),
                    FilledButton(
                      onPressed: saving
                          ? null
                          : () async {
                              setState(() => saving = true);
                              await pricingRef.set(
                                {'surgeMultiplier': 2.0, 'surgeHours': _defaultSurgeHours()},
                                SetOptions(merge: true),
                              );
                              if (mounted) setState(() => saving = false);
                            },
                      child: const Text('إعادة ضبط إعدادات الذروة'),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection('promos').snapshots(),
              builder: (context, snap) {
                final docs = snap.data?.docs ?? const [];
                return FoshaCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('الأكواد والعروض', style: TextStyle(fontWeight: FontWeight.w900)),
                      const SizedBox(height: 10),
                      if (docs.isEmpty)
                        const Text('مفيش عروض حالياً', style: TextStyle(color: Colors.white70))
                      else
                        ...docs.map((d) {
                          final code = d.id;
                          final discount = d.data()['discount']?.toString() ?? '';
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                Expanded(child: Text(code)),
                                Text(discount, style: const TextStyle(color: FoshaColors.highlightOrange)),
                              ],
                            ),
                          );
                        }),
                      const Spacer(),
                      FilledButton(
                        onPressed: () async {
                          final ref = FirebaseFirestore.instance.collection('promos').doc('FOSHA20');
                          await ref.set({'discount': 20, 'type': 'percent'});
                        },
                        child: const Text('إضافة عرض تجريبي'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, int>> _defaultSurgeHours() {
    return const [
      {'start': 480, 'end': 600},
      {'start': 840, 'end': 960},
      {'start': 1200, 'end': 1380},
    ];
  }
}


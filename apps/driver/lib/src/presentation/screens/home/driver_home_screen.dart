import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fosha_shared/fosha_shared.dart';
import 'package:go_router/go_router.dart';

import '../../../data/repositories/trip_repository.dart';

final _driverTripRepoProvider = Provider<DriverTripRepository>((ref) {
  return DriverTripRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  );
});

class DriverHomeScreen extends ConsumerStatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  ConsumerState<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends ConsumerState<DriverHomeScreen> {
  String city = 'asyut';
  bool accepting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الرئيسية')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('حالتك: غير متاح'),
            const SizedBox(height: 12),
            const ArabicIndicText('الأرباح اليوم: ٠ ج.م'),
            const SizedBox(height: 12),
            InputDecorator(
              decoration: const InputDecoration(labelText: 'المدينة'),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: city,
                  items: const [
                    DropdownMenuItem(value: 'asyut', child: Text('أسيوط')),
                    DropdownMenuItem(value: 'sohag', child: Text('سوهاج')),
                    DropdownMenuItem(value: 'qena', child: Text('قنا')),
                  ],
                  onChanged: (v) => setState(() => city = v ?? 'asyut'),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: StreamBuilder<List<Trip>>(
                stream: ref
                    .read(_driverTripRepoProvider)
                    .watchSearchingTrips(city: city),
                builder: (context, snap) {
                  final trips = snap.data ?? const <Trip>[];
                  if (trips.isEmpty) {
                    return const Center(child: Text('مفيش طلبات دلوقتي'));
                  }
                  return ListView.separated(
                    itemCount: trips.length,
                    separatorBuilder: (_, index) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final t = trips[i];
                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: FoshaColors.surface,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: FoshaColors.highlightOrange.withValues(alpha: 0.30),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text('طلب جديد • ${t.city}'),
                            const SizedBox(height: 6),
                            Text('من: ${t.pickup.name}'),
                            Text('إلى: ${t.dropoff.name}'),
                            const SizedBox(height: 10),
                            FilledButton(
                              onPressed: accepting ? null : () => _accept(t.id),
                              child: const Text('قبول'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const Spacer(),
            FilledButton(
              onPressed: () => context.go('/incoming'),
              child: const Text('تجربة تنبيه طلب رحلة'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _accept(String tripId) async {
    setState(() => accepting = true);
    try {
      await ref.read(_driverTripRepoProvider).acceptTrip(tripId);
    } finally {
      if (mounted) setState(() => accepting = false);
    }
  }
}


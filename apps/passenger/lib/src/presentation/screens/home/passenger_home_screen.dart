import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fosha_shared/fosha_shared.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../data/repositories/trip_repository.dart';
import '../../providers/city_provider.dart';
import '../../providers/ride_flow_provider.dart';

final _tripRepoProvider = Provider<PassengerTripRepository>((ref) {
  return PassengerTripRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  );
});

class PassengerHomeScreen extends ConsumerStatefulWidget {
  const PassengerHomeScreen({super.key});

  @override
  ConsumerState<PassengerHomeScreen> createState() => _PassengerHomeScreenState();
}

class _PassengerHomeScreenState extends ConsumerState<PassengerHomeScreen> {
  String? lastTripId;
  bool creating = false;

  @override
  Widget build(BuildContext context) {
    final city = ref.watch(selectedCityProvider);
    return Scaffold(
      body: Stack(
        children: [
          const GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(27.180, 31.183),
              zoom: 13,
            ),
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: FoshaColors.surface.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text('فسحة'),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: FoshaColors.highlightOrange.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      switch (city) {
                        FoshaCity.asyut => 'أسيوط',
                        FoshaCity.sohag => 'سوهاج',
                        FoshaCity.qena => 'قنا',
                        _ => 'اختار مدينة',
                      },
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.38,
            minChildSize: 0.18,
            maxChildSize: 0.80,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: FoshaColors.backgroundPurple.withValues(alpha: 0.95),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    Center(
                      child: Container(
                        width: 44,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        color: FoshaColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: FoshaColors.primaryPink.withValues(alpha: 0.25),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.search, color: FoshaColors.primaryPink),
                          SizedBox(width: 10),
                          Expanded(child: Text('إنت رايح فين؟')),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    if (lastTripId != null) ...[
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection(FsPaths.trips)
                            .doc(lastTripId)
                            .snapshots(),
                        builder: (context, snap) {
                          final data = snap.data?.data();
                          final status = data?['status']?.toString() ?? '...';
                          final fare = PricingEngine.calculate(
                            rideType: RideType.x,
                            distanceKm: 3.2,
                            durationMinutes: 12,
                            whenLocal: DateTime.now(),
                            surge: PricingEngine.defaultSurge,
                          );
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ArabicIndicText('حالة الرحلة: $status'),
                              ArabicIndicText('سعر تقديري: ${fare.totalArabicEgp()}'),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () => context.go('/chat/$lastTripId'),
                                      child: const Text('💬 راسل'),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: FilledButton(
                                      onPressed: () => _sos(lastTripId!),
                                      child: const Text('🛡️ SOS'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                    ],
                    FilledButton(
                      onPressed: creating || city == null
                          ? null
                          : () async {
                              await _createTrip();
                              if (!context.mounted) return;
                              context.go('/ride');
                            },
                      child: creating
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('تأكيد الفسحة 🚗'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _createTrip() async {
    final city = ref.read(selectedCityProvider);
    if (city == null) return;

    setState(() => creating = true);
    try {
      final cityId = switch (city) {
        FoshaCity.asyut => 'asyut',
        FoshaCity.sohag => 'sohag',
        FoshaCity.qena => 'qena',
      };
      final repo = ref.read(_tripRepoProvider);
      final tripId = await repo.createTrip(
        city: cityId,
        pickup: const GeoPlace(name: 'نقطة الالتقاط', lat: 27.180, lng: 31.183),
        dropoff: const GeoPlace(name: 'الوجهة', lat: 27.190, lng: 31.200),
        rideType: RideType.x,
      );
      if (!mounted) return;
      setState(() => lastTripId = tripId);
      ref.read(currentTripIdProvider.notifier).state = tripId;
    } finally {
      if (mounted) setState(() => creating = false);
    }
  }

  Future<void> _sos(String tripId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    await FirebaseFirestore.instance.collection('sos').doc(tripId).set({
      'tripId': tripId,
      'passengerId': uid,
      'status': 'open',
      'createdAtMillis': DateTime.now().millisecondsSinceEpoch,
    }, SetOptions(merge: true));
  }
}


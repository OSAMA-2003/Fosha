import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final kpiProvider = StreamProvider<Map<String, int>>((ref) {
  final db = ref.watch(firestoreProvider);
  // Lightweight KPI approximation until aggregation is added:
  // activeTrips = trips where status in (searching/accepted/inProgress)
  return db.collection('trips').snapshots().map((snap) {
    var active = 0;
    for (final d in snap.docs) {
      final s = (d.data() as Map)['status']?.toString();
      if (s == 'searching' || s == 'accepted' || s == 'inProgress') active++;
    }
    return {'activeTrips': active, 'onlineDrivers': 0, 'dailyRevenue': 0};
  });
});


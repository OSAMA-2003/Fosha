import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fosha_shared/fosha_shared.dart';

class PricingRepository {
  PricingRepository(this._db);
  final FirebaseFirestore _db;

  Stream<SurgeConfig> watchSurgeConfig({required String city}) {
    return _db.collection(FsPaths.config).doc('pricing').snapshots().map((s) {
      final data = s.data();
      final mult = (data?['surgeMultiplier'] as num?)?.toDouble() ?? 2.0;
      final hours = (data?['surgeHours'] as List?)?.cast<Map>() ?? const [];
      final ranges = hours
          .map((h) {
            final start = (h['start'] as num?)?.toInt();
            final end = (h['end'] as num?)?.toInt();
            if (start == null || end == null) return null;
            return TimeRange(start, end);
          })
          .whereType<TimeRange>()
          .toList(growable: false);
      return SurgeConfig(multiplier: mult, activeRanges: ranges);
    });
  }
}


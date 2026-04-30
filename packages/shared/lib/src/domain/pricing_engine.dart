import 'package:intl/intl.dart';

import '../formatting/arabic_indic.dart';
import '../models/trip.dart';

class PricingConfig {
  const PricingConfig({
    required this.baseFareEgp,
    required this.pricePerKmEgp,
    required this.pricePerMinEgp,
  });

  final double baseFareEgp;
  final double pricePerKmEgp;
  final double pricePerMinEgp;
}

class SurgeConfig {
  const SurgeConfig({
    required this.multiplier,
    required this.activeRanges,
  });

  final double multiplier;
  final List<TimeRange> activeRanges;

  bool isSurgeActive(DateTime whenLocal) {
    final minutes = whenLocal.hour * 60 + whenLocal.minute;
    return activeRanges.any((r) => r.contains(minutes));
  }
}

class TimeRange {
  const TimeRange(this.startMinutes, this.endMinutes);
  final int startMinutes; // inclusive
  final int endMinutes; // exclusive

  bool contains(int minutes) => minutes >= startMinutes && minutes < endMinutes;
}

class FareBreakdown {
  const FareBreakdown({
    required this.base,
    required this.distanceFare,
    required this.timeFare,
    required this.surgeMult,
    required this.serviceFee,
    required this.total,
  });

  final double base;
  final double distanceFare;
  final double timeFare;
  final double surgeMult;
  final double serviceFee; // 10%
  final double total;

  String totalArabicEgp() => ArabicIndic.moneyEgp(total);
}

abstract final class PricingEngine {
  static const PricingConfig foshaX = PricingConfig(
    baseFareEgp: 10,
    pricePerKmEgp: 5,
    pricePerMinEgp: 0.5,
  );

  static const PricingConfig foshaComfort = PricingConfig(
    baseFareEgp: 15,
    pricePerKmEgp: 8,
    pricePerMinEgp: 1.0,
  );

  static final SurgeConfig defaultSurge = SurgeConfig(
    multiplier: 2.0,
    activeRanges: const [
      TimeRange(8 * 60, 10 * 60),
      TimeRange(14 * 60, 16 * 60),
      TimeRange(20 * 60, 23 * 60),
    ],
  );

  static FareBreakdown calculate({
    required RideType rideType,
    required double distanceKm,
    required double durationMinutes,
    required DateTime whenLocal,
    SurgeConfig surge = const SurgeConfig(multiplier: 1.0, activeRanges: []),
  }) {
    final cfg = rideType == RideType.comfort ? foshaComfort : foshaX;
    final base = cfg.baseFareEgp;
    final distanceFare = distanceKm * cfg.pricePerKmEgp;
    final timeFare = durationMinutes * cfg.pricePerMinEgp;

    final raw = base + distanceFare + timeFare;
    final surgeMult = surge.isSurgeActive(whenLocal) ? surge.multiplier : 1.0;

    final surged = raw * surgeMult;
    final serviceFee = surged * 0.10;
    final total = surged + serviceFee;

    return FareBreakdown(
      base: _round2(base),
      distanceFare: _round2(distanceFare),
      timeFare: _round2(timeFare),
      surgeMult: surgeMult,
      serviceFee: _round2(serviceFee),
      total: _round2(total),
    );
  }

  static String formatEgp(double amount) {
    final formatted = NumberFormat.currency(
      locale: 'ar_EG',
      symbol: 'ج.م',
      decimalDigits: 2,
    ).format(amount);
    return ArabicIndic.digits(formatted);
  }

  static double _round2(double v) => (v * 100).roundToDouble() / 100;
}


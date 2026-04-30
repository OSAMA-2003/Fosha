import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fosha_shared/fosha_shared.dart';

import '../../data/repositories/pricing_repository.dart';
import 'city_provider.dart';

final pricingRepositoryProvider = Provider<PricingRepository>((ref) {
  return PricingRepository(FirebaseFirestore.instance);
});

final surgeConfigProvider = StreamProvider<SurgeConfig>((ref) {
  final city = ref.watch(selectedCityProvider);
  final cityId = switch (city) {
    FoshaCity.asyut => 'asyut',
    FoshaCity.sohag => 'sohag',
    FoshaCity.qena => 'qena',
    _ => 'asyut',
  };
  return ref.watch(pricingRepositoryProvider).watchSurgeConfig(city: cityId);
});


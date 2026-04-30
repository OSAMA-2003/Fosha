import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum FoshaCity { asyut, sohag, qena }

extension on FoshaCity {
  String get storage => switch (this) {
        FoshaCity.asyut => 'asyut',
        FoshaCity.sohag => 'sohag',
        FoshaCity.qena => 'qena',
      };
}

final selectedCityProvider =
    StateNotifierProvider<SelectedCityNotifier, FoshaCity?>((ref) {
  return SelectedCityNotifier();
});

class SelectedCityNotifier extends StateNotifier<FoshaCity?> {
  SelectedCityNotifier() : super(null) {
    _load();
  }

  static const _key = 'fosha_city';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final v = prefs.getString(_key);
    state = switch (v) {
      'asyut' => FoshaCity.asyut,
      'sohag' => FoshaCity.sohag,
      'qena' => FoshaCity.qena,
      _ => null,
    };
  }

  Future<void> setCity(FoshaCity city) async {
    state = city;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, city.storage);
  }
}


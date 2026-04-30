import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fosha_shared/fosha_shared.dart';

enum PaymentMethod { cash, vodafoneCash, instapay }

final currentTripIdProvider = StateProvider<String?>((ref) => null);

final selectedRideTypeProvider = StateProvider<RideType>((ref) => RideType.x);

final selectedPaymentMethodProvider =
    StateProvider<PaymentMethod>((ref) => PaymentMethod.cash);


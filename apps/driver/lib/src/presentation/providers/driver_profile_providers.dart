import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/driver_profile_repository.dart';

final driverProfileRepositoryProvider = Provider<DriverProfileRepository>((ref) {
  return DriverProfileRepository(FirebaseFirestore.instance);
});

final driverProfileProvider = StreamProvider<Map<String, dynamic>?>((ref) {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return const Stream.empty();
  return ref.watch(driverProfileRepositoryProvider).watchDriver(uid);
});


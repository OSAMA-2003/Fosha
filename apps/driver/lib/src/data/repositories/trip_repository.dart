import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fosha_shared/fosha_shared.dart';

class DriverTripRepository {
  DriverTripRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  Stream<List<Trip>> watchSearchingTrips({required String city}) {
    return _firestore
        .collection(FsPaths.trips)
        .where('city', isEqualTo: city)
        .where('status', isEqualTo: TripStatus.searching.json)
        .orderBy('createdAtMillis', descending: true)
        .limit(20)
        .snapshots()
        .map((q) => q.docs
            .map((d) => Trip.fromJson(id: d.id, json: d.data()))
            .toList(growable: false));
  }

  Future<void> acceptTrip(String tripId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw StateError('Not signed in');

    final ref = _firestore.collection(FsPaths.trips).doc(tripId);
    await _firestore.runTransaction((tx) async {
      final snap = await tx.get(ref);
      final data = snap.data();
      if (data == null) throw StateError('Missing trip');
      final status = data['status'] as String?;
      if (status != TripStatus.searching.json) {
        throw StateError('Trip not available');
      }
      tx.update(ref, {
        'status': TripStatus.accepted.json,
        'driverId': uid,
      });
    });
  }
}


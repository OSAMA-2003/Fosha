import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fosha_shared/fosha_shared.dart';

class PassengerTripRepository {
  PassengerTripRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  Future<String> createTrip({
    required String city,
    required GeoPlace pickup,
    required GeoPlace dropoff,
    required RideType rideType,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw StateError('Not signed in');

    final doc = _firestore.collection(FsPaths.trips).doc();
    final trip = Trip(
      id: doc.id,
      passengerId: uid,
      driverId: null,
      city: city,
      pickup: pickup,
      dropoff: dropoff,
      rideType: rideType,
      status: TripStatus.searching,
      createdAtMillis: DateTime.now().millisecondsSinceEpoch,
    );

    await doc.set(trip.toJson());
    return doc.id;
  }

  Stream<Trip?> watchTrip(String tripId) {
    return _firestore.collection(FsPaths.trips).doc(tripId).snapshots().map((s) {
      final data = s.data();
      if (data == null) return null;
      return Trip.fromJson(id: s.id, json: data);
    });
  }
}


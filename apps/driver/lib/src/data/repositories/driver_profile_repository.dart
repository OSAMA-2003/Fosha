import 'package:cloud_firestore/cloud_firestore.dart';

class DriverProfileRepository {
  DriverProfileRepository(this._db);
  final FirebaseFirestore _db;

  Stream<Map<String, dynamic>?> watchDriver(String uid) {
    return _db.collection('drivers').doc(uid).snapshots().map((s) => s.data());
  }
}


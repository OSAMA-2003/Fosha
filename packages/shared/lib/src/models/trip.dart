import 'geo_place.dart';

enum TripStatus {
  searching,
  accepted,
  arriving,
  inProgress,
  completed,
  cancelled,
  noDriver,
}

extension TripStatusJson on TripStatus {
  String get json => switch (this) {
        TripStatus.searching => 'searching',
        TripStatus.accepted => 'accepted',
        TripStatus.arriving => 'arriving',
        TripStatus.inProgress => 'inProgress',
        TripStatus.completed => 'completed',
        TripStatus.cancelled => 'cancelled',
        TripStatus.noDriver => 'no_driver',
      };

  static TripStatus fromJson(String? v) => switch (v) {
        'accepted' => TripStatus.accepted,
        'arriving' => TripStatus.arriving,
        'inProgress' => TripStatus.inProgress,
        'completed' => TripStatus.completed,
        'cancelled' => TripStatus.cancelled,
        'no_driver' => TripStatus.noDriver,
        _ => TripStatus.searching,
      };
}

enum RideType { x, comfort }

extension RideTypeJson on RideType {
  String get json => switch (this) {
        RideType.x => 'x',
        RideType.comfort => 'comfort',
      };

  static RideType fromJson(String? v) => switch (v) {
        'comfort' => RideType.comfort,
        _ => RideType.x,
      };
}

class Trip {
  const Trip({
    required this.id,
    required this.passengerId,
    required this.driverId,
    required this.city,
    required this.pickup,
    required this.dropoff,
    required this.rideType,
    required this.status,
    required this.createdAtMillis,
  });

  final String id;
  final String passengerId;
  final String? driverId;
  final String city; // asyut|sohag|qena
  final GeoPlace pickup;
  final GeoPlace dropoff;
  final RideType rideType;
  final TripStatus status;
  final int createdAtMillis;

  Map<String, Object?> toJson() => {
        'passengerId': passengerId,
        'driverId': driverId,
        'city': city,
        'pickup': pickup.toJson(),
        'dropoff': dropoff.toJson(),
        'rideType': rideType.json,
        'status': status.json,
        'createdAtMillis': createdAtMillis,
      };

  static Trip fromJson({
    required String id,
    required Map<String, Object?> json,
  }) {
    return Trip(
      id: id,
      passengerId: (json['passengerId'] as String?) ?? '',
      driverId: json['driverId'] as String?,
      city: (json['city'] as String?) ?? '',
      pickup: GeoPlace.fromJson((json['pickup'] as Map?)?.cast<String, Object?>() ?? {}),
      dropoff:
          GeoPlace.fromJson((json['dropoff'] as Map?)?.cast<String, Object?>() ?? {}),
      rideType: RideTypeJson.fromJson(json['rideType'] as String?),
      status: TripStatusJson.fromJson(json['status'] as String?),
      createdAtMillis: (json['createdAtMillis'] as num?)?.toInt() ?? 0,
    );
  }
}


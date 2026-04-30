class GeoPlace {
  const GeoPlace({
    required this.name,
    required this.lat,
    required this.lng,
  });

  final String name;
  final double lat;
  final double lng;

  Map<String, Object?> toJson() => {
        'name': name,
        'lat': lat,
        'lng': lng,
      };

  static GeoPlace fromJson(Map<String, Object?> json) {
    return GeoPlace(
      name: (json['name'] as String?) ?? '',
      lat: (json['lat'] as num?)?.toDouble() ?? 0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0,
    );
  }
}


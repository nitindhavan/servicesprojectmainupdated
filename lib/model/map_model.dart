class MapModel {
  const MapModel({
    this.longitude,
    this.latitude,
    this.timestamp,
    this.accuracy,
    this.altitude,
    this.heading,
    this.speed,
    this.speedAccuracy,
    this.floor,
    this.isMocked = false,
  });

  final dynamic latitude;
  final dynamic longitude;
  final DateTime? timestamp;
  final dynamic altitude;
  final dynamic accuracy;
  final dynamic heading;
  final int? floor;
  final num? speed;
  final dynamic speedAccuracy;
  final bool? isMocked;




  static MapModel fromMap(dynamic message) {
    final Map<dynamic, dynamic> positionMap = message;

    return MapModel(
      latitude: positionMap['latitude'],
      longitude: positionMap['longitude'],
      timestamp: positionMap['timestamp']!=null?DateTime.fromMillisecondsSinceEpoch(positionMap['timestamp']):null,
      altitude: positionMap['altitude'] ?? 0.0,
      accuracy: positionMap['accuracy'] ?? 0.0,
      heading: positionMap['heading'] ?? 0.0,
      floor: positionMap['floor'],
      speed: positionMap['speed'] ?? 0.0,
      speedAccuracy: positionMap['speed_accuracy'] ?? 0.0,
      isMocked: positionMap['is_mocked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'longitude': longitude,
        'latitude': latitude,
        'timestamp': timestamp?.millisecondsSinceEpoch,
        'accuracy': accuracy,
        'altitude': altitude,
        'floor': floor,
        'heading': heading,
        'speed': speed,
        'speed_accuracy': speedAccuracy,
        'is_mocked': isMocked,
      };
}

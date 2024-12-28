
import 'package:uuid/uuid.dart';

const uuid = Uuid();


class Place{
  final PlaceLocation location;
  final String id;

  Place({
    required this.location,
    String? id,

  }): id = id ?? uuid.v4();
}
class PlaceLocation {
  final double latitude;
  final double longitude;
  final String address;

  PlaceLocation({
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  @override
  String toString() {
    return 'PlaceLocation(latitude: $latitude, longitude: $longitude, address: $address)';
  }
}

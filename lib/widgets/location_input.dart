import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';

import 'package:findmyfriend/models/location.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectLocation});

  final void Function(PlaceLocation location) onSelectLocation;

  @override
  State<LocationInput> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  PlaceLocation? fetchedLocation;
  var _isGettingLocation = false;

  String get locationImage {
    if (_pickedLocation == null) {
      return '';
    }
    final lat = _pickedLocation!.latitude;
    final lng = _pickedLocation!.longitude;

    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=16&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:A%7C$lat,$lng&key=AIzaSyATlaGdu5YMbJHiF6hx5pq280UTUUe0ICc';
  }
  String get locationImage2 {
    if (fetchedLocation == null) {
      return '';
    }
    final lat = fetchedLocation!.latitude;
    final lng = fetchedLocation!.longitude;

    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=16&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:A%7C$lat,$lng&key=AIzaSyATlaGdu5YMbJHiF6hx5pq280UTUUe0ICc';
  }

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
          print('Location services are disabled.');
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
         print('Location permission not granted.');
        return;
      }
    }
    setState(() {
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();

    final lat = locationData.latitude;
    final lng = locationData.longitude;

    if (lat == null || lng == null) {
      setState(() {
        
          _isGettingLocation = false;
        });
        return;
    };
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=37.4219983,-122.084&key=AIzaSyATlaGdu5YMbJHiF6hx5pq280UTUUe0ICc');
      try{
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final resdata = jsonDecode(response.body);

      if(resdata['results'] != null && resdata['results'].isNotEmpty){
      final address = resdata['results'][0]['formatted_address'];

      setState(() {
        _pickedLocation = PlaceLocation(
          latitude: lat,
          longitude: lng,
          address: address,
        );
        _isGettingLocation = false;
      });

      widget.onSelectLocation(_pickedLocation!);
       print('Picked location: $_pickedLocation');
       _sendLocationToFirebase(_pickedLocation!);
       

        
    } else {
      print('No results found in API response.');
       setState(() {
          _isGettingLocation = false;
        });
       ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No address found for the location.')),
        );
    }
  }else {
      // Handle HTTP error
       print('HTTP Error: ${response.statusCode}');
      setState(() {
        _isGettingLocation = false;
      });
      throw Exception('Failed to fetch location data: ${response.statusCode}');
    }
  } catch (error) {
     print('Error occurred: $error');
    setState(() {
      _isGettingLocation = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('An error occurred: $error')),
    );
  }
}
void _sendLocationToFirebase(PlaceLocation location) async {
    try {
      final databaseReference = FirebaseDatabase.instance.ref();
      final userId = 'user_id';

      final locationRef = databaseReference.child('users/$userId/latest_location');
      await locationRef.set({
        'latitude': location.latitude,
        'longitude': location.longitude,
        'address': location.address,
        'timestamp': DateTime.now().toIso8601String(),
      });

      print('Location data sent to Firebase.');
    } catch (error) {
      print('Error sending location to Firebase: $error');
    }
  }
  

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      'No Location Chosen',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
    );
  void _fetchLocationFromFirebase() async {
  try {
    final databaseReference = FirebaseDatabase.instance.ref();
    final userId = 'user'; 

    final locationRef = databaseReference.child('users/$userId/location');

    final snapshot = await locationRef.get();

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      final PlaceLocation fetchedLocation = PlaceLocation(
        latitude: data['latitude'],
        longitude: data['longitude'],
        address: data['address'],
      );


       print('Location fetched from firebase');
      print('Fetched Location: $fetchedLocation');
    } else {
      print('No location data found for user.');
    }
  } catch (error) {
    print('Error fetching location from Firebase: $error');
  }
}

    if (_pickedLocation != null) {
      previewContent = Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );

      Text(
        'Latitude: ${_pickedLocation!.latitude}, Longitude: ${_pickedLocation!.longitude}',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
      );
    }

    if (_isGettingLocation) {
      previewContent = CircularProgressIndicator();
    }

    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(
            width: 1,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          )),
          child: previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.location_on,size: 25,),
              label: const Text('Get User A Location',),
              onPressed: _getCurrentLocation,
            ),
            TextButton.icon(
              icon: const Icon(Icons.add_location_alt,size: 25,),
              label: const Text('Get User B Location '),
              onPressed: _fetchLocationFromFirebase,
            ),
          ],
        ),
      ],
    );
  }
}

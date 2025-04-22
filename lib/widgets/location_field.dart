import 'dart:convert';

import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/map.dart';
import "package:flutter/material.dart";
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

const kGoogleMapsUrl = String.fromEnvironment('GMAPS_URL');
const kGoogleMapsKey = String.fromEnvironment('GMAPS_KEY');

class LocationField extends StatefulWidget {
  const LocationField({
    super.key,
    required this.onChanged,
    required this.value,
  });
  final void Function(PlaceLocation) onChanged;
  final PlaceLocation? value;

  @override
  State<LocationField> createState() => _LocationFieldState();
}

class _LocationFieldState extends State<LocationField> {
  bool _gettingLocation = false;

  String get locationImageUrl {
    final lat = widget.value!.latitude;
    final long = widget.value!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$long'
        '&zoom=14&size=600x300&markers=color:red%7C$lat,$long&key=$kGoogleMapsKey';
  }

  Future<LocationData?> getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (serviceEnabled) {
        return null;
      }
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    return location.getLocation();
  }

  void savePlace(double latitude, double longitude) async {
    final geocodeUrl = Uri.parse('$kGoogleMapsUrl'
        '?latlng=$latitude,$longitude'
        '&key=$kGoogleMapsKey'
        // '&result_type=street_address'
        );

    final response = await http.get(geocodeUrl);
    final resBody = json.decode(response.body);
    final address = resBody['results'][0]['formatted_address'];

    final placeLocation = PlaceLocation(
      latitude: latitude,
      longitude: longitude,
      address: address,
    );
    setState(() {
      _gettingLocation = false;
    });
    widget.onChanged(placeLocation);
  }

  void chooseCurrentLocation() async {
    setState(() {
      _gettingLocation = true;
    });

    final loc = await getCurrentLocation();
    if (loc == null) return;
    final latitude = loc.latitude;
    final longitude = loc.longitude;

    if (latitude == null || longitude == null) return;
    savePlace(latitude, longitude);
  }

  void chooseCustomLocation() async {
    setState(() {
      _gettingLocation = true;
    });
    final currectLocation = await getCurrentLocation();
    final initLocation = (currectLocation == null ||
            currectLocation.latitude == null ||
            currectLocation.longitude == null)
        ? const PlaceLocation(latitude: 100, longitude: 100, address: '')
        : PlaceLocation(
            latitude: currectLocation.latitude!,
            longitude: currectLocation.longitude!,
            address: '');
    if (context.mounted) {
      final location =
          await Navigator.of(context).push<LatLng>(MaterialPageRoute(
        builder: (ctx) => MapScreen(location: initLocation),
      ));
      if (location != null) {
        savePlace(location.latitude, location.longitude);
      }
    }
    setState(() {
      _gettingLocation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = _gettingLocation
        ? const CircularProgressIndicator()
        : widget.value == null
            ? Text(
                'No location!',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              )
            : Image.network(
                locationImageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              );
    return Column(
      children: [
        Container(
            height: 250,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(.2),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: content),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: chooseCurrentLocation,
              label: const Text('Current Location'),
              icon: const Icon(Icons.location_on),
            ),
            TextButton.icon(
              onPressed: chooseCustomLocation,
              label: const Text('Choose a location'),
              icon: const Icon(Icons.map),
            ),
          ],
        ),
      ],
    );
  }
}

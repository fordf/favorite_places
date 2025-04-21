import 'dart:convert';

import 'package:favorite_places/models/place.dart';
import "package:flutter/material.dart";
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

const kGoogleMapsUrl = String.fromEnvironment('GMAPS_URL');
const kGoogleMapsKey = String.fromEnvironment('GMAPS_KEY');

class LocationField extends StatefulWidget {
  const LocationField(
      {super.key, required this.onChooseLocation, required this.location});
  final void Function(PlaceLocation) onChooseLocation;
  final PlaceLocation? location;

  @override
  State<LocationField> createState() => _LocationFieldState();
}

class _LocationFieldState extends State<LocationField> {
  bool _gettingLocation = false;

  String get locationImageUrl {
    final lat = widget.location!.latitude;
    final long = widget.location!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$long'
        '&zoom=14&size=600x300&markers=color:red%7C$lat,$long&key=$kGoogleMapsKey';
  }

  void getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData loc;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _gettingLocation = true;
    });

    loc = await location.getLocation();
    final latitude = loc.latitude;
    final longitude = loc.longitude;

    if (latitude == null || longitude == null) return;

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
    widget.onChooseLocation(placeLocation);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = _gettingLocation
        ? const CircularProgressIndicator()
        : widget.location == null
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
              // image: file == null
              //     ? null
              //     : DecorationImage(
              //         image: FileImage(file!),
              //         fit: BoxFit.cover,
              //       ),
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
              onPressed: getCurrentLocation,
              label: const Text('Current Location'),
              icon: const Icon(Icons.location_on),
            ),
            TextButton.icon(
              onPressed: () {},
              label: const Text('Choose a location'),
              icon: const Icon(Icons.map),
            ),
          ],
        ),
      ],
    );
  }
}

class LocationFormField extends FormField<PlaceLocation> {
  final Color? errorColor;
  LocationFormField({
    super.key,
    required this.errorColor,
    FormFieldValidator<PlaceLocation>? validator,
    super.onSaved,
  }) : super(
          validator: validator,
          builder: (field) {
            void onChangedHandler(PlaceLocation? value) {
              print(value!.address.toString());
              field.didChange(value);
            }

            bool isError = errorColor != null && !field.isValid;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: isError
                      ? BoxDecoration(
                          border: Border.all(color: errorColor),
                          borderRadius: BorderRadius.circular(8),
                        )
                      : null,
                  child: LocationField(
                    onChooseLocation: onChangedHandler,
                    location: field.value,
                  ),
                ),
                field.isValid
                    ? const SizedBox(
                        height: 15,
                      )
                    : Text(
                        field.errorText ?? "",
                        style: TextStyle(
                          color: errorColor,
                          fontSize: 13.0,
                        ),
                      )
              ],
            );
          },
        );

  @override
  FormFieldState<PlaceLocation> createState() => _LocationFormFieldState();
}

class _LocationFormFieldState extends FormFieldState<PlaceLocation> {
  @override
  LocationFormField get widget => super.widget as LocationFormField;
}

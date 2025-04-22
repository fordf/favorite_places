import 'package:flutter/material.dart';
import 'package:favorite_places/models/place.dart';

const kGoogleMapsKey = String.fromEnvironment('GMAPS_KEY');

class PlaceDetail extends StatelessWidget {
  const PlaceDetail({super.key, required this.place});

  final Place place;

  String get locationImageUrl {
    final lat = place.location.latitude;
    final long = place.location.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$long'
        '&zoom=14&size=600x300&markers=color:red%7C$lat,$long&key=$kGoogleMapsKey';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
        backgroundColor: Colors.black54,
      ),
      body: Stack(
        children: [
          Image.file(
            place.image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage(locationImageUrl),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    vertical: 40,
                    horizontal: 24,
                  ),
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Colors.transparent,
                    Colors.black87,
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                  child: Text(
                    place.location.address,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

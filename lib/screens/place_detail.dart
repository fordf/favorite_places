import 'package:favorite_places/models/favorite_place.dart';
import 'package:flutter/material.dart';

class PlaceDetail extends StatelessWidget {
  const PlaceDetail({super.key, required this.place});

  final FavoritePlace place;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
        backgroundColor: Colors.black54,
      ),
      body: Image.file(
        place.image,
        fit: BoxFit.cover,
        width: double.infinity,
      ),
    );
  }
}

import 'package:favorite_places/models/place.dart';
import 'package:flutter/material.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, required this.location, this.isSelecting = true});

  final bool isSelecting;
  final PlaceLocation location;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSelecting ? "Choose a location" : ""),
      ),
    );
  }
}

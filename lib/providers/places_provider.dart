import 'dart:io';

import 'package:favorite_places/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();

  return sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, long REAL, address TEXT)');
    },
    version: 1,
  );
}

class PlacesNotifier extends Notifier<List<Place>> {
  @override
  List<Place> build() => [];

  Future<void> loadPlaces() async {
    await Future.delayed(Duration(seconds: 2));
    final db = await _getDatabase();
    final places = await db.query('user_places');

    state = [
      for (final place in places)
        Place(
          id: place['id'] as String,
          title: place['title'] as String,
          image: File(place['image'] as String),
          location: PlaceLocation(
            latitude: place['lat'] as double,
            longitude: place['long'] as double,
            address: place['address'] as String,
          ),
        )
    ];
  }

  void addFavoritePlace({
    required String title,
    required File image,
    required PlaceLocation location,
  }) async {
    final appDir = await syspath.getApplicationDocumentsDirectory();
    final filename = path.basename(image.path);
    final imagePath = "${appDir.path}/$filename";
    final copiedImage = await image.copy(imagePath);
    final place = Place(title: title, image: copiedImage, location: location);

    final db = await _getDatabase();
    db.insert('user_places', {
      'id': place.id,
      'title': title,
      'image': imagePath,
      'lat': location.latitude,
      'long': location.longitude,
      'address': location.address,
    });
    state = [place, ...state];
  }

  void addFavoritePlaceAtIndex(int index, Place place) {
    state = [
      ...state.sublist(0, index),
      place,
      ...state.sublist(index, state.length),
    ];
  }

  void deleteFavoritePlace(int index) {
    state = [
      ...state.sublist(0, index),
      ...state.sublist(index + 1, state.length),
    ];
  }
}

final placesNotifierProvider =
    NotifierProvider<PlacesNotifier, List<Place>>(PlacesNotifier.new);

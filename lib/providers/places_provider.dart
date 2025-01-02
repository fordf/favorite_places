import 'package:favorite_places/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesNotifier extends Notifier<List<Place>> {
  @override
  List<Place> build() => [];

  void addFavoritePlace(Place place) {
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

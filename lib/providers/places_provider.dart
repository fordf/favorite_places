import 'package:favorite_places/models/favorite_place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesNotifier extends Notifier<List<FavoritePlace>> {
  @override
  List<FavoritePlace> build() => [];

  void addFavoritePlace(FavoritePlace place) {
    state = [place, ...state];
  }

  void addFavoritePlaceAtIndex(int index, FavoritePlace place) {
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
    NotifierProvider<PlacesNotifier, List<FavoritePlace>>(PlacesNotifier.new);

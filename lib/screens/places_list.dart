import 'package:favorite_places/models/favorite_place.dart';
import 'package:favorite_places/providers/places_provider.dart';
import 'package:favorite_places/screens/new_place_form.dart';
import 'package:favorite_places/screens/place_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesList extends ConsumerStatefulWidget {
  const PlacesList({super.key});

  @override
  ConsumerState<PlacesList> createState() => _PlacesListState();
}

class _PlacesListState extends ConsumerState<PlacesList> {
  void _openAddPlaceForm() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const NewPlaceForm(),
      ),
    );
  }

  void _onDeletePlace(int index, FavoritePlace place) {
    ref.read(placesNotifierProvider.notifier).deleteFavoritePlace(index);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${place.title} removed'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            ref
                .read(placesNotifierProvider.notifier)
                .addFavoritePlaceAtIndex(index, place);
          },
        ),
      ),
    );
  }

  void _onSelectPlace(FavoritePlace place) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => PlaceDetail(place: place)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final places = ref.watch(placesNotifierProvider);
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Your Places',
          style: textTheme.titleLarge,
        ),
        backgroundColor: Colors.black54,
        // backgroundColor: Theme.of(context).colorScheme.shadow,
        actions: [
          IconButton(
            onPressed: _openAddPlaceForm,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: places.isEmpty
          ? Center(
              child: Text(
                'No places yet!',
                style: textTheme.titleMedium,
              ),
            )
          : ListView.builder(
              itemCount: places.length,
              itemBuilder: (ctx, i) => Dismissible(
                key: ValueKey(places[i]),
                background: Container(
                  color: Theme.of(context).colorScheme.error,
                  // margin: EdgeInsets.symmetric(
                  //   horizontal: Theme.of(context).cardTheme.margin!.horizontal,
                  // ),
                ),
                onDismissed: (d) {
                  _onDeletePlace(i, places[i]);
                },
                child: InkWell(
                  onTap: () {
                    _onSelectPlace(places[i]);
                  },
                  child: ListTile(
                    leading: Text(
                      places[i].title,
                      style: textTheme.titleMedium,
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

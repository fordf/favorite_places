import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/providers/places_provider.dart';
import 'package:favorite_places/screens/new_place_form.dart';
import 'package:favorite_places/widgets/place_list_tile.dart';

class PlacesList extends ConsumerStatefulWidget {
  const PlacesList({super.key});

  @override
  ConsumerState<PlacesList> createState() => _PlacesListState();
}

class _PlacesListState extends ConsumerState<PlacesList> {
  late Future<void> placesFuture;
  @override
  void initState() {
    super.initState();
    placesFuture = ref.read(placesNotifierProvider.notifier).loadPlaces();
  }

  void _openAddPlaceForm() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const NewPlaceForm(),
      ),
    );
  }

  void _onDeletePlace(int index, Place place) {
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
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
            future: placesFuture,
            builder: (context, snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : places.isEmpty
                        ? Center(
                            child: Text(
                              'No places yet!',
                              style: textTheme.titleMedium,
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                              itemCount: places.length,
                              itemBuilder: (ctx, i) => PlaceListTile(
                                place: places[i],
                                onDeletePlace: () {
                                  _onDeletePlace(i, places[i]);
                                },
                              ),
                            ),
                          ),
          ),
        ));
  }
}

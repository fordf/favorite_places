import 'package:favorite_places/models/favorite_place.dart';
import 'package:favorite_places/providers/places_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewPlaceForm extends ConsumerStatefulWidget {
  const NewPlaceForm({super.key});

  @override
  ConsumerState<NewPlaceForm> createState() => _NewPlaceFormState();
}

class _NewPlaceFormState extends ConsumerState<NewPlaceForm> {
  final TextEditingController titleController = TextEditingController();

  void _onAddPlace() {
    final id = ref.read(placesNotifierProvider).length;
    final place = FavoritePlace(title: titleController.text, id: id.toString());
    ref.read(placesNotifierProvider.notifier).addFavoritePlace(place);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a Favorite Place'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton.icon(
              onPressed: _onAddPlace,
              label: const Text('Add Place'),
              icon: const Icon(Icons.add),
            )
          ],
        ),
      ),
    );
  }
}

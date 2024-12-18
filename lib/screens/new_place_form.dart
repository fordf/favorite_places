import 'package:favorite_places/models/favorite_place.dart';
import 'package:favorite_places/providers/places_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class NewPlaceForm extends ConsumerStatefulWidget {
  const NewPlaceForm({super.key});

  @override
  ConsumerState<NewPlaceForm> createState() => _NewPlaceFormState();
}

class _NewPlaceFormState extends ConsumerState<NewPlaceForm> {
  final formKey = GlobalKey<FormState>();
  late String placeTitle;
  bool isSubmitted = false;

  void _onAddPlace() {
    setState(() {
      isSubmitted = true;
    });
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();
    final place = FavoritePlace(title: placeTitle);
    ref.read(placesNotifierProvider.notifier).addFavoritePlace(place);
    Navigator.of(context).pop();
  }

  // String? get _errorText {
  //   if (text.isEmpty) {
  //     return 'Required';
  //   }
  //   return null;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a Favorite Place'),
        backgroundColor: Colors.black54,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                autovalidateMode: isSubmitted
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                maxLength: 30,
                decoration: const InputDecoration(labelText: 'Name'),
                style: const TextStyle(color: Colors.white, fontSize: 22),
                autocorrect: false,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Name required' : null,
                onSaved: (newValue) {
                  placeTitle = newValue!;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                onPressed: _onAddPlace,
                label: const Text('Add Place'),
                icon: const Icon(Icons.add),
              )
            ],
          ),
        ),
      ),
    );
  }
}

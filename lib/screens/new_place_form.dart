import 'dart:io';

import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/providers/places_provider.dart';
import 'package:favorite_places/widgets/file_form_field.dart';
// import 'package:favorite_places/widgets/image_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewPlaceForm extends ConsumerStatefulWidget {
  const NewPlaceForm({super.key});

  @override
  ConsumerState<NewPlaceForm> createState() => _NewPlaceFormState();
}

class _NewPlaceFormState extends ConsumerState<NewPlaceForm> {
  final formKey = GlobalKey<FormState>();
  late String placeTitle;
  File? _image;
  bool isSubmitted = false;
  String? imageErrorText;

  void _onAddPlace() {
    setState(() {
      isSubmitted = true;
    });
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();
    final place = Place(title: placeTitle, image: _image!);
    ref.read(placesNotifierProvider.notifier).addFavoritePlace(place);
    Navigator.of(context).pop();
  }

  void onAddImage(File image) {
    _image = image;
  }

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
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                style: const TextStyle(color: Colors.white, fontSize: 22),
                autocorrect: false,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Name required' : null,
                onSaved: (newValue) {
                  placeTitle = newValue!;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              FileFormField(
                // autovalidateMode: AutovalidateMode.always,
                errorColor:
                    isSubmitted ? Theme.of(context).colorScheme.error : null,
                validator: (imageFile) {
                  if (imageFile == null) {
                    return 'Image required';
                  }
                  return null;
                },
                onSaved: (File? imageFile) {
                  _image = imageFile;
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

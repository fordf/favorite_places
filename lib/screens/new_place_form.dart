import 'dart:io';

import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/providers/places_provider.dart';
import 'package:favorite_places/widgets/container_form_field.dart';
import 'package:favorite_places/widgets/image_field.dart';
import 'package:favorite_places/widgets/location_field.dart';
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
  PlaceLocation? _location;
  bool isSubmitted = false;
  String? imageErrorText;

  void _onAddPlace() {
    setState(() {
      isSubmitted = true;
    });
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();
    final place =
        Place(title: placeTitle, image: _image!, location: _location!);
    ref.read(placesNotifierProvider.notifier).addFavoritePlace(place);
    Navigator.of(context).pop();
  }

  void onAddImage(File image) {
    _image = image;
  }

  void onAddLocation(PlaceLocation location) {
    _location = location;
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
              ContainerFormField<ImageInput, File>(
                errorColor: Theme.of(context).colorScheme.error,
                validator: (imageFile) =>
                    imageFile == null ? 'Image required' : null,
                onSaved: (File? imageFile) {
                  _image = imageFile;
                },
                child: ImageInput.new,
              ),
              const SizedBox(
                height: 5,
              ),
              ContainerFormField<LocationField, PlaceLocation>(
                errorColor: Theme.of(context).colorScheme.error,
                validator: (imageFile) =>
                    imageFile == null ? 'Image required' : null,
                onSaved: (PlaceLocation? location) {
                  _location = location;
                },
                child: LocationField.new,
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

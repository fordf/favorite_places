import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatelessWidget {
  const ImageInput({
    super.key,
    required this.onAddImage,
    required this.file,
  });

  final void Function(File image) onAddImage;
  final File? file;

  void _addImage(ImageSource imageSource) async {
    final imagePicker = ImagePicker();
    final xFile = await imagePicker.pickImage(
      source: imageSource,
      maxWidth: 600,
    );
    if (xFile == null) return;
    final image = File(xFile.path);

    onAddImage(image);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
        height: 250,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: file == null
              ? null
              : DecorationImage(
                  image: FileImage(file!),
                  fit: BoxFit.cover,
                ),
          border: Border.all(
            color: colorScheme.primary.withOpacity(.2),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor:
                    WidgetStatePropertyAll(colorScheme.surfaceContainerHigh),
              ),
              onPressed: () {
                _addImage(ImageSource.gallery);
              },
              label: const Text('Choose an Image from your Gallery'),
              icon: const Icon(Icons.add_photo_alternate_outlined),
            ),
            const SizedBox(height: 20),
            TextButton.icon(
              style: ButtonStyle(
                backgroundColor:
                    WidgetStatePropertyAll(colorScheme.surfaceContainerHigh),
              ),
              onPressed: () {
                _addImage(ImageSource.camera);
              },
              label: const Text('Take a Photo'),
              icon: const Icon(Icons.camera),
            ),
          ],
        ));
  }
}

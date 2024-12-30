import 'dart:io';

import 'package:favorite_places/widgets/image_input.dart';
import 'package:flutter/material.dart';

class FileFormField extends FormField<File> {
  final Color? errorColor;
  FileFormField({
    super.key,
    required this.errorColor,
    FormFieldValidator<File>? validator,
    super.onSaved,
  }) : super(
          validator: validator,
          builder: (field) {
            void onChangedHandler(File? value) {
              field.didChange(value);
            }

            bool isError = errorColor != null && !field.isValid;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: isError
                      ? BoxDecoration(
                          border: Border.all(color: errorColor),
                          borderRadius: BorderRadius.circular(8),
                        )
                      : null,
                  child: ImageInput(
                    onAddImage: onChangedHandler,
                    file: field.value,
                  ),
                ),
                field.isValid
                    ? Container()
                    : Text(
                        field.errorText ?? "",
                        style: TextStyle(
                          color: errorColor,
                          fontSize: 13.0,
                        ),
                      )
              ],
            );
          },
        );

  @override
  FormFieldState<File> createState() => _FileFormFieldState();
}

class _FileFormFieldState extends FormFieldState<File> {
  @override
  FileFormField get widget => super.widget as FileFormField;

  @override
  void didChange(File? value) {
    super.didChange(value);
  }
}

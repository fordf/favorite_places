// import 'package:flutter/material.dart';

// interface class FormFieldWidget<T> extends Widget{
//   T? value;
  
//   void onChanged(T value, FormFieldState<T> field) {
//     field.didChange(value);
//   }
// }

// class ContainerFormField<T> extends FormField<T> {
//   final Color? errorColor;
//   final FormFieldWidget<T> child;

//   ContainerFormField({
//     super.key,
//     required this.child,
//     this.errorColor,
//     FormFieldValidator<T>? validator,
//     super.onSaved,
//   }) : super(
//           validator: validator,
//           builder: (field) {
//             // void onChangedHandler(File? value) {
//             //   field.didChange(value);
//             // }

//             bool isError = errorColor != null && !field.isValid;
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   decoration: isError
//                       ? BoxDecoration(
//                           border: Border.all(color: errorColor),
//                           borderRadius: BorderRadius.circular(8),
//                         )
//                       : null,
//                   child: ImageInput(
//                     onAddImage: onChangedHandler,
//                     file: field.value,
//                   ),
//                 ),
//                 field.isValid
//                     ? Container()
//                     : Text(
//                         field.errorText ?? "",
//                         style: TextStyle(
//                           color: errorColor,
//                           fontSize: 13.0,
//                         ),
//                       )
//               ],
//             );
//           },
//         );

//   @override
//   FormFieldState<T> createState() => _ContainerFormFieldState();
// }

// class _ContainerFormFieldState<T> extends FormFieldState<T> {
//   @override
//   ContainerFormField<T> get widget => super.widget as ContainerFormField<T>;

//   // @override
//   // void didChange(File? value) {
//   //   super.didChange(value);
//   // }
// }

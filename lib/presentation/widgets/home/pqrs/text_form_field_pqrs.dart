import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldPqrs extends StatelessWidget{
  final TextEditingController controller;
  final String title;
  final String helperText;
  final int maxLines;
  final bool isFilled;
  final int maxLength;
  final String? Function(String?)? validator;

  const TextFormFieldPqrs({
    super.key,
    required this.controller,
    required this.title,
    required this.helperText,
    required this.maxLines,
    required this.isFilled,
    required this.maxLength,
    required this.validator
  });

  @override
  Widget build(Object context) {
    return TextFormField(
          controller: controller,
          maxLines: 10,
          // maxLength: _maxDescripcionLength, // O puedes usar un contador manual
          inputFormatters: [
            LengthLimitingTextInputFormatter(maxLength),
          ],
          decoration: InputDecoration(
            labelText: title,
            floatingLabelStyle: TextStyle(
              color: Colors.blue.shade900,
              fontSize: 22,
            ),
            alignLabelWithHint: true,
            labelStyle: const TextStyle(fontWeight: FontWeight.w400),
            filled: isFilled,
            fillColor: Colors.white,
            helperText: helperText,
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          maxLength: maxLength,
          validator: validator,
        );
  }
  
}
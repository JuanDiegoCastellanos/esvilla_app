import 'package:flutter/material.dart';

class TextFieldFormEsvilla extends StatelessWidget {
  
  final TextEditingController controller;
  final String name;
  final Color borderColor;
  final bool obscureText;
  final TextInputType? inputType;
  final String? Function(String?)? validator;
  final int minLength;
  final int maxLength;
  final Widget? suffixIcon;

  const TextFieldFormEsvilla(
      {super.key,
      required this.name,
      required this.controller,
      required this.inputType,
      this.obscureText = false,
      this.borderColor = const Color(0xFF4F78FF),
      this.validator,
      this.minLength = 8,
      this.maxLength = 20,
      this.suffixIcon,
      });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          labelText: name,
          floatingLabelStyle: const TextStyle(color: Colors.blue, fontSize: 22),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: borderColor,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: borderColor,
              width: 4,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: borderColor,
              width: 1,
            ),
          ),
          suffixIcon: suffixIcon
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$name es requerido';
        }
        if (value.length < minLength) {
          return 'El campo debe tener al menos $minLength caracteres';
        }
        return validator?.call(value);
      },
      obscureText: obscureText,
      maxLength: maxLength,
      onEditingComplete: () => FocusScope.of(context).unfocus(),
    );
  }
}


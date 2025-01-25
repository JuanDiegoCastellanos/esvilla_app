import 'package:flutter/material.dart';

class TextFieldBox extends StatelessWidget {
  const TextFieldBox({super.key, required this.controller, this.obscureText = false});
  final TextEditingController controller;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFF4F78FF),
            width: 2.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFF4F78FF), // Color del borde al enfocar
            width: 2.5, // Grosor del borde al enfocar
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFF4F78FF), // Color del borde al habilitar
            width: 2.5, // Grosor del borde al habilitar
          ),
        ),
      ),
      textAlignVertical: TextAlignVertical.top,
      cursorHeight: 34,
      obscureText: obscureText,
      style: const TextStyle(
        fontSize: 20,
        fontFamily: 'Sniglet',
      ),
    );
  }
}

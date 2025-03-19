import 'package:flutter/material.dart';

typedef Validator = String? Function(String?);

class TextFieldBox extends StatelessWidget {
  const TextFieldBox(
      {super.key,
      required this.controller,
      this.obscureText = false,
      this.borderColor = const Color(0xFF4F78FF),
      this.errorMessage});

  final TextEditingController controller;
  final Color borderColor;
  final bool obscureText;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:  BorderSide(
            color: borderColor, //Color(0xFF4F78FF),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:  BorderSide(
            color: borderColor, //Color(0xFF4F78FF), // Color del borde al enfocar
            width: 1, // Grosor del borde al enfocar
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:  BorderSide(
            color: borderColor, //Color(0xFF4F78FF), // Color del borde al habilitar
            width: 1, // Grosor del borde al habilitar
          ),
        ),
        hintText: errorMessage,
        hintStyle: const TextStyle(
          //codium que sea rojo  
          color: Colors.red,
          fontSize: 14,
          fontWeight: FontWeight.w400
        )
      ),
      textAlignVertical: TextAlignVertical.bottom,
      cursorHeight: 30,
      obscureText: obscureText,
      onEditingComplete: () => FocusScope.of(context).unfocus(),
    );
  }
}

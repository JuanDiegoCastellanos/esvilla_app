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
            width: 2.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:  BorderSide(
            color: borderColor, //Color(0xFF4F78FF), // Color del borde al enfocar
            width: 2.5, // Grosor del borde al enfocar
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:  BorderSide(
            color: borderColor, //Color(0xFF4F78FF), // Color del borde al habilitar
            width: 2.5, // Grosor del borde al habilitar
          ),
        ),
        hintText: errorMessage,
        hintStyle: const TextStyle(
          //codium que sea rojo  
          color: Colors.red,
          fontSize: 16,
          fontFamily: 'Sniglet',
        )
      ),
      textAlignVertical: TextAlignVertical.bottom,
      cursorHeight: 30,
      obscureText: obscureText,
      style: const TextStyle(
        fontSize: 20,
        fontFamily: 'Sniglet',
      ),
      onEditingComplete: () => FocusScope.of(context).unfocus(),
    );
  }
}

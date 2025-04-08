import 'package:flutter/material.dart';

class TextFieldFormEsvilla extends StatelessWidget {
  const TextFieldFormEsvilla(
      {super.key,
      required this.name,
      required this.controller,
      required this.inputType,
      this.obscureText = false,
      this.borderColor = const Color(0xFF4F78FF),
      this.validator,
      });

  final TextEditingController controller;
  final String name;
  final Color borderColor;
  final bool obscureText;
  final TextInputType? inputType;
  final String? Function(String?)? validator;

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
              color: borderColor, //Color(0xFF4F78FF),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color:
                  borderColor, //Color(0xFF4F78FF), // Color del borde al enfocar
              width: 4, // Grosor del borde al enfocar
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color:
                  borderColor, //Color(0xFF4F78FF), // Color del borde al habilitar
              width: 1, // Grosor del borde al habilitar
            ),
          ),
      ),
      validator: validator,
      obscureText: obscureText,
      onEditingComplete: () => FocusScope.of(context).unfocus(),
    );
  }
}

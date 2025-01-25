import 'package:flutter/material.dart';

class ButtonRectangular extends StatelessWidget {
  const ButtonRectangular(
      {super.key, required this.onPressedFunction, required this.title});

  final VoidCallback onPressedFunction;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(const Size(233, 50)),
        backgroundColor: MaterialStateColor.resolveWith(
            (states) => const Color.fromRGBO(47, 39, 125, 1)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        )),
      ),
      onPressed: onPressedFunction,
      child: Text(
        title,
        style: const TextStyle(
            color: Colors.white, fontSize: 24, fontFamily: 'Sniglet'),
      ),
    );
  }
}

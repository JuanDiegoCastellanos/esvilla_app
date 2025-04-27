import 'package:flutter/material.dart';

class TitleSection extends StatelessWidget {
  final String titleText;
  const TitleSection({super.key, required this.titleText});

  @override
  Widget build(BuildContext context) {
    return Text(
      titleText,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w400,
          color: Colors.blue.shade900),
    );
  }
}

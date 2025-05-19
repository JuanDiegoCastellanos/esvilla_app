import 'package:flutter/material.dart';

class SectorChips extends StatelessWidget {
  final List<String> sectors;
  const SectorChips(this.sectors, {super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: sectors.map((name) => Chip(
        label: Text(name, style: TextStyle(
          fontSize: 13,
          color: Colors.black
          )),
        backgroundColor: Colors.green.shade200,
        side: BorderSide(
          color: Colors.green.shade200,
          width: 1.5,
          ),
      )).toList(),
    );
  }
}
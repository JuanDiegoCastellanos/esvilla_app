import 'package:flutter/material.dart';

class ItemNews{
  final IconData icon;
  final String text;
  final Image? image;

  ItemNews({
    required this.icon,
    required this.text,
    this.image});
}
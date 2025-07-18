import 'package:flutter/material.dart';

class Chapter {
  final int id;
  final String title;
  final String description;
  final String story;
  final IconData icon;
  final Color color;

  Chapter({
    required this.id,
    required this.title,
    required this.description,
    required this.story,
    required this.icon,
    required this.color,
  });
}
import 'package:flutter/material.dart';

Widget statBox(String title, String value) {
  return Column(
    children: [
      Text(
        value,
        style: const TextStyle(
          fontSize: 22,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        title,
        style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.6)),
      ),
    ],
  );
}

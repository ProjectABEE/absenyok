import 'package:flutter/material.dart';

Widget glassCard({required Widget child}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 18),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.08),
      borderRadius: BorderRadius.circular(25),
      border: Border.all(color: Colors.white.withOpacity(0.2)),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 18),
      ],
    ),
    child: child,
  );
}

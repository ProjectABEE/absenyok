import 'package:flutter/material.dart';

Widget buildInputField({
  required String label,
  required IconData icon,
  required bool obscure,
  required TextEditingController? controler,
  IconData? suffixIcon,
  VoidCallback? onSuffixTap,
}) {
  return TextFormField(
    controller: controler,
    obscureText: obscure,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
      prefixIcon: Icon(icon, color: Colors.white70),
      suffixIcon: suffixIcon != null
          ? IconButton(
              onPressed: onSuffixTap,
              icon: Icon(suffixIcon, color: Colors.white70),
            )
          : null,
      filled: true,
      fillColor: Colors.white.withOpacity(0.08),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.greenAccent.shade400, width: 1.4),
      ),
    ),
  );
}

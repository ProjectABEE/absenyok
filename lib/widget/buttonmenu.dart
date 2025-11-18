import 'package:flutter/material.dart';

Widget menuItem({
  required IconData icon,
  required String text,
  required VoidCallback onTap,
  Color? textColor,
  Color? iconColor,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      margin: const EdgeInsets.only(bottom: 15, right: 15, left: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade100,
      ),
      child: Row(
        children: [
          Icon(icon, size: 26, color: iconColor ?? Colors.black87),
          const SizedBox(width: 15),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: textColor ?? Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey.shade600),
        ],
      ),
    ),
  );
}

import 'package:flutter/material.dart';

Widget menuTile({
  required IconData icon,
  required String title,
  Color? iconColor,
  Color? textColor,
  required VoidCallback onTap,
}) {
  return InkWell(
    borderRadius: BorderRadius.circular(20),
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(.15)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 22, color: iconColor ?? Colors.white),
          const SizedBox(width: 15),
          Text(
            title,
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.white.withOpacity(.4),
          ),
        ],
      ),
    ),
  );
}

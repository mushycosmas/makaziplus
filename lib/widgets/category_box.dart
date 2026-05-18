import 'package:flutter/material.dart';

class CategoryBox extends StatelessWidget {
  final String title;
  final String listings;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const CategoryBox({
    super.key,
    required this.title,
    required this.listings,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.black87),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              listings,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
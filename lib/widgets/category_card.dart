import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isActive;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.icon,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            if (!isActive)
              const BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
          ],
          border: Border.all(
            color: isActive ? Colors.black : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive ? Colors.white : Colors.black87,
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                color: isActive ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
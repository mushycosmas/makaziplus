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
        curve: Curves.easeInOut,

        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        margin: const EdgeInsets.only(right: 10),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30), // 🔥 fully pill shape

          gradient: isActive
              ? LinearGradient(
                  colors: [
                    Colors.green.shade600,
                    Colors.green.shade400,
                  ],
                )
              : null,

          color: isActive ? null : Colors.white,

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isActive ? 0.12 : 0.06),
              blurRadius: isActive ? 12 : 8,
              offset: const Offset(0, 4),
            ),
          ],

          border: Border.all(
            color: isActive ? Colors.green.shade600 : Colors.grey.shade200,
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
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../models/category_model.dart';

class CategoryBox extends StatelessWidget {
  final Category category;
  final Color color;
  final VoidCallback? onTap;

  const CategoryBox({
    super.key,
    required this.category,
    required this.color,
    this.onTap,
  });

  IconData _getIcon(String name) {
    switch (name.toLowerCase()) {
      case 'house':
        return Icons.home;
      case 'apartment':
        return Icons.apartment;
      case 'land':
        return Icons.landscape;
      case 'office':
        return Icons.business;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconData = _getIcon(category.name);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          width: 140, // ✅ important for horizontal scroll
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                color: Colors.black87,
                size: 26,
              ),

              const SizedBox(height: 10),

              Text(
                category.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                "${category.totalProperties} Listings",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
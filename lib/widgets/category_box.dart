// lib/widgets/category_box.dart
import 'package:flutter/material.dart';
import '../models/category_model.dart';

class CategoryBox extends StatelessWidget {
  final dynamic category; // ✅ Changed to dynamic to accept both
  final Color color;
  final VoidCallback? onTap;

  const CategoryBox({
    super.key,
    required this.category,
    required this.color,
    this.onTap,
  });

  // Helper to get category name
  String _getCategoryName() {
    if (category is Category) {
      return (category as Category).name;
    } else if (category is Map<String, dynamic>) {
      return category['name'] ?? 'Category';
    }
    return 'Category';
  }

  // Helper to get total properties
  int _getTotalProperties() {
    if (category is Category) {
      return (category as Category).totalProperties;
    } else if (category is Map<String, dynamic>) {
      return category['totalProperties'] ?? category['properties']?.length ?? 0;
    }
    return 0;
  }

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
      case 'commercial':
        return Icons.storefront;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = _getCategoryName();
    final totalProps = _getTotalProperties();
    final iconData = _getIcon(name);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          width: 145,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.9),
                color.withOpacity(0.6),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 15,
                offset: const Offset(0, 6),
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// ICON CONTAINER
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  iconData,
                  color: Colors.green.shade700,
                  size: 22,
                ),
              ),
              const SizedBox(height: 12),

              /// CATEGORY NAME
              Text(
                name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),

              /// LISTINGS
              Text(
                "$totalProps Listings",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black.withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
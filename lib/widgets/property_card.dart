// lib/widgets/property_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PropertyCard extends StatelessWidget {
  final String image;
  final String title;
  final String price;
  final String status; // Rent / Sale
  final VoidCallback? onTap;
  final Map<String, dynamic>? propertyData; // ✅ Add propertyData

  const PropertyCard({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    required this.status,
    this.onTap,
    this.propertyData, // ✅ Make it optional
  });

  // Helper method inside the widget as fallback
  String _formatPrice(String price) {
    try {
      // Remove any non-numeric characters
      final cleanPrice = price.replaceAll(RegExp(r'[^0-9.]'), '');
      final doubleValue = double.tryParse(cleanPrice) ?? 0;
      final formatter = NumberFormat('#,###', 'en_US');
      final formatted = formatter.format(doubleValue);
      return 'TSh $formatted';
    } catch (e) {
      return 'TSh $price';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRent = status.toLowerCase() == "rent";
    final formattedPrice = _formatPrice(price);

    return GestureDetector(
      onTap: onTap ?? () {
        // Default behavior if onTap is not provided
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Viewing ${title.isNotEmpty ? title : 'property'}'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE + BADGES
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Stack(
                children: [
                  /// IMAGE
                  Image.network(
                    image,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 150,
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.broken_image,
                        color: Colors.grey,
                        size: 40,
                      ),
                    ),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 150,
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                  ),

                  /// FAVORITE ICON
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        size: 18,
                        color: Colors.red,
                      ),
                    ),
                  ),

                  /// RENT / SALE BADGE
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isRent ? Colors.orange : Colors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        status.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// CONTENT
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// PRICE (FORMATTED)
                  Text(
                    formattedPrice,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF22C55E),
                    ),
                  ),

                  const SizedBox(height: 4),

                  /// TITLE
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 6),

                  /// STATUS INFO
                  Row(
                    children: [
                      Icon(
                        isRent ? Icons.key : Icons.sell,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isRent ? 'For Rent' : 'For Sale',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'View',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
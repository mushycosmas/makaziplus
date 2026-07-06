// lib/widgets/property_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../api/user_property_favorite_api.dart';

class PropertyCard extends StatefulWidget {
  final String image;
  final String title;
  final String price;
  final String status; // Rent / Sale
  final VoidCallback? onTap;
  final Map<String, dynamic>? propertyData;
  final int? userId; // Make userId configurable

  const PropertyCard({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    required this.status,
    this.onTap,
    this.propertyData,
    this.userId, // Allow passing userId from parent
  });

  @override
  State<PropertyCard> createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard> {
  late bool isFavorite;
  bool isLoadingFav = false;

  // Get userId from widget or use default
  int get userId => widget.userId ?? 1; // Fallback, but should be provided

  @override
  void initState() {
    super.initState();
    isFavorite = false;
    _loadFavoriteStatus();
  }

  @override
  void didUpdateWidget(PropertyCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload favorite status if property ID changes
    if (widget.propertyData?['id'] != oldWidget.propertyData?['id']) {
      _loadFavoriteStatus();
    }
  }

  Future<void> _loadFavoriteStatus() async {
    final propertyId = widget.propertyData?['id'];
    if (propertyId == null || userId <= 0) return;

    try {
      final result = await UserPropertyFavoriteApi.isFavorite(
        userId,
        propertyId,
      );

      if (mounted) {
        setState(() {
          isFavorite = result;
        });
      }
    } catch (e) {
      debugPrint("Failed to load favorite status: $e");
      if (mounted) {
        setState(() {
          isFavorite = false;
        });
      }
    }
  }

  Future<void> _toggleFavorite() async {
    final propertyId = widget.propertyData?['id'];
    if (propertyId == null || userId <= 0) return;

    if (isLoadingFav) return;

    setState(() {
      isLoadingFav = true;
    });

    try {
      bool success = false;
      
      if (isFavorite) {
        final result = await UserPropertyFavoriteApi.removeFavorite(
          userId,
          propertyId,
        );
        success = result['success'] == true;
        if (success && mounted) {
          setState(() {
            isFavorite = false;
          });
        }
      } else {
        final result = await UserPropertyFavoriteApi.addFavorite(
          userId,
          propertyId,
        );
        success = result['success'] == true;
        if (success && mounted) {
          setState(() {
            isFavorite = true;
          });
        }
      }

      // Show feedback if operation failed
      if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isFavorite 
                ? 'Failed to remove from favorites' 
                : 'Failed to add to favorites',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint("Favorite error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoadingFav = false;
        });
      }
    }
  }

  String _formatPrice(String price) {
    try {
      // Handle different price formats
      String cleanPrice = price.replaceAll(RegExp(r'[^0-9.]'), '');
      
      // Handle empty or invalid price
      if (cleanPrice.isEmpty) return 'TSh 0';
      
      double doubleValue = double.tryParse(cleanPrice) ?? 0;
      
      // Format with commas
      final formatter = NumberFormat('#,###', 'en_US');
      return 'TSh ${formatter.format(doubleValue)}';
    } catch (e) {
      debugPrint('Price formatting error: $e');
      return 'TSh $price';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRent = widget.status.toLowerCase() == "rent";
    final formattedPrice = _formatPrice(widget.price);

    return GestureDetector(
      onTap: widget.onTap ?? _defaultOnTap,
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
            // IMAGE SECTION
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Stack(
                children: [
                  // Image with loading state
                  Image.network(
                    widget.image,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 150,
                        color: Colors.grey[200],
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / 
                                  loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 150,
                      color: Colors.grey[200],
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.broken_image, size: 40, color: Colors.grey),
                          SizedBox(height: 4),
                          Text(
                            'Image not available',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // FAVORITE BUTTON
                  if (userId > 0) // Only show if user is logged in
                    Positioned(
                      top: 8,
                      right: 8,
                      child: InkWell(
                        onTap: _toggleFavorite,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: isLoadingFav
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.red,
                                  ),
                                )
                              : Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  size: 18,
                                  color: Colors.red,
                                ),
                        ),
                      ),
                    ),

                  // STATUS BADGE
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
                        widget.status.toUpperCase(),
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

            // CONTENT
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formattedPrice,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF22C55E),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.title,
                    maxLines: 2, // Changed to 2 for better readability
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
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
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'View',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
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

  void _defaultOnTap() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing ${widget.title}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
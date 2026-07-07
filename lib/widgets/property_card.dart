import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../api/user_property_favorite_api.dart';

class PropertyCard extends StatefulWidget {
  final String image;
  final String title;
  final String price;
  final String status;
  final VoidCallback? onTap;
  final Map<String, dynamic>? propertyData;
  final int? userId;
  final bool? initialFavorite; // Add this to receive initial state

  const PropertyCard({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    required this.status,
    this.onTap,
    this.propertyData,
    this.userId,
    this.initialFavorite, // Optional initial favorite state
  });

  @override
  State<PropertyCard> createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard> {
  bool isFavorite = false;
  bool isLoadingFav = false;
  bool isCheckingFavorite = true;

  int get userId => widget.userId ?? 1;

  @override
  void initState() {
    super.initState();
    // Use initialFavorite if provided, otherwise load from API
    if (widget.initialFavorite != null) {
      isFavorite = widget.initialFavorite!;
      isCheckingFavorite = false;
    } else {
      _loadFavoriteStatus();
    }
  }

  @override
  void didUpdateWidget(PropertyCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Update favorite status if initialFavorite changes
    if (widget.initialFavorite != oldWidget.initialFavorite) {
      setState(() {
        isFavorite = widget.initialFavorite ?? false;
        isCheckingFavorite = false;
      });
    }
    
    // Reload if property ID changes
    if (widget.propertyData?['id'] != oldWidget.propertyData?['id'] && 
        widget.initialFavorite == null) {
      _loadFavoriteStatus();
    }
  }

  /// Load favorite status from API
  Future<void> _loadFavoriteStatus() async {
    final propertyId = widget.propertyData?['id'];
    if (propertyId == null || userId <= 0) {
      setState(() => isCheckingFavorite = false);
      return;
    }

    try {
      setState(() => isCheckingFavorite = true);

      final result = await UserPropertyFavoriteApi.isFavorite(
        userId,
        propertyId,
      );

      if (mounted) {
        setState(() => isFavorite = result);
      }
    } catch (e) {
      debugPrint('Favorite check error: $e');
      if (mounted) {
        setState(() => isFavorite = false);
      }
    } finally {
      if (mounted) {
        setState(() => isCheckingFavorite = false);
      }
    }
  }

  /// Toggle favorite status (add/remove)
  Future<void> _toggleFavorite() async {
    final propertyId = widget.propertyData?['id'];
    if (propertyId == null || userId <= 0) {
      _showSnackBar('Unable to process favorite action', Colors.red);
      return;
    }

    if (isLoadingFav) return;

    // Optimistic update
    final previousState = isFavorite;
    setState(() {
      isFavorite = !isFavorite;
      isLoadingFav = true;
    });

    try {
      bool success = false;

      if (isFavorite) {
        final result = await UserPropertyFavoriteApi.addFavorite(
          userId,
          propertyId,
        );
        success = result['success'] == true;
      } else {
        final result = await UserPropertyFavoriteApi.removeFavorite(
          userId,
          propertyId,
        );
        success = result['success'] == true;
      }

      if (success && mounted) {
        _showSnackBar(
          isFavorite ? 'Added to favorites' : 'Removed from favorites',
          Colors.green,
        );
      } else if (mounted) {
        // Revert on failure
        setState(() {
          isFavorite = previousState;
        });
        _showSnackBar(
          isFavorite ? 'Failed to add to favorites' : 'Failed to remove from favorites',
          Colors.red,
        );
      }
    } catch (e) {
      debugPrint('Favorite toggle error: $e');
      if (mounted) {
        // Revert on error
        setState(() {
          isFavorite = previousState;
        });
        _showSnackBar('An error occurred: ${e.toString()}', Colors.red);
      }
    } finally {
      if (mounted) {
        setState(() => isLoadingFav = false);
      }
    }
  }

  /// Show snackbar message
  void _showSnackBar(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Format price with currency
  String _formatPrice(String price) {
    try {
      final clean = price.replaceAll(RegExp(r'[^0-9]'), '');
      if (clean.isEmpty) return 'TSh 0';
      final value = int.parse(clean);
      final formatter = NumberFormat('#,###', 'en_US');
      return 'TSh ${formatter.format(value)}';
    } catch (e) {
      debugPrint('Price formatting error: $e');
      return 'TSh $price';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRent = widget.status.toLowerCase() == 'rent';

    return GestureDetector(
      onTap: widget.onTap ?? _defaultOnTap,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 200,
          maxHeight: 280,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(isRent),
            Expanded(
              child: _buildContentSection(),
            ),
          ],
        ),
      ),
    );
  }

  /// Build image section with overlay elements
  Widget _buildImageSection(bool isRent) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(16),
      ),
      child: Stack(
        children: [
          _buildPropertyImage(),
          _buildFavoriteButton(),
          _buildStatusBadge(isRent),
        ],
      ),
    );
  }

  /// Build property image with fixed height
  Widget _buildPropertyImage() {
    return SizedBox(
      height: 140,
      width: double.infinity,
      child: Image.network(
        widget.image,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey[200],
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
        errorBuilder: (context, error, stack) {
          return Container(
            color: Colors.grey[200],
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.broken_image,
                  size: 40,
                  color: Colors.grey,
                ),
                SizedBox(height: 4),
                Text(
                  'Image unavailable',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Build favorite button
  Widget _buildFavoriteButton() {
    return Positioned(
      top: 8,
      right: 8,
      child: InkWell(
        onTap: _toggleFavorite,
        child: Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
          ),
          child: (isLoadingFav || isCheckingFavorite)
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.red,
                  ),
                )
              : Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                  size: 20,
                ),
        ),
      ),
    );
  }

  /// Build status badge
  Widget _buildStatusBadge(bool isRent) {
    return Positioned(
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
    );
  }

  /// Build content section with property details
  Widget _buildContentSection() {
    final isRent = widget.status.toLowerCase() == 'rent';

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPrice(),
          const SizedBox(height: 4),
          _buildTitle(),
          const SizedBox(height: 6),
          _buildFooter(isRent),
        ],
      ),
    );
  }

  /// Build price widget
  Widget _buildPrice() {
    return Text(
      _formatPrice(widget.price),
      style: const TextStyle(
        color: Color(0xFF22C55E),
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Build title widget
  Widget _buildTitle() {
    return Text(
      widget.title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 13,
      ),
    );
  }

  /// Build footer with status and view action
  Widget _buildFooter(bool isRent) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isRent ? Icons.key : Icons.sell,
          size: 13,
          color: Colors.grey,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            isRent ? 'For Rent' : 'For Sale',
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 4),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'View',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  /// Default on tap handler
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
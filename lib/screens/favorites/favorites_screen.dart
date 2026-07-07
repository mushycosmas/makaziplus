import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../api/user_property_favorite_api.dart';
import '../../utils/price_formatter.dart';
import '../../widgets/property_card.dart';
import '../property/property_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  static const int userId = 1;
  static const String? token = null;

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  bool isLoading = true;
  List<Map<String, dynamic>> favorites = [];
  Set<int> favoriteIds = {};

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  /// Load user's favorite properties from API
  Future<void> loadFavorites() async {
    try {
      setState(() => isLoading = true);

      final result = await UserPropertyFavoriteApi.getUserFavoritesWithDetails(
        FavoritesScreen.userId,
        token: FavoritesScreen.token,
      );

      if (mounted) {
        final favoritesData = List<Map<String, dynamic>>.from(result['data'] ?? []);
        setState(() {
          favorites = favoritesData;
          favoriteIds = favoritesData
              .map((f) => f['property']?['id'] as int? ?? 0)
              .where((id) => id > 0)
              .toSet();
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Load favorites error: $e');
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  /// Remove a property from favorites
  Future<void> removeFavorite(int propertyId) async {
    try {
      final result = await UserPropertyFavoriteApi.removeFavorite(
        FavoritesScreen.userId,
        propertyId,
        token: FavoritesScreen.token,
      );

      if (result['success'] == true) {
        setState(() {
          favorites.removeWhere((f) => f['property']?['id'] == propertyId);
          favoriteIds.remove(propertyId);
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Removed from favorites'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        await loadFavorites();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to remove from favorites'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Remove favorite error: $e');
      await loadFavorites();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Get complete image URL
  String _getImageUrl(dynamic imageData) {
    const String baseUrl = "https://makazi.nono.co.tz/uploads/";
    const String fallbackImage =
        "https://images.unsplash.com/photo-1600607687939-ce8a6c25118c";

    if (imageData == null) return fallbackImage;

    String? imagePath;

    if (imageData is Map) {
      imagePath = imageData['url'] ?? imageData['image'] ?? imageData['path'];
    } else if (imageData is String) {
      if (imageData.startsWith('{') && imageData.contains('url:')) {
        try {
          final start = imageData.indexOf('url:') + 4;
          final end = imageData.indexOf(',', start);
          imagePath = imageData.substring(start, end).trim();
          imagePath = imagePath.replaceAll('"', '').replaceAll("'", '');
        } catch (e) {
          imagePath = imageData;
        }
      } else {
        imagePath = imageData;
      }
    } else if (imageData is List && imageData.isNotEmpty) {
      return _getImageUrl(imageData.first);
    }

    if (imagePath != null && imagePath.isNotEmpty) {
      if (imagePath.startsWith('http')) {
        return imagePath;
      }
      return '$baseUrl$imagePath';
    }

    return fallbackImage;
  }

  /// Navigate to property details screen
  void navigateToPropertyDetails(Map<String, dynamic> property) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PropertyDetailScreen(
          property: property,
        ),
      ),
    ).then((_) {
      loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text(
          'Favorites',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadFavorites,
            tooltip: 'Refresh favorites',
          ),
          if (favorites.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _showClearFavoritesDialog,
              tooltip: 'Clear all favorites',
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  /// Show clear favorites confirmation dialog
  void _showClearFavoritesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Favorites'),
        content: const Text('Are you sure you want to remove all properties from favorites?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _clearAllFavorites();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  /// Clear all favorites
  Future<void> _clearAllFavorites() async {
    try {
      setState(() => isLoading = true);
      
      for (final favorite in favorites) {
        final propertyId = favorite['property']?['id'] as int?;
        if (propertyId != null) {
          await UserPropertyFavoriteApi.removeFavorite(
            FavoritesScreen.userId,
            propertyId,
            token: FavoritesScreen.token,
          );
        }
      }
      
      setState(() {
        favorites.clear();
        favoriteIds.clear();
        isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All favorites cleared'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      debugPrint('Clear favorites error: $e');
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error clearing favorites: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Build the main body content
  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (favorites.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: loadFavorites,
      child: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final favorite = favorites[index];
          final property = favorite['property'] as Map<String, dynamic>? ?? {};
          
          final imageUrl = _getImageUrl(property['images']);
          final title = property['title']?.toString() ?? 'Untitled Property';
          final price = property['price']?.toString() ?? '0';
          final status = property['status']?.toString() ?? 'Available';
          final propertyId = property['id'] ?? 0;

          return PropertyCard(
            key: ValueKey(propertyId),
            image: imageUrl,
            title: title,
            price: price,
            status: status,
            propertyData: property,
            userId: FavoritesScreen.userId,
            initialFavorite: true,
            onTap: () => navigateToPropertyDetails(property),
          );
        },
      ),
    );
  }

  /// Build empty state widget
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Iconsax.heart,
            size: 70,
            color: Colors.grey,
          ),
          const SizedBox(height: 15),
          const Text(
            'No favorite properties yet',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start exploring and save your favorite properties',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _navigateToHome, // Fixed: Using proper navigation
            icon: const Icon(Icons.explore),
            label: const Text('Explore Properties'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Navigate to home screen properly
  void _navigateToHome() {
    // Option 1: Pop to go back if there's history
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      // Option 2: Replace with home screen if no history
      Navigator.pushReplacementNamed(context, '/home');
      // Or if you're using MaterialPageRoute:
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => HomeScreen()),
      // );
    }
  }
}
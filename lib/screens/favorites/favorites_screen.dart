import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../api/user_property_favorite_api.dart';
import '../../utils/price_formatter.dart'; // Import your price formatter
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
        setState(() {
          favorites = List<Map<String, dynamic>>.from(result['data'] ?? []);
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
        await loadFavorites();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Removed from favorites'),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Remove favorite error: $e');
    }
  }

  /// Get complete image URL
  String getImageUrl(String image) {
    if (image.isEmpty) return '';
    if (image.startsWith('http')) return image;
    return '${UserPropertyFavoriteApi.baseUrl}/$image';
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
    );
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
      ),
      body: _buildBody(),
    );
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
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final property = favorites[index]['property'] as Map<String, dynamic>? ?? {};
          return _buildFavoriteCard(property);
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
        ],
      ),
    );
  }

  /// Build individual favorite card
  Widget _buildFavoriteCard(Map<String, dynamic> property) {
    final propertyId = property['id'] ?? 0;
    final title = property['title']?.toString() ?? 'Untitled Property';
    final price = property['price']?.toString() ?? '0';
    final location = property['ward']?['name']?.toString() ?? 'Unknown location';
    final imageUrl = _getPropertyImage(property);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => navigateToPropertyDetails(property),
        child: ListTile(
          contentPadding: const EdgeInsets.all(10),
          leading: _buildPropertyImage(imageUrl),
          title: _buildPropertyTitle(title),
          subtitle: _buildPropertyDetails(location, price),
          trailing: _buildFavoriteButton(propertyId),
        ),
      ),
    );
  }

  /// Get property image URL
  String _getPropertyImage(Map<String, dynamic> property) {
    if (property['images'] != null && property['images'].isNotEmpty) {
      final image = property['images'][0]['url']?.toString() ?? '';
      return getImageUrl(image);
    }
    return '';
  }

  /// Build property image widget
  Widget _buildPropertyImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: imageUrl.isNotEmpty
          ? Image.network(
              imageUrl,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) {
                return const Icon(
                  Icons.home,
                  size: 40,
                );
              },
            )
          : const Icon(
              Icons.home,
              size: 40,
            ),
    );
  }

  /// Build property title widget
  Widget _buildPropertyTitle(String title) {
    return Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  /// Build property details widget (location and price)
  Widget _buildPropertyDetails(String location, String price) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        Row(
          children: [
            const Icon(
              Icons.location_on,
              size: 14,
              color: Colors.grey,
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                location,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          price.toPrice(), // Using the extension method
          style: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  /// Build favorite button (remove from favorites)
  Widget _buildFavoriteButton(int propertyId) {
    return IconButton(
      icon: const Icon(
        Icons.favorite,
        color: Colors.red,
      ),
      onPressed: () => removeFavorite(propertyId),
    );
  }
}
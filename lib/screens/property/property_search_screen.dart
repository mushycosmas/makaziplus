import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/property_search_provider.dart';
import '../../widgets/property_card.dart';
import '../property/property_detail_screen.dart';

class PropertySearchScreen extends ConsumerStatefulWidget {
  const PropertySearchScreen({super.key});

  @override
  ConsumerState<PropertySearchScreen> createState() => _PropertySearchScreenState();
}

class _PropertySearchScreenState extends ConsumerState<PropertySearchScreen> {
  final TextEditingController controller = TextEditingController();
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 300),
      () {
        if (mounted) {
          FocusScope.of(context).requestFocus();
        }
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// Handle search
  void search(String value) {
    final trimmed = value.trim();
    
    if (trimmed.isEmpty) {
      ref.read(propertySearchProvider.notifier).clearSearch();
      return;
    }

    ref.read(propertySearchProvider.notifier).searchProperties(value);
  }

  /// Get image URL helper
  String _getImageUrl(dynamic imageData) {
    const baseUrl = "https://makazi.nono.co.tz/uploads/";
    const fallbackImage =
        "https://images.unsplash.com/photo-1600607687939-ce8a6c25118c";

    if (imageData == null) {
      return fallbackImage;
    }

    String? imagePath;

    if (imageData is Map) {
      imagePath = imageData['url'] ?? imageData['image'] ?? imageData['path'];
    } else if (imageData is String) {
      imagePath = imageData;
    } else if (imageData is List && imageData.isNotEmpty) {
      return _getImageUrl(imageData.first);
    }

    if (imagePath != null && imagePath.isNotEmpty) {
      if (imagePath.startsWith('http')) {
        return imagePath;
      }
      return "$baseUrl$imagePath";
    }

    return fallbackImage;
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(propertySearchProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(25),
          ),
          child: TextField(
            controller: controller,
            autofocus: true,
            onChanged: search,
            decoration: InputDecoration(
              hintText: "Search house, apartment, location...",
              border: InputBorder.none,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        controller.clear();
                        ref.read(propertySearchProvider.notifier).clearSearch();
                      },
                    )
                  : null,
            ),
          ),
        ),
      ),
      body: _buildBody(results, screenWidth),
    );
  }

  /// Build body based on search state
  Widget _buildBody(AsyncValue<List<dynamic>> results, double screenWidth) {
    return results.when(
      data: (properties) {
        if (properties.isEmpty && controller.text.trim().isEmpty) {
          return _buildEmptyState();
        }

        if (properties.isEmpty && controller.text.trim().isNotEmpty) {
          return _buildNoResultsState(controller.text.trim());
        }

        return _buildSearchResults(properties, screenWidth);
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) {
        return _buildErrorState(error.toString());
      },
    );
  }

  /// Build empty initial state
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Search Properties',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Type a location, property name, or keyword',
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  /// Build no results state
  Widget _buildNoResultsState(String query) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No results found for "$query"',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search terms',
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  /// Build search results in a two-column grid
  Widget _buildSearchResults(List<dynamic> properties, double screenWidth) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: properties.length,
      itemBuilder: (context, index) {
        final property = properties[index];
        final imageUrl = _getImageUrl(property['images']);

        return PropertyCard(
          image: imageUrl,
          title: property['title'] ?? "Property",
          price: property['price']?.toString() ?? "0",
          status: property['status'] ?? "Available",
          propertyData: property,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PropertyDetailScreen(
                  property: property,
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Build error state with retry
  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to search properties',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              error,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              final query = controller.text.trim();
              if (query.isNotEmpty) {
                ref.read(propertySearchProvider.notifier).searchProperties(query);
              }
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
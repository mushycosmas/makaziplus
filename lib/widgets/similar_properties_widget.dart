// lib/widgets/similar_properties_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/properties_provider.dart';
import '../screens/property/property_detail_screen.dart';
import 'property_card.dart'; // ✅ Import PropertyCard

class SimilarPropertiesWidget extends ConsumerWidget {
  final int currentPropertyId;
  final String? categoryId;
  final String? locationId;
  final String? typeId;

  const SimilarPropertiesWidget({
    super.key,
    required this.currentPropertyId,
    this.categoryId,
    this.locationId,
    this.typeId,
  });

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

  void _navigateToProperty(BuildContext context, Map<String, dynamic> property) {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final propertiesAsync = ref.watch(propertiesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Similar Properties',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),

        propertiesAsync.when(
          data: (properties) {
            // Filter properties - exclude current
            final filteredProperties = properties
                .where((p) => p['id'] != currentPropertyId)
                .toList();

            if (filteredProperties.isEmpty) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 30),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Icon(
                      Icons.house_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No similar properties found',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }

            // ✅ Sort by relevance (category match first, then location)
            final sortedProperties = filteredProperties.map((p) {
              int relevanceScore = 0;
              
              // Category match (highest relevance)
              if (categoryId != null && p['categoryId']?.toString() == categoryId) {
                relevanceScore += 10;
              }
              
              // Location match (medium relevance)
              if (locationId != null && p['wardId']?.toString() == locationId) {
                relevanceScore += 5;
              }
              
              // Type match (some relevance)
              if (typeId != null && p['typeId']?.toString() == typeId) {
                relevanceScore += 3;
              }
              
              return {
                'property': p,
                'relevance': relevanceScore,
              };
            }).toList()
            ..sort((a, b) => b['relevance'] - a['relevance']);

            // Take top 5
            final similarProperties = sortedProperties
                .take(5)
                .map((item) => item['property'] as Map<String, dynamic>)
                .toList();

            if (similarProperties.isEmpty) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 30),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Icon(
                      Icons.house_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No similar properties found',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }

            return SizedBox(
              height: 260,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: similarProperties.length,
                itemBuilder: (context, index) {
                  final p = similarProperties[index];
                  final images = p['images'] as List? ?? [];
                  final imageUrl = images.isNotEmpty
                      ? _getImageUrl(images.first)
                      : "https://images.unsplash.com/photo-1600607687939-ce8a6c25118c";

                  // ✅ Use PropertyCard for consistency
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    margin: const EdgeInsets.only(right: 12),
                    child: PropertyCard(
                      image: imageUrl,
                      title: p['title'] ?? 'Property',
                      price: p['price']?.toString() ?? '0',
                      status: p['status'] ?? 'Available',
                      propertyData: p,
                      onTap: () => _navigateToProperty(context, p),
                    ),
                  );
                },
              ),
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (error, _) => Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            alignment: Alignment.center,
            child: Column(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red[300],
                  size: 40,
                ),
                const SizedBox(height: 8),
                Text(
                  'Failed to load similar properties',
                  style: TextStyle(
                    color: Colors.red[300],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
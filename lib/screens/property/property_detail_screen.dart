// lib/screens/property/property_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../widgets/similar_properties_widget.dart';

class PropertyDetailScreen extends StatefulWidget {
  final Map<String, dynamic> property;

  const PropertyDetailScreen({
    super.key,
    required this.property,
  });

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  bool isFavorite = false;

  String _formatPrice(String price) {
    try {
      final cleanPrice = price.replaceAll(RegExp(r'[^0-9.]'), '');
      final doubleValue = double.tryParse(cleanPrice) ?? 0;
      final formatter = NumberFormat('#,###', 'en_US');
      final formatted = formatter.format(doubleValue);
      return 'TSh $formatted';
    } catch (e) {
      return 'TSh $price';
    }
  }

  String _getFullLocation() {
    final ward = widget.property['ward'];
    final district = ward?['district'];
    final region = district?['region'];
    final country = region?['country'];
    
    final parts = [
      ward?['name'],
      district?['name'],
      region?['name'],
      country?['name'],
    ].where((part) => part != null && part.isNotEmpty).toList();
    
    return parts.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final property = widget.property;
    final images = property['images'] as List? ?? [];
    final amenities = property['amenities'] as List? ?? [];
    final user = property['user'];
    final category = property['category'];
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.black,
            ),
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =========================
            // IMAGE CAROUSEL
            // =========================
            SizedBox(
              height: 300,
              width: double.infinity,
              child: images.isNotEmpty
                  ? PageView.builder(
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        final image = images[index];
                        final imageUrl = image['url'] ?? '';
                        return Image.network(
                          'https://makazi.nono.co.tz/uploads/$imageUrl',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.broken_image,
                              size: 60,
                              color: Colors.grey,
                            ),
                          ),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                        );
                      },
                    )
                  : Container(
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 60,
                        color: Colors.grey,
                      ),
                    ),
            ),

            // Image count indicator
            if (images.length > 1)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    images.length,
                    (index) => Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index == 0 ? Colors.blue : Colors.grey[300],
                      ),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // =========================
            // CONTENT
            // =========================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price
                  Text(
                    _formatPrice(property['price'] ?? '0'),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF22C55E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: property['status'] == 'AVAILABLE'
                          ? Colors.green.withOpacity(0.1)
                          : Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: property['status'] == 'AVAILABLE'
                            ? Colors.green
                            : Colors.orange,
                      ),
                    ),
                    child: Text(
                      property['status'] ?? 'Available',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: property['status'] == 'AVAILABLE'
                            ? Colors.green
                            : Colors.orange,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Title
                  Text(
                    property['title'] ?? 'Property',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 18,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          _getFullLocation(),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Category
                  Row(
                    children: [
                      Icon(
                        Icons.category,
                        size: 18,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        category?['name'] ?? 'Uncategorized',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // =========================
                  // PROPERTY FEATURES
                  // =========================
                  const Text(
                    'Features',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildFeatureItem(
                            Icons.bed,
                            'Bedrooms',
                            '${property['bedrooms'] ?? 0}',
                          ),
                        ),
                        Expanded(
                          child: _buildFeatureItem(
                            Icons.bathroom,
                            'Bathrooms',
                            '${property['bathrooms'] ?? 0}',
                          ),
                        ),
                        Expanded(
                          child: _buildFeatureItem(
                            Icons.square_foot,
                            'Area',
                            '${property['size'] ?? 0} sqm',
                          ),
                        ),
                        Expanded(
                          child: _buildFeatureItem(
                            Icons.calendar_today,
                            'Year Built',
                            '${property['yearBuilt'] ?? 'N/A'}',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // =========================
                  // DESCRIPTION
                  // =========================
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    property['description'] ?? 'No description available.',
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // =========================
                  // AMENITIES
                  // =========================
                  if (amenities.isNotEmpty) ...[
                    const Text(
                      'Amenities',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: amenities.map((item) {
                        final amenity = item['amenity'];
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.blue.withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 14,
                                color: Colors.blue[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                amenity?['name'] ?? '',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue[800],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // =========================
                  // AGENT / OWNER
                  // =========================
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blue[100],
                          child: Text(
                            user?['fullName']?.substring(0, 1) ?? 'U',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?['fullName'] ?? 'Unknown',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                user?['email'] ?? '',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                'Agent',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // TODO: Contact agent
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF22C55E),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Contact'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // =========================
                  // SIMILAR PROPERTIES (ADDED)
                  // =========================
                  SimilarPropertiesWidget(
                    currentPropertyId: property['id'] ?? 0,
                    categoryId: property['categoryId']?.toString(),
                    locationId: property['wardId']?.toString(),
                    typeId: property['typeId']?.toString(),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Contact agent via phone
                },
                icon: const Icon(Icons.phone),
                label: const Text('Call Agent'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Schedule viewing
                },
                icon: const Icon(Icons.calendar_today),
                label: const Text('Schedule View'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF22C55E),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Colors.grey[700]),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
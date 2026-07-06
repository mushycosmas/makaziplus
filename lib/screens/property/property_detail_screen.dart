// lib/screens/property/property_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../widgets/similar_properties_widget.dart';
import '../../widgets/agent_contact_widget.dart';
import '../../api/user_property_favorite_api.dart';

class PropertyDetailScreen extends StatefulWidget {
  final Map<String, dynamic> property;
  final int? userId; // Add userId parameter

  const PropertyDetailScreen({
    super.key,
    required this.property,
    this.userId,
  });

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  bool isFavorite = false;
  bool isLoadingFavorite = false;
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();

  // Get userId from widget or use default
  int get userId => widget.userId ?? 1; // Should come from auth context

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadFavoriteStatus() async {
    final propertyId = widget.property['id'];
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
      debugPrint('Failed to load favorite status: $e');
      // Set default state
      if (mounted) {
        setState(() {
          isFavorite = false;
        });
      }
    }
  }

  Future<void> _toggleFavorite() async {
    final propertyId = widget.property['id'];
    if (propertyId == null || userId <= 0) {
      _showSnackBar('Please login to add favorites', Colors.orange);
      return;
    }

    if (isLoadingFavorite) return;

    setState(() {
      isLoadingFavorite = true;
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
          _showSnackBar('Removed from favorites', Colors.green);
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
          _showSnackBar('Added to favorites', Colors.green);
        }
      }

      if (!success && mounted) {
        _showSnackBar(
          isFavorite ? 'Failed to remove from favorites' : 'Failed to add to favorites',
          Colors.red,
        );
      }
    } catch (e) {
      debugPrint('Favorite error: $e');
      if (mounted) {
        _showSnackBar('An error occurred: ${e.toString()}', Colors.red);
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoadingFavorite = false;
        });
      }
    }
  }

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
    try {
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
      
      return parts.isNotEmpty ? parts.join(', ') : 'Location not specified';
    } catch (e) {
      return 'Location not specified';
    }
  }

  void _callAgent(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      _showSnackBar('Agent phone number not available', Colors.orange);
      return;
    }
    // Implement phone call functionality
    // Example: launch('tel:$phoneNumber');
    _showSnackBar('Calling ${_formatPhoneNumber(phoneNumber)}...', Colors.blue);
  }

  void _scheduleViewing() {
    // Implement schedule viewing functionality
    _showSnackBar('Schedule viewing feature coming soon!', Colors.blue);
  }

  String _formatPhoneNumber(String phone) {
    // Format phone number for display
    if (phone.length == 10) {
      return '${phone.substring(0, 3)}-${phone.substring(3, 6)}-${phone.substring(6)}';
    }
    return phone;
  }

  @override
  Widget build(BuildContext context) {
    final property = widget.property;
    final images = property['images'] as List? ?? [];
    final amenities = property['amenities'] as List? ?? [];
    final user = property['user'];
    final category = property['category'];
    final status = property['status']?.toString().toUpperCase() ?? 'AVAILABLE';
    final isAvailable = status == 'AVAILABLE';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          // Favorite button with loading state
          IconButton(
            icon: isLoadingFavorite
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.red,
                    ),
                  )
                : Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.black,
                  ),
            onPressed: isLoadingFavorite ? null : _toggleFavorite,
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
            _buildImageCarousel(images),

            // Image indicator
            if (images.length > 1) _buildImageIndicator(images.length),

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
                    _formatPrice(property['price']?.toString() ?? '0'),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF22C55E),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Status & Category Row
                  Row(
                    children: [
                      _buildStatusBadge(isAvailable, status),
                      const SizedBox(width: 8),
                      _buildCategoryChip(category?['name'] ?? 'Uncategorized'),
                    ],
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
                  _buildInfoRow(
                    Icons.location_on,
                    _getFullLocation(),
                  ),
                  const SizedBox(height: 4),

                  // Property ID / Reference
                  if (property['propertyId'] != null)
                    _buildInfoRow(
                      Icons.tag,
                      'Ref: ${property['propertyId']}',
                    ),
                  const SizedBox(height: 20),

                  // =========================
                  // PROPERTY FEATURES
                  // =========================
                  _buildFeaturesSection(property),
                  const SizedBox(height: 20),

                  // =========================
                  // DESCRIPTION
                  // =========================
                  _buildDescriptionSection(property['description']),
                  const SizedBox(height: 20),

                  // =========================
                  // AMENITIES
                  // =========================
                  if (amenities.isNotEmpty) 
                    _buildAmenitiesSection(amenities),
                  const SizedBox(height: 20),

                  // =========================
                  // AGENT CONTACT WIDGET
                  // =========================
                  AgentContactWidget(
                    fullName: user?['fullName'] ?? 'Unknown Agent',
                    email: user?['email'],
                    phone: user?['phone'],
                    whatsapp: user?['whatsapp'] ?? user?['phone'],
                    avatar: user?['avatar'],
                    isAvailable: true,
                    role: 'Agent',
                  ),
                  const SizedBox(height: 24),

                  // =========================
                  // SIMILAR PROPERTIES
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
      bottomNavigationBar: _buildBottomActions(user?['phone']),
    );
  }

  // =========================
  // HELPER BUILD METHODS
  // =========================

  Widget _buildImageCarousel(List images) {
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: images.isNotEmpty
          ? PageView.builder(
              controller: _pageController,
              itemCount: images.length,
              onPageChanged: (index) {
                setState(() {
                  _currentImageIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final image = images[index];
                final imageUrl = image['url'] ?? '';
                final fullUrl = imageUrl.startsWith('http')
                    ? imageUrl
                    : 'https://makazi.nono.co.tz/uploads/$imageUrl';

                return Image.network(
                  fullUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.broken_image,
                          size: 60,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Image $index not available',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
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
                );
              },
            )
          : Container(
              color: Colors.grey[200],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_not_supported,
                    size: 60,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No images available',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildImageIndicator(int imageCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          imageCount,
          (index) => Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index == _currentImageIndex ? Colors.blue : Colors.grey[300],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(bool isAvailable, String status) {
    final color = isAvailable ? Colors.green : Colors.orange;
    final label = isAvailable ? 'AVAILABLE' : 'SOLD';
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String categoryName) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Text(
        categoryName,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesSection(Map<String, dynamic> property) {
    final features = [
      {'icon': Icons.bed, 'label': 'Bedrooms', 'value': '${property['bedrooms'] ?? 0}'},
      {'icon': Icons.bathroom, 'label': 'Bathrooms', 'value': '${property['bathrooms'] ?? 0}'},
      {'icon': Icons.square_foot, 'label': 'Area', 'value': '${property['size'] ?? 0} sqm'},
      {'icon': Icons.calendar_today, 'label': 'Year Built', 'value': property['yearBuilt']?.toString() ?? 'N/A'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: features.map((feature) {
              return Expanded(
                child: Column(
                  children: [
                    Icon(feature['icon'] as IconData, 
                      size: 24, 
                      color: Colors.grey[700],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      feature['value'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      feature['label'] as String,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(String? description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description?.isNotEmpty == true ? description! : 'No description available.',
          style: const TextStyle(
            fontSize: 14,
            height: 1.6,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildAmenitiesSection(List amenities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            final name = amenity?['name'] ?? '';
            final icon = _getAmenityIcon(name);
            
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blue.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 14, color: Colors.blue[600]),
                  const SizedBox(width: 4),
                  Text(
                    name,
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
      ],
    );
  }

  IconData _getAmenityIcon(String amenityName) {
    final lowerName = amenityName.toLowerCase();
    if (lowerName.contains('parking')) return Icons.local_parking;
    if (lowerName.contains('pool')) return Icons.pool;
    if (lowerName.contains('gym')) return Icons.fitness_center;
    if (lowerName.contains('wifi')) return Icons.wifi;
    if (lowerName.contains('security')) return Icons.security;
    if (lowerName.contains('garden')) return Icons.grass;
    if (lowerName.contains('kitchen')) return Icons.kitchen;
    if (lowerName.contains('ac') || lowerName.contains('air')) return Icons.ac_unit;
    return Icons.check_circle;
  }

  Widget _buildBottomActions(String? phoneNumber) {
    return Container(
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
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _callAgent(phoneNumber),
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
                onPressed: _scheduleViewing,
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
}
// screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/categories_provider.dart';
import '../../providers/properties_provider.dart';
import '../../providers/agents_provider.dart';

import '../../widgets/category_box.dart';
import '../../widgets/hero_section.dart';
import '../../widgets/property_card.dart';
import '../../widgets/property_type_card.dart';
import '../../widgets/search_bar_widget.dart';
import '../../widgets/section_title.dart';
import '../../widgets/top_bar.dart';
import '../../widgets/agent_section.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  // ✅ Helper to get image URL
 String _getImageUrl(dynamic imageData) {
  const String baseUrl = "https://makazi.nono.co.tz/uploads/";
  const String fallbackImage =
      "https://images.unsplash.com/photo-1600607687939-ce8a6c25118c";

  if (imageData == null) return fallbackImage;

  String? imagePath;

  // If it's a Map
  if (imageData is Map) {
    imagePath = imageData['url'] ?? imageData['image'] ?? imageData['path'];
  }
  // If it's a String
  else if (imageData is String) {
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
  }
  // If it's a List
  else if (imageData is List && imageData.isNotEmpty) {
    return _getImageUrl(imageData.first);
  }

  if (imagePath != null && imagePath.isNotEmpty) {
    // 🔥 PRINT RAW IMAGE PATH
   // print("🖼️ Image path: $imagePath");

    // Don't double-add base URL
    if (imagePath.startsWith('http')) {
      return imagePath;
    }

    final fullUrl = '$baseUrl$imagePath';

    return fullUrl;
  }

  print("⚠️ Using fallback image");
  return fallbackImage;
}
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final propertiesAsync = ref.watch(propertiesProvider);
    final agentsAsync = ref.watch(agentsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// TOP BAR
              const TopBar(),
              const SizedBox(height: 30),

              /// HERO
              const HeroSection(),
              const SizedBox(height: 30),

              /// SEARCH
              const SearchBarWidget(),
              const SizedBox(height: 30),

              /// PROPERTY TYPES
              const SectionTitle(title: "Property Types"),
              const SizedBox(height: 15),

              SizedBox(
                height: 110,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    PropertyTypeCard(icon: Icons.home, title: "All", active: true),
                    PropertyTypeCard(icon: Icons.home_outlined, title: "House"),
                    PropertyTypeCard(icon: Icons.apartment, title: "Apartment"),
                    PropertyTypeCard(icon: Icons.park, title: "Land"),
                    PropertyTypeCard(icon: Icons.business, title: "Office"),
                    PropertyTypeCard(icon: Icons.store, title: "Shop"),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// FEATURED PROPERTIES
              const SectionTitle(title: "Featured Properties"),
              const SizedBox(height: 20),

              propertiesAsync.when(
                data: (properties) {
                  if (properties.isEmpty) {
                    return const Text(
                      "No properties found",
                      style: TextStyle(color: Colors.grey),
                    );
                  }
                  return SizedBox(
                    height: 240,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: properties.length > 5 ? 5 : properties.length,
                      itemBuilder: (context, index) {
                        final p = properties[index];
                        
                        // ✅ Use the helper to get image URL
                        final imageUrl = _getImageUrl(p['images']);

                        return Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          margin: const EdgeInsets.only(right: 12),
                          child: PropertyCard(
                            image: imageUrl,
                            title: p['title'] ?? 'Property',
                            price: "TZS ${p['price'] ?? 0}",
                            status: p['status'] ?? 'Available',
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
                error: (error, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red[300], size: 40),
                        const SizedBox(height: 8),
                        Text(
                          'Failed to load properties',
                          style: TextStyle(color: Colors.red[300]),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => ref.refresh(propertiesProvider),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// CATEGORY SECTION
              const SectionTitle(title: "Browse by Category"),
              const SizedBox(height: 20),

              categoriesAsync.when(
                data: (categories) {
                  if (categories.isEmpty) {
                    return const Text(
                      "No categories found",
                      style: TextStyle(color: Colors.grey),
                    );
                  }
                  return SizedBox(
                    height: 130,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length > 6 ? 6 : categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: CategoryBox(
                            category: category,
                            color: Colors.green.shade50,
                            onTap: () {
                              debugPrint("Category: ${category['name']}");
                            },
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
                error: (error, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red[300], size: 40),
                        const SizedBox(height: 8),
                        Text(
                          'Failed to load categories',
                          style: TextStyle(color: Colors.red[300]),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => ref.refresh(categoriesProvider),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// AGENTS
              agentsAsync.when(
                data: (agents) => const AgentSection(),
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, _) => const SizedBox.shrink(),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
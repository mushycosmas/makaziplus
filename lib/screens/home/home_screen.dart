import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/categories_provider.dart';
import '../../providers/properties_provider.dart';
import '../../providers/agents_provider.dart';

import '../../widgets/category_box.dart';
import '../../widgets/hero_section.dart';
import '../../widgets/property_card.dart';
import '../../widgets/search_bar_widget.dart';
import '../../widgets/section_title.dart';
import '../../widgets/top_bar.dart';
import '../../widgets/agent_section.dart';

import '../property/property_detail_screen.dart';
import '../property/property_search_screen.dart';
import '../property/all_properties_screen.dart';
import '../property/all_categories_screen.dart';
import '../agents/all_agents_screen.dart';
// Removed: import '../agents/agent_profile_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

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
      if (imagePath.startsWith("http")) {
        return imagePath;
      }
      return "$baseUrl$imagePath";
    }

    return fallbackImage;
  }

  /// Convert API category data to include totalProperties
  Map<String, dynamic> _prepareCategoryData(Map<String, dynamic> category) {
    final propertyCount = category['_count']?['properties'] ?? 0;
    return {
      ...category,
      'totalProperties': propertyCount,
    };
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
              // Top Bar
              const TopBar(),
              const SizedBox(height: 30),

              // Hero Section
              const HeroSection(),
              const SizedBox(height: 30),

              // SEARCH
              SearchBarWidget(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PropertySearchScreen(),
                    ),
                  );
                },
                onFilterPressed: () {
                  debugPrint("Open filters");
                },
              ),
              const SizedBox(height: 30),

              // FEATURED PROPERTIES
              SectionTitle(
                title: "Featured Properties",
                onSeeAll: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AllPropertiesScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              propertiesAsync.when(
                data: (properties) {
                  if (properties.isEmpty) {
                    return Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.home_work_outlined,
                              size: 48,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 12),
                            Text(
                              "No properties found",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return SizedBox(
                    height: 240,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: properties.length > 5 ? 5 : properties.length,
                      itemBuilder: (context, index) {
                        final property = properties[index];
                        return Container(
                          width: MediaQuery.of(context).size.width * .45,
                          margin: const EdgeInsets.only(right: 12),
                          child: PropertyCard(
                            image: _getImageUrl(property['images']),
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
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => const SizedBox(
                  height: 200,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (e, _) => Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red.shade400,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Failed to load properties",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red.shade400,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () => ref.refresh(propertiesProvider),
                          icon: const Icon(Icons.refresh, size: 18),
                          label: const Text("Retry"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // CATEGORIES
              SectionTitle(
                title: "Browse by Category",
                onSeeAll: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AllCategoriesScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              categoriesAsync.when(
                data: (categories) {
                  if (categories.isEmpty) {
                    return Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          "No categories found",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  }

                  return SizedBox(
                    height: 160,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      itemCount: categories.length > 6 ? 6 : categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        
                        // Prepare category data with totalProperties
                        final preparedCategory = _prepareCategoryData(category);
                        
                        // Color palette
                        final colors = [
                          Colors.blue,
                          Colors.green,
                          Colors.orange,
                          Colors.purple,
                          Colors.red,
                          Colors.pink,
                          Colors.teal,
                          Colors.indigo,
                        ];

                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: CategoryBox(
                            category: preparedCategory,
                            color: colors[index % colors.length],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AllPropertiesScreen(
                                    category: category['name'],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => const SizedBox(
                  height: 120,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (e, _) => Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 32,
                          color: Colors.red.shade400,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Failed to load categories",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.red.shade400,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: () => ref.refresh(categoriesProvider),
                          icon: const Icon(Icons.refresh, size: 16),
                          label: const Text("Retry"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // AGENTS
              SectionTitle(
                title: "Top Agents",
                onSeeAll: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AllAgentsScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // AgentSection handles its own data fetching and navigation
              const AgentSection(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
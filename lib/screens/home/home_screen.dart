import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/category_provider.dart';
import '../../providers/property_provider.dart';

import '../../widgets/agent_card.dart';
import '../../widgets/category_box.dart';
import '../../widgets/hero_section.dart';
import '../../widgets/property_card.dart';
import '../../widgets/property_type_card.dart';
import '../../widgets/search_bar_widget.dart';
import '../../widgets/section_title.dart';
import '../../widgets/top_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryProvider>().fetchCategories();
      context.read<PropertyProvider>().fetchProperties();
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();
    final propertyProvider = context.watch<PropertyProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopBar(),
              const SizedBox(height: 30),

              const HeroSection(),
              const SizedBox(height: 30),

              const SearchBarWidget(),
              const SizedBox(height: 30),

              /// PROPERTY TYPES
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

              if (propertyProvider.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (propertyProvider.properties.isEmpty)
                const Text("No properties found")
              else
                SizedBox(
                  height: 330,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: propertyProvider.properties.length,
                    itemBuilder: (context, index) {
                      final p = propertyProvider.properties[index];

                      final imageUrl = (p.images.isNotEmpty)
    ? "https://makazi.nono.co.tz/uploads/${p.images.first}"
    : "https://images.unsplash.com/photo-1600607687939-ce8a6c25118c";

                      return PropertyCard(
                        image: imageUrl,
                        title: p.title,
                        price: "TZS ${p.price}",
                        location: p.status, // FIX enum safe
                      );
                    },
                  ),
                ),

              const SizedBox(height: 30),

              /// CATEGORY SECTION
              const SectionTitle(title: "Browse by Category"),
              const SizedBox(height: 20),

              if (categoryProvider.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (categoryProvider.errorMessage != null)
                Text(
                  categoryProvider.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: categoryProvider.categories.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1.2,
                  ),
                  itemBuilder: (context, index) {
                    final category = categoryProvider.categories[index];

                    return CategoryBox(
                      category: category,
                      color: Colors.green.shade50,
                      onTap: () {
                        debugPrint("Category: ${category.name}");
                      },
                    );
                  },
                ),

              const SizedBox(height: 30),

              /// AGENTS
              const SectionTitle(title: "Top Agents"),
              const SizedBox(height: 20),

              SizedBox(
                height: 140,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    AgentCard(
                      name: "John Mwita",
                      properties: "25 Properties",
                      rating: "4.8",
                    ),
                    AgentCard(
                      name: "Neema Said",
                      properties: "18 Properties",
                      rating: "4.7",
                    ),
                    AgentCard(
                      name: "Paul Mushi",
                      properties: "30 Properties",
                      rating: "4.9",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/category_provider.dart';
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

    /// ✅ SAFE: runs after first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider =
          Provider.of<CategoryProvider>(context, listen: false);

      provider.fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
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

              const SectionTitle(title: "Featured Properties"),
              const SizedBox(height: 20),

              SizedBox(
                height: 330,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    PropertyCard(
                      image:
                          "https://images.unsplash.com/photo-1600607687939-ce8a6c25118c",
                      title: "Modern 4 Bedroom House",
                      price: "TZS 350,000,000",
                      location: "Masaki, Dar es Salaam",
                    ),
                    PropertyCard(
                      image:
                          "https://images.unsplash.com/photo-1568605114967-8130f3a36994",
                      title: "Luxury Apartment",
                      price: "TZS 2,500,000 / Month",
                      location: "Oysterbay, Dar es Salaam",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              const SectionTitle(title: "Browse by Category"),
              const SizedBox(height: 20),

              /// 🔥 CATEGORY SECTION (SAFE + STABLE)
              Consumer<CategoryProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (provider.errorMessage != null) {
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                          provider.errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    );
                  }

                  if (provider.categories.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: Text("No categories found"),
                      ),
                    );
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.categories.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 1.2,
                    ),
                    itemBuilder: (context, index) {
                      final category = provider.categories[index];

                      return CategoryBox(
                        category: category,
                        color: Colors.green.shade50,
                        onTap: () {
                          debugPrint("Clicked: ${category.name}");
                        },
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 30),

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
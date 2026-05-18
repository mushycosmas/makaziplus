import 'package:flutter/material.dart';

import '../../widgets/agent_card.dart';
import '../../widgets/category_box.dart';
import '../../widgets/hero_section.dart';
import '../../widgets/property_card.dart';
import '../../widgets/property_type_card.dart';
import '../../widgets/search_bar_widget.dart';
import '../../widgets/section_title.dart';
import '../../widgets/top_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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

              // TOP BAR
              const TopBar(),
              const SizedBox(height: 30),

              // HERO
              const HeroSection(),
              const SizedBox(height: 30),

              // SEARCH
              const SearchBarWidget(),
              const SizedBox(height: 30),

              // PROPERTY TYPES
              SizedBox(
                height: 110,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    PropertyTypeCard(
                      icon: Icons.home,
                      title: "All",
                      active: true,
                    ),
                    PropertyTypeCard(
                      icon: Icons.home_outlined,
                      title: "House",
                    ),
                    PropertyTypeCard(
                      icon: Icons.apartment,
                      title: "Apartment",
                    ),
                    PropertyTypeCard(
                      icon: Icons.park,
                      title: "Land",
                    ),
                    PropertyTypeCard(
                      icon: Icons.business,
                      title: "Office",
                    ),
                    PropertyTypeCard(
                      icon: Icons.store,
                      title: "Shop",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // FEATURED
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

              // CATEGORY
              const SectionTitle(title: "Browse by Category"),
              const SizedBox(height: 20),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.2,
                children: [
                  CategoryBox(
                    title: "Houses",
                    listings: "120+ Listings",
                    icon: Icons.home,
                    color: Colors.green.shade50,
                  ),
                  CategoryBox(
                    title: "Apartments",
                    listings: "85+ Listings",
                    icon: Icons.apartment,
                    color: Colors.purple.shade50,
                  ),
                  CategoryBox(
                    title: "Lands",
                    listings: "150+ Listings",
                    icon: Icons.landscape,
                    color: Colors.orange.shade50,
                  ),
                  CategoryBox(
                    title: "Commercial",
                    listings: "60+ Listings",
                    icon: Icons.business,
                    color: Colors.blue.shade50,
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // AGENTS (FIXED)
              const SectionTitle(title: "Top Agents"),
              const SizedBox(height: 20),

              SizedBox(
                height: 140, // ✅ FIXED HERE
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
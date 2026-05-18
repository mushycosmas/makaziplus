import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // BOTTOM NAVIGATION
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: const Color(0xFF22C55E),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Iconsax.home_15),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.search_normal),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 40),
            label: "Add Property",
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.heart),
            label: "Favorites",
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.user),
            label: "Profile",
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // TOP BAR
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.menu, size: 30),
                      ),

                      const SizedBox(width: 10),

                      const Icon(Iconsax.location),

                      const SizedBox(width: 5),

                      const Text(
                        "Dar es Salaam",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Icon(Icons.keyboard_arrow_down),
                    ],
                  ),

                  Stack(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.notifications_none, size: 30),
                      ),

                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              "3",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // HERO SECTION
              Row(
                children: [

                  // LEFT TEXT
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [

                        Text(
                          "Find your",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                          ),
                        ),

                        Text(
                          "perfect property",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF22C55E),
                            height: 1.1,
                          ),
                        ),

                        SizedBox(height: 20),

                        Text(
                          "Buy, rent or find the best places to call home.",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 20),

                  // IMAGE
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image.network(
                        "https://images.unsplash.com/photo-1600585154526-990dced4db0d",
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // SEARCH BAR
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  children: [

                    const SizedBox(width: 10),

                    const Icon(Iconsax.search_normal),

                    const SizedBox(width: 10),

                    const Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText:
                              "Search by location, property type...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFF22C55E),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.tune,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // PROPERTY TYPES
              SizedBox(
                height: 110,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [

                    buildTypeCard(
                      icon: Icons.home,
                      title: "All",
                      active: true,
                    ),

                    buildTypeCard(
                      icon: Icons.home_outlined,
                      title: "House",
                    ),

                    buildTypeCard(
                      icon: Icons.apartment,
                      title: "Apartment",
                    ),

                    buildTypeCard(
                      icon: Icons.park,
                      title: "Land",
                    ),

                    buildTypeCard(
                      icon: Icons.business,
                      title: "Office",
                    ),

                    buildTypeCard(
                      icon: Icons.store,
                      title: "Shop",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // FEATURED
              sectionTitle("Featured Properties"),

              const SizedBox(height: 20),

              SizedBox(
                height: 330,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [

                    propertyCard(
                      image:
                          "https://images.unsplash.com/photo-1600607687939-ce8a6c25118c",
                      title: "Modern 4 Bedroom House",
                      price: "TZS 350,000,000",
                      location: "Masaki, Dar es Salaam",
                    ),

                    propertyCard(
                      image:
                          "https://images.unsplash.com/photo-1568605114967-8130f3a36994",
                      title: "Luxury 2 Bedroom Apartment",
                      price: "TZS 2,500,000 / Month",
                      location: "Oysterbay, Dar es Salaam",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // CATEGORY
              sectionTitle("Browse by Category"),

              const SizedBox(height: 20),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.2,
                children: [

                  categoryBox(
                    title: "Houses",
                    listings: "120+ Listings",
                    icon: Icons.home,
                    color: Colors.green.shade50,
                  ),

                  categoryBox(
                    title: "Apartments",
                    listings: "85+ Listings",
                    icon: Icons.apartment,
                    color: Colors.purple.shade50,
                  ),

                  categoryBox(
                    title: "Lands",
                    listings: "150+ Listings",
                    icon: Icons.landscape,
                    color: Colors.orange.shade50,
                  ),

                  categoryBox(
                    title: "Commercial",
                    listings: "60+ Listings",
                    icon: Icons.business,
                    color: Colors.blue.shade50,
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // AGENTS
              sectionTitle("Top Agents"),

              const SizedBox(height: 20),

              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [

                    agentCard(
                      name: "John Mwita",
                      properties: "25 Properties",
                      rating: "4.8",
                    ),

                    agentCard(
                      name: "Neema Said",
                      properties: "18 Properties",
                      rating: "4.7",
                    ),

                    agentCard(
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

  // SECTION TITLE
  Widget sectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Text(
          title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),

        Row(
          children: const [
            Text(
              "See all",
              style: TextStyle(
                color: Color(0xFF22C55E),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 5),
            Icon(
              Icons.arrow_forward,
              color: Color(0xFF22C55E),
            ),
          ],
        ),
      ],
    );
  }

  // TYPE CARD
  Widget buildTypeCard({
    required IconData icon,
    required String title,
    bool active = false,
  }) {
    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: 15),
      child: Column(
        children: [

          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: active
                  ? const Color(0xFF22C55E)
                  : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Icon(
              icon,
              color: active ? Colors.white : Colors.black,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            title,
            style: TextStyle(
              color: active
                  ? const Color(0xFF22C55E)
                  : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // PROPERTY CARD
  Widget propertyCard({
    required String image,
    required String title,
    required String price,
    required String location,
  }) {
    return Container(
      width: 320,
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [

          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(25),
            ),
            child: Image.network(
              image,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  price,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [

                    const Icon(
                      Icons.location_on_outlined,
                      color: Colors.grey,
                    ),

                    const SizedBox(width: 5),

                    Text(
                      location,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // CATEGORY BOX
  Widget categoryBox({
    required String title,
    required String listings,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Icon(icon, size: 40),

          const SizedBox(height: 20),

          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            listings,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // AGENT CARD
  Widget agentCard({
    required String name,
    required String properties,
    required String rating,
  }) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [

          const CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
              "https://i.pravatar.cc/300",
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  properties,
                  style: const TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 5),

                Row(
                  children: [

                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 18,
                    ),

                    const SizedBox(width: 5),

                    Text(rating),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
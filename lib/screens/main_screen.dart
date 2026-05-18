import 'package:flutter/material.dart';

import '../screens/home/home_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/favorites/favorites_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/seller/sell_property_screen.dart';
import '../widgets/bottom_navbar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();

    pages = [
      const HomeScreen(),
      const SearchScreen(),
      const SellPropertyScreen(),
      const FavoritesScreen(),
      const ProfileScreen(),
    ];
  }

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar: BottomNavbar(
        currentIndex: currentIndex,
        onTap: onTabTapped,
      ),
    );
  }
}
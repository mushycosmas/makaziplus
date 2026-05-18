import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class BottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: const Color(0xFF22C55E),
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      onTap: onTap,
      items: const [

        BottomNavigationBarItem(
          icon: Icon(Iconsax.home),
          label: "Home",
        ),

        BottomNavigationBarItem(
          icon: Icon(Iconsax.search_normal),
          label: "Search",
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle, size: 40),
          label: "Add",
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
    );
  }
}
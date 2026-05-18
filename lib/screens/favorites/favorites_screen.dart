import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      appBar: AppBar(
        title: const Text(
          "Favorites",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(Iconsax.heart, size: 50, color: Colors.grey),

            SizedBox(height: 10),

            Text(
              "No favorite properties yet",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
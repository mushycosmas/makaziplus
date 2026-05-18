import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      appBar: AppBar(
        title: const Text(
          "Search Properties",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // SEARCH BAR
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Search by location, price...",
                  border: InputBorder.none,
                  icon: Icon(Iconsax.search_normal),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Expanded(
              child: Center(
                child: Text(
                  "Search results will appear here",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
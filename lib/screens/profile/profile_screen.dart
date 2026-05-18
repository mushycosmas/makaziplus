import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      appBar: AppBar(
        title: const Text(
          "Profile",
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

            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.green,
              child: Icon(Iconsax.user, color: Colors.white, size: 30),
            ),

            const SizedBox(height: 10),

            const Text(
              "User Name",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            _tile(Iconsax.home, "My Listings"),
            _tile(Iconsax.setting, "Settings"),
            _tile(Iconsax.logout, "Logout"),
          ],
        ),
      ),
    );
  }

  Widget _tile(IconData icon, String title) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
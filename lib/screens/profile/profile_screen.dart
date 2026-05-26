import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../seller/my_listings_screen.dart';
import '../profile/setting_screen.dart';
import '../../screens/main_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.green,
              child: Icon(Iconsax.user, color: Colors.white),
            ),

            const SizedBox(height: 10),

            const Text("User Name",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            const SizedBox(height: 20),

            _tile(Iconsax.home, "My Listings", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MyListingsScreen(),
                ),
              );
            }),

            _tile(Iconsax.setting, "Settings", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingScreen(),
                ),
              );
            }),

            _tile(Iconsax.logout, "Logout", () {
              MainScreen.changeTab(0); // 👈 return to home tab if needed
            }),
          ],
        ),
      ),
    );
  }

  Widget _tile(IconData icon, String title, VoidCallback onTap) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [

          ListTile(
            leading: Icon(Iconsax.notification),
            title: Text("New property added"),
            subtitle: Text("A new listing is available near you"),
          ),

          Divider(),

          ListTile(
            leading: Icon(Iconsax.heart),
            title: Text("Saved property update"),
            subtitle: Text("Price has changed for your favorite listing"),
          ),

          Divider(),

          ListTile(
            leading: Icon(Iconsax.user),
            title: Text("Profile update"),
            subtitle: Text("Your profile was successfully updated"),
          ),
        ],
      ),
    );
  }
}
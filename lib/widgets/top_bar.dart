import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../screens/notifications/notification_screen.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        // MENU
        IconButton(
          onPressed: () {
            Scaffold.of(context).openDrawer(); // optional if you use Drawer
          },
          icon: const Icon(Icons.menu, size: 28),
        ),

        // LOCATION
        const Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Iconsax.location, size: 18),
              SizedBox(width: 6),

              Flexible(
                child: Text(
                  "Dar es Salaam",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(width: 4),
              Icon(Icons.keyboard_arrow_down),
            ],
          ),
        ),

        // NOTIFICATIONS
        Stack(
          children: [

            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NotificationScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.notifications_none, size: 28),
            ),

            Positioned(
              right: 6,
              top: 6,
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
    );
  }
}
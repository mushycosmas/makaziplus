import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../api/master_data_api.dart';
import '../screens/notifications/notification_screen.dart';

class TopBar extends StatefulWidget {
  const TopBar({super.key});

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  String selectedRegion = "Loading...";
  List<dynamic> regions = [];

  @override
  void initState() {
    super.initState();
    _loadRegions();
  }

  Future<void> _loadRegions() async {
    try {
      final data = await MasterDataApi.getRegions();

      if (!mounted) return;

      setState(() {
        regions = data;

        // Default region
        final dar = data.cast<Map<String, dynamic>?>().firstWhere(
          (e) =>
              e?['name']
                      ?.toString()
                      .toLowerCase() ==
                  'dar es salaam',
          orElse: () => null,
        );

        if (dar != null) {
          selectedRegion = dar['name'];
        } else if (data.isNotEmpty) {
          selectedRegion = data.first['name'];
        } else {
          selectedRegion = "Select Region";
        }
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        selectedRegion = "Select Region";
      });

      debugPrint(e.toString());
    }
  }

  void _showRegionPicker() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (_) {
        return SizedBox(
          height: 450,
          child: Column(
            children: [
              const SizedBox(height: 10),

              const Text(
                "Select Region",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Divider(),

              Expanded(
                child: ListView.builder(
                  itemCount: regions.length,
                  itemBuilder: (context, index) {
                    final region = regions[index];

                    final isSelected =
                        selectedRegion == region["name"];

                    return ListTile(
                      leading: Icon(
                        Iconsax.location,
                        color: isSelected
                            ? Colors.green
                            : Colors.grey,
                      ),
                      title: Text(region["name"]),
                      trailing: isSelected
                          ? const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            )
                          : null,
                      onTap: () {
                        setState(() {
                          selectedRegion = region["name"];
                        });

                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// MENU
        IconButton(
          onPressed: () {
            Scaffold.maybeOf(context)?.openDrawer();
          },
          icon: const Icon(
            Icons.menu,
            size: 28,
          ),
        ),

        /// LOCATION
        Expanded(
          child: InkWell(
            onTap: _showRegionPicker,
            borderRadius: BorderRadius.circular(30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Iconsax.location,
                  size: 18,
                  color: Colors.green,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    selectedRegion,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.keyboard_arrow_down),
              ],
            ),
          ),
        ),

        /// NOTIFICATIONS
        Stack(
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const NotificationScreen(),
                  ),
                );
              },
              icon: const Icon(
                Icons.notifications_none,
                size: 28,
              ),
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
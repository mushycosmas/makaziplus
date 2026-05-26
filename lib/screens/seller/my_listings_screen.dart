import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class MyListingsScreen extends StatefulWidget {
  const MyListingsScreen({super.key});

  @override
  State<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends State<MyListingsScreen> {
  bool isLoading = false;

  // 🔥 Dummy data (later replace with API)
  List<Map<String, dynamic>> listings = [
    {
      "id": 1,
      "title": "Modern Apartment",
      "location": "Masaki, Dar es Salaam",
      "price": "Tsh 1,200,000",
    },
    {
      "id": 2,
      "title": "2 Bedroom House",
      "location": "Mikocheni",
      "price": "Tsh 850,000",
    },
  ];

  void _deleteItem(int id) {
    setState(() {
      listings.removeWhere((item) => item["id"] == id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Listing deleted")),
    );
  }

  void _editItem(Map<String, dynamic> item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Edit ${item["title"]}")),
    );

    // TODO: Navigate to edit screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      appBar: AppBar(
        title: const Text("My Listings"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())

          : listings.isEmpty
              ? const Center(
                  child: Text(
                    "No listings found",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )

              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: listings.length,
                  itemBuilder: (context, index) {
                    final item = listings[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),

                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Iconsax.home,
                            color: Colors.green,
                          ),
                        ),

                        title: Text(
                          item["title"],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),

                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),
                            Text(item["location"]),
                            const SizedBox(height: 5),
                            Text(
                              item["price"],
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        trailing: PopupMenuButton(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: "edit",
                              child: Text("Edit"),
                            ),
                            const PopupMenuItem(
                              value: "delete",
                              child: Text("Delete"),
                            ),
                          ],

                          onSelected: (value) {
                            if (value == "edit") {
                              _editItem(item);
                            } else if (value == "delete") {
                              _deleteItem(item["id"]);
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
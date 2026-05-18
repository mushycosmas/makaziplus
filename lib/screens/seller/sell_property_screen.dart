import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SellPropertyScreen extends StatefulWidget {
  const SellPropertyScreen({super.key});

  @override
  State<SellPropertyScreen> createState() => _SellPropertyScreenState();
}

class _SellPropertyScreenState extends State<SellPropertyScreen> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();

  String propertyType = "House";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      // APP BAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Sell Property",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 🔥 HEADER CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "List Your Property",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Reach thousands of buyers instantly",
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 🏡 TITLE
              _input(
                controller: titleController,
                icon: Iconsax.home,
                hint: "Property Title",
              ),

              const SizedBox(height: 12),

              // 💰 PRICE
              _input(
                controller: priceController,
                icon: Iconsax.money,
                hint: "Price (TZS)",
                keyboard: TextInputType.number,
              ),

              const SizedBox(height: 12),

              // 📍 LOCATION
              _input(
                controller: locationController,
                icon: Iconsax.location,
                hint: "Location",
              ),

              const SizedBox(height: 20),

              // 🏠 TYPE
              const Text(
                "Property Type",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  value: propertyType,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: "House", child: Text("House")),
                    DropdownMenuItem(value: "Apartment", child: Text("Apartment")),
                    DropdownMenuItem(value: "Land", child: Text("Land")),
                    DropdownMenuItem(value: "Office", child: Text("Office")),
                    DropdownMenuItem(value: "Shop", child: Text("Shop")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      propertyType = value!;
                    });
                  },
                ),
              ),

              const SizedBox(height: 20),

              // 📝 DESCRIPTION
              const Text(
                "Description",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Describe your property...",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 📸 IMAGE UPLOAD UI
              const Text(
                "Photos",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Iconsax.gallery_add, size: 30, color: Colors.grey),
                      SizedBox(height: 8),
                      Text("Upload Images"),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // 🚀 SUBMIT BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF22C55E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Property listed successfully"),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    "Publish Property",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔧 INPUT WIDGET (REUSABLE)
  Widget _input({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
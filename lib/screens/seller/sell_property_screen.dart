import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SellPropertyScreen extends StatefulWidget {
  const SellPropertyScreen({super.key});

  @override
  State<SellPropertyScreen> createState() => _SellPropertyScreenState();
}

class _SellPropertyScreenState extends State<SellPropertyScreen> {
  final _formKey = GlobalKey<FormState>();

  // BASIC INFO
  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();

  // LOCATION
  String country = "Tanzania";
  String region = "Dar es Salaam";
  String district = "Kinondoni";
  String? ward;

  final Map<String, List<String>> regions = {
    "Dar es Salaam": ["Kinondoni", "Ilala", "Temeke", "Ubungo"],
    "Arusha": ["Arusha City", "Meru", "Karatu"],
    "Mwanza": ["Nyamagana", "Ilemela"],
    "Dodoma": ["Dodoma Urban", "Chamwino"],
  };

  final Map<String, List<String>> wards = {
    "Kinondoni": ["Mikocheni", "Kijitonyama", "Mbezi"],
    "Ilala": ["Upanga", "Buguruni"],
    "Temeke": ["Mbagala", "Kurasini"],
  };

  // PROPERTY DETAILS
  final bedroomsController = TextEditingController();
  final bathroomsController = TextEditingController();
  final sizeController = TextEditingController();
  final yearBuiltController = TextEditingController();

  // SELLER
  final sellerNameController = TextEditingController();
  final phoneController = TextEditingController();

  String propertyType = "House";
  String listingType = "Sale";

  final List<String> allAmenities = [
    "WiFi",
    "Parking",
    "Swimming Pool",
    "Security",
    "Gym",
    "Garden",
    "Elevator",
  ];

  final Set<String> selectedAmenities = {};

  @override
  void dispose() {
    titleController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    bedroomsController.dispose();
    bathroomsController.dispose();
    sizeController.dispose();
    yearBuiltController.dispose();
    sellerNameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLand = propertyType == "Land";

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

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

              // HEADER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E),
                  borderRadius: BorderRadius.circular(16),
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
                      "Reach thousands of buyers & renters",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // TITLE
              _input(titleController, Iconsax.home, "Property Title"),
              const SizedBox(height: 10),

              _input(priceController, Iconsax.money, "Price (TZS)",
                  type: TextInputType.number),

              const SizedBox(height: 20),

              // LOCATION
              const Text(
                "Location",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              // COUNTRY
              _simpleBox("Tanzania", Icons.public),

              const SizedBox(height: 10),

              // REGION
              _dropdown(
                value: region,
                items: regions.keys.toList(),
                onChanged: (value) {
                  setState(() {
                    region = value!;
                    district = regions[value]!.first;
                    ward = null;
                  });
                },
              ),

              const SizedBox(height: 10),

              // DISTRICT
              _dropdown(
                value: district,
                items: regions[region]!,
                onChanged: (value) {
                  setState(() {
                    district = value!;
                    ward = null;
                  });
                },
              ),

              const SizedBox(height: 10),

              // WARD
              if (wards.containsKey(district))
                _dropdown(
                  value: ward,
                  items: wards[district]!,
                  hint: "Select Ward",
                  onChanged: (value) {
                    setState(() => ward = value!);
                  },
                ),

              const SizedBox(height: 20),

              // PROPERTY TYPE
              const Text(
                "Property Type",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              DropdownButtonFormField<String>(
                value: propertyType,
                items: const [
                  DropdownMenuItem(value: "House", child: Text("House")),
                  DropdownMenuItem(value: "Apartment", child: Text("Apartment")),
                  DropdownMenuItem(value: "Land", child: Text("Land")),
                  DropdownMenuItem(value: "Office", child: Text("Office")),
                  DropdownMenuItem(value: "Shop", child: Text("Shop")),
                ],
                onChanged: (value) {
                  setState(() => propertyType = value!);
                },
              ),

              const SizedBox(height: 20),

              // DETAILS (HIDDEN FOR LAND)
              if (!isLand) ...[
                Row(
                  children: [
                    Expanded(
                      child: _input(
                        bedroomsController,
                        Icons.bed,
                        "Beds",
                        type: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _input(
                        bathroomsController,
                        Icons.bathroom,
                        "Baths",
                        type: TextInputType.number,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                _input(sizeController, Icons.square_foot, "Size (sqm)",
                    type: TextInputType.number),

                const SizedBox(height: 10),

                _input(yearBuiltController, Icons.calendar_today,
                    "Year Built",
                    type: TextInputType.number),

                const SizedBox(height: 20),
              ],

              // AMENITIES
              const Text(
                "Amenities",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: allAmenities.map((item) {
                  final selected = selectedAmenities.contains(item);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selected
                            ? selectedAmenities.remove(item)
                            : selectedAmenities.add(item);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFF22C55E)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF22C55E)),
                      ),
                      child: Text(
                        item,
                        style: TextStyle(
                          color: selected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // DESCRIPTION
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

              const SizedBox(height: 25),

              // SUBMIT
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
                  child: const Text("Publish Property"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // SIMPLE BOX
  Widget _simpleBox(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 10),
          Text(text),
        ],
      ),
    );
  }

  // DROPDOWN
  Widget _dropdown({
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? value,
    String? hint,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox(),
        hint: hint != null ? Text(hint) : null,
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  // INPUT
  Widget _input(
    TextEditingController controller,
    IconData icon,
    String hint, {
    TextInputType type = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: type,
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
import 'package:flutter/material.dart';

class AmenitiesSection extends StatefulWidget {
  const AmenitiesSection({super.key});

  @override
  State<AmenitiesSection> createState() => _AmenitiesSectionState();
}

class _AmenitiesSectionState extends State<AmenitiesSection> {
  final Set<String> selected = {};

  final items = [
    "WiFi",
    "Parking",
    "Security",
    "Gym",
    "Garden",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Text("Amenities",
            style: TextStyle(fontWeight: FontWeight.bold)),

        const SizedBox(height: 10),

        Wrap(
          spacing: 10,
          children: items.map((e) {
            final isSelected = selected.contains(e);

            return GestureDetector(
              onTap: () {
                setState(() {
                  isSelected ? selected.remove(e) : selected.add(e);
                });
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF22C55E)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green),
                ),
                child: Text(
                  e,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
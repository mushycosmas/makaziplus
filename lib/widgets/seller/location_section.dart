import 'package:flutter/material.dart';

class LocationSection extends StatefulWidget {
  const LocationSection({super.key});

  @override
  State<LocationSection> createState() => _LocationSectionState();
}

class _LocationSectionState extends State<LocationSection> {
  String region = "Dar es Salaam";
  String district = "Kinondoni";

  final Map<String, List<String>> regions = {
    "Dar es Salaam": ["Kinondoni", "Ilala", "Temeke"],
    "Arusha": ["Arusha City", "Meru"],
    "Mwanza": ["Nyamagana", "Ilemela"],
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Text("Location",
            style: TextStyle(fontWeight: FontWeight.bold)),

        const SizedBox(height: 10),

        _box(
          DropdownButton<String>(
            value: region,
            isExpanded: true,
            underline: const SizedBox(),
            items: regions.keys
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) {
              setState(() {
                region = v!;
                district = regions[v]!.first;
              });
            },
          ),
        ),

        const SizedBox(height: 10),

        _box(
          DropdownButton<String>(
            value: district,
            isExpanded: true,
            underline: const SizedBox(),
            items: regions[region]!
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => setState(() => district = v!),
          ),
        ),
      ],
    );
  }

  Widget _box(Widget child) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}
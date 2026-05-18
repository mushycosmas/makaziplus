import 'package:flutter/material.dart';

class PropertyDetailsSection extends StatelessWidget {
  final bool isLand;

  const PropertyDetailsSection({
    super.key,
    required this.isLand,
  });

  @override
  Widget build(BuildContext context) {
    if (isLand) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text("Property Details",
            style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 10),

        Text("Beds / Baths / Size / Year fields go here"),
      ],
    );
  }
}
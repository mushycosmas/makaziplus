import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [

          const Icon(Iconsax.search_normal, size: 20),

          const SizedBox(width: 10),

          // TEXT FIELD
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search property, location...",
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),

          const SizedBox(width: 10),

          // FILTER BUTTON (FIXED SIZE)
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF22C55E),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.tune,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
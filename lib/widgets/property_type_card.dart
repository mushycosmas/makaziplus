import 'package:flutter/material.dart';

class PropertyTypeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool active;

  const PropertyTypeCard({
    super.key,
    required this.icon,
    required this.title,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: 15),
      child: Column(
        children: [

          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: active
                  ? const Color(0xFF22C55E)
                  : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Icon(
              icon,
              color: active ? Colors.white : Colors.black,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            title,
            style: TextStyle(
              color: active
                  ? const Color(0xFF22C55E)
                  : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
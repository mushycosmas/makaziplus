import 'package:flutter/material.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 360;

        return Row(
          children: [
            // LEFT TEXT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    "Find your",
                    style: TextStyle(
                      fontSize: isSmall ? 28 : 34,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                  ),

                  Text(
                    "perfect property",
                    style: TextStyle(
                      fontSize: isSmall ? 28 : 34,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF22C55E),
                      height: 1.1,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    "Buy, rent or find the best places to call home.",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: isSmall ? 13 : 15,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // IMAGE
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(
                  "https://images.unsplash.com/photo-1600585154526-990dced4db0d",
                  height: isSmall ? 180 : 220,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const SectionTitle({
    super.key,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // TITLE (flexible to prevent overflow)
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // SEE ALL BUTTON
        GestureDetector(
          onTap: onTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                "See all",
                style: TextStyle(
                  color: Color(0xFF22C55E),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 5),
              Icon(
                Icons.arrow_forward,
                color: Color(0xFF22C55E),
                size: 18,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
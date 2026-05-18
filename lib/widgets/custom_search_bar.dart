import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../constants/app_colors.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        children: [
          Icon(Iconsax.search_normal),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "Search property...",
              style: TextStyle(
                color: AppColors.grey,
              ),
            ),
          ),
          Icon(Iconsax.setting_4),
        ],
      ),
    );
  }
}
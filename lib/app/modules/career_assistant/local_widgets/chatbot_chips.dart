import 'package:flutter/material.dart';

import '../../../styles/app_colors.dart';

class chatbotChipsData {
  final String name;

  const chatbotChipsData({
    required this.name,
  });
}

class chatbot_chips extends StatelessWidget {
  final chatbotChipsData chipsData;
  final VoidCallback? onTap;
  const chatbot_chips({
    super.key,
    required this.chipsData,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          chipsData.name,
          style: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: AppColors.textOnPrimary,
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../../styles/app_colors.dart';

class SectionTitleWidget extends StatelessWidget {
  final String title;
  
  const SectionTitleWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontFamily: 'Montserrat',
        color: AppColors.textPrimary,
      ),
    );
  }
}

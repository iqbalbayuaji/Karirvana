import 'package:flutter/material.dart';
import 'package:karirvana/app/styles/app_colors.dart';

class CarouselContainer extends StatelessWidget {
  const CarouselContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 15, 0),
      width: 220,
      height: 140,
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(15)
      ),
    );
  }
}
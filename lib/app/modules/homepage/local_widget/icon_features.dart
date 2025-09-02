import 'package:flutter/material.dart';
import 'package:karirvana/app/styles/app_colors.dart';

class IconFeatures extends StatelessWidget {
  const IconFeatures({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 56,
          height: 53,
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            borderRadius: BorderRadius.circular(15)
          ),
        ),
        SizedBox(height: 5),
        SizedBox(
          width: 60,
          child: Text("Interview Practice", 
            style: TextStyle(
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}
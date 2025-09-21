import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:karirvana/app/styles/app_colors.dart';

class FeatureData {
  final IconData icon;
  final String title;
  final Color? backgroundColor;
  final double? width;
  final VoidCallback? onTap;

  const FeatureData({
    required this.icon,
    required this.title,
    this.backgroundColor,
    this.width,
    this.onTap,
  });
}

class IconFeatures extends StatelessWidget {
  final FeatureData featureData;

  const IconFeatures({
    super.key,
    required this.featureData,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: featureData.onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: featureData.backgroundColor ?? AppColors.surface,
              borderRadius: BorderRadius.circular(50)
            ),
            child: Icon(
              featureData.icon,
              color: AppColors.textPrimary,
              size: 30,
            ),
          ),
          SizedBox(height: 7),
          SizedBox(
            width: featureData.width,
            child: Text(
              featureData.title, 
              style: TextStyle(
                fontSize: 12,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}

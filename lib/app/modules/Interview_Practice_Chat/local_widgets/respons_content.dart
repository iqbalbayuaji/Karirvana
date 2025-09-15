import 'package:flutter/material.dart';
import '../../../styles/app_colors.dart';

class ResponseContent extends StatelessWidget {
  final String response;
  
  const ResponseContent({
    super.key,
    required this.response,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.psychology,
                color: AppColors.textOnPrimary,
                size: 25,
              ),
              const SizedBox(width: 6),
              const Text(
                'HR Assistant',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 15,
                  color: AppColors.textOnPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const SizedBox(width: 31), // Align with icon spacing
              Flexible(
                child: Text(
                  response,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    color: AppColors.textOnPrimary,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:karirvana/app/styles/app_colors.dart';

class RekomendasiContainer extends StatelessWidget {
  const RekomendasiContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(10, 5, 15, 20),
          width: 220,
          decoration: BoxDecoration(
            boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.10),
                                            blurRadius: 10,
                                            offset: const Offset(0, 8),
                                          )
                                        ],
            color: AppColors.primaryContainer,
            borderRadius: BorderRadius.circular(15),
          ),
          
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              children: [
                Expanded(
                  flex: 30,
                  child: SizedBox(
                    width: double.infinity,
                    child: Image.asset(
                      "assets/images/hero.jpg",
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                Expanded(
                  flex: 13,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Microsoft Exel Beginner Course',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontFamily: "Montserrat",
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'EduLearn',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontFamily: "Montserrat",
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 24,
          width: 80,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(9),
              bottomLeft: Radius.circular(9),
            ),
            gradient: LinearGradient(
                colors: AppColors.heroGradientSecondary,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
          ),
          child: Text(
            "30% Disc",
            style: TextStyle(
              color: AppColors.textOnPrimary,
              fontFamily: "Montserrat",
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        )
      ],
    );
  }
}
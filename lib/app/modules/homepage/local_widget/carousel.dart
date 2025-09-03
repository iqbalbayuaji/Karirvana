import 'package:flutter/material.dart';
import 'package:karirvana/app/styles/app_colors.dart';

class CarouselContainer extends StatelessWidget {
  const CarouselContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(15)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/hero.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                width: 6,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Erlangga Tresnamada Muliawan", 
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text("2002", 
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              )
            ],
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Accepted in ",
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextSpan(
                  text: "PT Garuda Indonesia Tbk.",
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            )
          ),
          Text(
            '"Saya merasa terbantu dengan adanya aplikasi karirvana ini, karena dapat membantu saya mengembangkan diri"',
            style: TextStyle(
              fontSize: 12,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          )
        ],
      ),
    );
  }
}
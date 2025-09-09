import 'package:flutter/material.dart';
import '../../../styles/app_colors.dart';

class KemitraanContainer extends StatelessWidget {
  final int index;

  const KemitraanContainer({
    super.key,
    required this.index,
  });

  static final List<Map<String, dynamic>> _partnerships = [
    {
      'name': 'PT GoTo Gojek Indonesia Tbk.',
      'imageUrl': 'assets/images/hero.jpg',
    },
    {
      'name': 'PT Tokopedia',
      'imageUrl': 'assets/images/hero.jpg',
    },
    {
      'name': 'PT Shopee International Indonesia',
      'imageUrl': 'assets/images/hero.jpg',
    },
    {
      'name': 'PT Bukalapak.com Tbk.',
      'imageUrl': 'assets/images/hero.jpg',
    },
    {
      'name': 'PT Blibli.com',
      'imageUrl': 'assets/images/hero.jpg',
    },
    {
      'name': 'PT Traveloka Indonesia',
      'imageUrl': 'assets/images/hero.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final partnership = _partnerships[index % _partnerships.length];
    final String name = partnership['name'];
    final String imageUrl = partnership['imageUrl'];
    
    return Container(
      padding: const EdgeInsets.symmetric( horizontal: 9),
      margin: const EdgeInsets.only(right: 20),
      width: 140,
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: 
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}
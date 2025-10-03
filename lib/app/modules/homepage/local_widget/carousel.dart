import 'package:flutter/material.dart';
import 'package:karirvana/app/styles/app_colors.dart';

class CarouselContainer extends StatelessWidget {
  final int index;

  const CarouselContainer({
    super.key,
    required this.index,
  });

  static final List<Map<String, dynamic>> _testimonials = [
    {
      'name': 'Erlangga Tresnamada Muliawan',
      'year': '2002',
      'company': 'PT Garuda Indonesia Tbk.',
      'testimonial': '"Saya merasa terbantu dengan adanya aplikasi karirvana ini, karena dapat membantu saya mengembangkan diri"',
      'imageUrl': 'assets/profile/Portrait of a confident young smart looking man _ Premium AI-generated image.jpeg',
    },
    {
      'name': 'Siti Nurhaliza Putri',
      'year': '2001',
      'company': 'PT Telkom Indonesia Tbk.',
      'testimonial': '"Aplikasi ini sangat membantu dalam menemukan peluang karir yang sesuai dengan passion saya"',
      'imageUrl': 'assets/profile/Nailed it_.jpeg',
    },
    {
      'name': 'Ahmad Rizki Pratama',
      'year': '2003',
      'company': 'PT Bank Central Asia Tbk.',
      'testimonial': '"Fitur-fitur yang ada sangat lengkap dan mudah digunakan untuk pengembangan karir"',
      'imageUrl': 'assets/profile/AMS studio.jpeg',
    },
    {
      'name': 'Maya Sari Dewi',
      'year': '2000',
      'company': 'PT Unilever Indonesia Tbk.',
      'testimonial': '"Berkat aplikasi ini, saya berhasil mendapatkan pekerjaan impian di perusahaan multinasional"',
      'imageUrl': 'assets/profile/Senior businessman portrait on white background _ Premium AI-generated image.jpeg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final testimonial = _testimonials[index % _testimonials.length];
    final String name = testimonial['name'];
    final String year = testimonial['year'];
    final String company = testimonial['company'];
    final String testimonialText = testimonial['testimonial'];
    final String imageUrl = testimonial['imageUrl'];
    
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
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
                    image: AssetImage(imageUrl),
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
                    Text(name, 
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(year, 
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
                  text: company,
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
            testimonialText,
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
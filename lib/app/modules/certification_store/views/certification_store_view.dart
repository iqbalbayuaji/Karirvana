import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../styles/app_colors.dart';
import '../controllers/certification_store_controller.dart';

class CertificationStoreView extends GetView<CertificationStoreController> {
  const CertificationStoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
        }

        final certification = controller.selectedCertification.value;
        
        if (certification == null) {
          return Center(
            child: Text(
              'Sertifikasi tidak ditemukan',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontFamily: "Montserrat",
                fontSize: 16,
              ),
            ),
          );
        }

        return Stack(
          children: [
            SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 300,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(certification.imageUrl),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (certification.showDiscount && certification.discountedPrice > 0) ...[
                                  Text(
                                    controller.formatPrice(certification.discountedPrice),
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontFamily: "Montserrat",
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      controller.formatPrice(certification.originalPrice),
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontFamily: "Montserrat",
                                        fontSize: 16,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      certification.discount,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontFamily: "Montserrat",
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ] else
                                  Text(
                                    controller.formatPrice(certification.originalPrice),
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontFamily: "Montserrat",
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                              ],
                            ),
              
                            SizedBox(height: 8),
              
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    certification.title, 
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                      fontFamily: "Montserrat",
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              SizedBox(width: 15),
                            ],
                          ),
            
                          SizedBox(height: 5),
            
                          SizedBox(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          CupertinoIcons.star_fill,
                                          color: Colors.amber,
                                          size: 18,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          certification.rating.toString(),
                                          style: TextStyle(
                                            color: AppColors.textPrimary,
                                            fontFamily: "Montserrat",
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 7),
                                    Text(
                                      "(${controller.formatNumber(certification.totalParticipants)} reviews)",
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontFamily: "Montserrat",
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 20),
                                Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.person_2,
                                      color: AppColors.textSecondary,
                                      size: 16,
                                    ),
                                    SizedBox(width: 7),
                                    Text(
                                      "${controller.formatNumber(certification.totalParticipants)} students",
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontFamily: "Montserrat",
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          
                          SizedBox(height: 20),
                          
                          Text(
                            "Deskripsi Sertifikasi",
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontFamily: "Montserrat",
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            certification.description,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontFamily: "Montserrat",
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                          
                          SizedBox(height: 25),
                          
                          Text(
                            "Yang Akan Anda Dapatkan",
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontFamily: "Montserrat",
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 6),
                          
                          ...List.generate(certification.benefits.length, (index) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 6),
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      certification.benefits[index],
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontFamily: "Montserrat",
                                        fontSize: 14,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),

                          SizedBox(height: 25),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Persyaratan",
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontFamily: "Montserrat",
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 15),

                          ...List.generate(certification.requirements.length, (index) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 6),
                                    width: 4,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: AppColors.textSecondary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      certification.requirements[index],
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontFamily: "Montserrat",
                                        fontSize: 14,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          
                          SizedBox(height: 25),
                          
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 30),
                            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 40),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: AppColors.secondaryContainer,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildDetailItem(CupertinoIcons.time, "Durasi", certification.duration),
                                    SizedBox(height: 20),
                                    _buildDetailItem(CupertinoIcons.doc_text, "Level", certification.level),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildDetailItem(CupertinoIcons.calendar, "Berlaku", "${certification.validityPeriod} tahun"),
                                    SizedBox(height: 20),
                                    _buildDetailItem(CupertinoIcons.checkmark_seal, "Sertifikat", "Digital"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          
                          SizedBox(height: 30),
            
                          // Reviews Section
                          Text(
                            "Review Pengguna",
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontFamily: "Montserrat",
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 15),
                          
                          Column(
                            children: List.generate(3, (index) {
                              final List<Map<String, dynamic>> _reviewsData = [
                                {
                                  'name': 'Ahmad Rizki',
                                  'rating': 5.0,
                                  'comment': 'Sertifikasi yang sangat berguna untuk karir saya. Materi lengkap dan mudah dipahami.',
                                  'date': '2 minggu lalu'
                                },
                                {
                                  'name': 'Sari Dewi',
                                  'rating': 4.8,
                                  'comment': 'Proses sertifikasi yang profesional. Sangat direkomendasikan untuk pengembangan skill.',
                                  'date': '1 bulan lalu'
                                },
                                {
                                  'name': 'Budi Santoso',
                                  'rating': 4.9,
                                  'comment': 'Sertifikat yang diakui industri. Membantu meningkatkan kredibilitas profesional.',
                                  'date': '3 minggu lalu'
                                },
                              ];
                              
                              final review = _reviewsData[index];
                              return Container(
                                margin: EdgeInsets.only(bottom: 15),
                                width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColors.surfaceVariant,
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 8,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 20,
                                              backgroundColor: AppColors.primary.withOpacity(0.1),
                                              child: Text(
                                                review['name'][0],
                                                style: TextStyle(
                                                  color: AppColors.primary,
                                                  fontFamily: "Montserrat",
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    review['name'],
                                                    style: TextStyle(
                                                      color: AppColors.textPrimary,
                                                      fontFamily: "Montserrat",
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      ...List.generate(5, (starIndex) {
                                                        return Icon(
                                                          starIndex < review['rating'].floor()
                                                              ? CupertinoIcons.star_fill
                                                              : CupertinoIcons.star,
                                                          color: starIndex < review['rating'].floor()
                                                              ? Colors.amber
                                                              : AppColors.textSecondary,
                                                          size: 14,
                                                        );
                                                      }),
                                                      SizedBox(width: 8),
                                                      Text(
                                                        review['date'],
                                                        style: TextStyle(
                                                          color: AppColors.textSecondary,
                                                          fontFamily: "Montserrat",
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 12),
                                        Text(
                                          review['comment'],
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                            fontFamily: "Montserrat",
                                            fontSize: 13,
                                            height: 1.4,
                                          ),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                            }),
                          ),
                          
                          SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Back button
          Positioned(
                  top: 40,
                  left: 25,
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.outline),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: AppColors.textPrimary,
                        size: 20,
                      ),
                    ),
                  ),
                ),
          
          // Bottom action button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                      width: double.infinity,
                      height: 80,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 55,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  "Ikuti Sertifikasi",
                                  style: TextStyle(
                                    color: AppColors.textOnPrimary,
                                    fontFamily: "Montserrat",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: AppColors.primary,
                                width: 2.5,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                CupertinoIcons.cart,
                                color: AppColors.primary,
                              )
                            ),
                          )
                        ],
                      )
                    ),
              ],
            ),
          ),
        ],
      );
      }),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 24,
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontFamily: "Montserrat",
            fontSize: 12,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontFamily: "Montserrat",
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:karirvana/app/styles/app_colors.dart';

import '../controllers/course_store_controller.dart';

class CourseStoreView extends GetView<CourseStoreController> {
  const CourseStoreView({super.key});
  
  static final List<Map<String, dynamic>> _reviewsData = [
    {
      'name': 'Andi Pratama',
      'rating': 5,
      'date': '2 hari lalu',
      'comment': 'Kursus yang sangat bagus! Materinya mudah dipahami dan instruktur menjelaskan dengan sangat detail. Sangat membantu untuk pemula seperti saya.',
    },
    {
      'name': 'Sari Dewi',
      'rating': 4,
      'date': '1 minggu lalu',
      'comment': 'Konten kursus berkualitas tinggi. Saya belajar banyak hal baru tentang Excel. Hanya saja ada beberapa video yang agak lambat.',
    },
    {
      'name': 'Budi Santoso',
      'rating': 5,
      'date': '2 minggu lalu',
      'comment': 'Excellent course! Setelah mengikuti kursus ini, saya jadi lebih percaya diri menggunakan Excel di kantor. Terima kasih!',
    },
    {
      'name': 'Maya Sari',
      'rating': 4,
      'date': '3 minggu lalu',
      'comment': 'Materi lengkap dan up-to-date. Instruktur sangat berpengalaman. Recommended untuk yang ingin belajar Excel dari nol.',
    },
    {
      'name': 'Rizki Fadil',
      'rating': 5,
      'date': '1 bulan lalu',
      'comment': 'Kursus terbaik yang pernah saya ikuti! Penjelasan step-by-step sangat membantu. Worth every penny!',
    },
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        
        final course = controller.selectedCourse.value;
        if (course == null) {
          return Center(child: Text('Course not found'));
        }
        
        return Stack(
          alignment: Alignment.bottomCenter,
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
                            image: AssetImage(
                              controller.getCourseImage(course.category, course.title)
                            ),
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
                                if (course.showDiscount && course.discountedPrice > 0) ...[
                                  Text(
                                    controller.formatPrice(course.discountedPrice),
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontFamily: "Montserrat",
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      controller.formatPrice(course.originalPrice),
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
                                      course.discount,
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
                                    controller.formatPrice(course.originalPrice),
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
                                    course.title, 
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
                                          course.rating.toString(),
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
                                      "(${controller.formatNumber(course.totalStudents)} reviews)",
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
                                      "${controller.formatNumber(course.totalStudents)} students",
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
                            "Deskripsi Course",
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontFamily: "Montserrat",
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            course.description,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontFamily: "Montserrat",
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                          
                          SizedBox(height: 25),
                          
                          // What you'll learn
                          Text(
                            "Yang Akan Anda Pelajari",
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontFamily: "Montserrat",
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 6),
                          
                          ...List.generate(course.whatYouWillLearn.length, (index) {
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
                                      course.whatYouWillLearn[index],
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
                                "Modul Course",
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontFamily: "Montserrat",
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${course.modules.length} Modul",
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontFamily: "Montserrat",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
            
                          SizedBox(height: 15),
            
                          SizedBox(
                            height: 120,
                            child: course.modules.isEmpty 
                              ? Center(
                                  child: Text(
                                    'Belum ada modul tersedia',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontFamily: "Montserrat",
                                      fontSize: 14,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: course.modules.length,
                                  itemBuilder: (context, index) {
                                    final moduleData = course.modules[index] as Map<String, dynamic>;
                                    
                                    return Container(
                                      margin: EdgeInsets.only(right: 12),
                                      width: 140,
                                      decoration: BoxDecoration(
                                        color: AppColors.surface,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: AppColors.outline.withOpacity(0.2),
                                          width: 1,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                              width: 32,
                                              height: 32,
                                              decoration: BoxDecoration(
                                                color: AppColors.primary.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Icon(
                                                Icons.play_circle_outline,
                                                color: AppColors.primary,
                                                size: 18,
                                              ),
                                            ),
                                            Text(
                                              moduleData['title'] as String,
                                              style: TextStyle(
                                                color: AppColors.textPrimary,
                                                fontFamily: "Montserrat",
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                          ),
                          
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
                                    _buildDetailItem(CupertinoIcons.time, "Durasi", course.duration),
                                    SizedBox(height: 20),
                                    _buildDetailItem(CupertinoIcons.play_circle, "Video", "10 video"),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildDetailItem(CupertinoIcons.doc_text, "Materi", "${course.modules.length} modul"),
                                    SizedBox(height: 20),
                                    _buildDetailItem(CupertinoIcons.checkmark_seal, "Sertifikat", course.hasCertificate ? "Ya" : "Tidak"),
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
                            children: List.generate(_reviewsData.length, (index) {
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
                                                          starIndex < review['rating']
                                                              ? CupertinoIcons.star_fill
                                                              : CupertinoIcons.star,
                                                          color: starIndex < review['rating']
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
                              },
                            ),
                          ),
                          
                          SizedBox(height: 80),
                          
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
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
                            child: GestureDetector(
                              onTap: () {
                                controller.enrollCourse();
                              },
                              child: Container(
                                height: 55,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Center(
                                  child: Text(
                                    "Ikuti Course",
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
          
          // Back button (fixed position)
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

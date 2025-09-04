import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:karirvana/app/styles/app_colors.dart';

import '../controllers/course_store_controller.dart';

class CourseStoreView extends GetView<CourseStoreController> {
  const CourseStoreView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary,
                        AppColors.primaryContainer,
                      ],
                    ),
                  ),
                ),
                
                // Course title and cart section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Rp 299.000",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontFamily: "Montserrat",
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Rp 599.000",
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontFamily: "Montserrat",
                              fontSize: 16,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              "50% Disc",
                              style: TextStyle(
                                color: Colors.red,
                                fontFamily: "Montserrat",
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              "Microsoft Excel Beginner Course", 
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
                          Container(
                            alignment: Alignment.center,
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.secondaryContainer,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Icon(
                              CupertinoIcons.cart,
                              color: AppColors.textPrimary,
                              size: 24,
                            ),
                          )
                        ],
                      ),

                      SizedBox(height: 9),

                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    SizedBox(width: 7),
                                    Text(
                                      "4.8",
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
                                  "(2,847 reviews)",
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontFamily: "Montserrat",
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  CupertinoIcons.person_2,
                                  color: AppColors.textSecondary,
                                  size: 16,
                                ),
                                SizedBox(width: 7),
                                Text(
                                  "12,450 students",
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
                        "Deskripsi Kursus",
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontFamily: "Montserrat",
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        "Pelajari Microsoft Excel dari dasar hingga mahir. Kursus ini dirancang khusus untuk pemula yang ingin menguasai spreadsheet dan analisis data. Dengan metode pembelajaran yang mudah dipahami dan praktis.",
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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15),
                      
                      ...List.generate(4, (index) {
                        List<String> features = [
                          "Dasar-dasar Microsoft Excel dan interface",
                          "Membuat dan mengelola spreadsheet",
                          "Formula dan fungsi Excel yang penting",
                          "Membuat chart dan visualisasi data"
                        ];
                        
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
                                  features[index],
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
                            "Modul Kursus",
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontFamily: "Montserrat",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "12 Modul",
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
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            List<Map<String, dynamic>> modules = [
                              {
                                'title': 'Pengenalan Excel',
                                'icon': CupertinoIcons.play_circle,
                              },
                              {
                                'title': 'Dasar Formula',
                                'icon': CupertinoIcons.function,
                              },
                              {
                                'title': 'Membuat Tabel',
                                'icon': CupertinoIcons.table,
                              },
                              {
                                'title': 'Grafik & Chart',
                                'icon': CupertinoIcons.chart_bar,
                              },
                              {
                                'title': 'Tips & Trik',
                                'icon': CupertinoIcons.lightbulb,
                              },
                            ];
                            
                            return Container(
                              margin: EdgeInsets.only(right: 12),
                              width: 140,
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
                                padding: EdgeInsets.symmetric(horizontal: 12),
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
                                        modules[index]['icon'],
                                        size: 18,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    Text(
                                      modules[index]['title'],
                                      style: TextStyle(
                                        color: AppColors.textPrimary,
                                        fontFamily: "Montserrat",
                                        fontSize: 13,
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
                        margin: EdgeInsets.symmetric(horizontal: 25),
                        padding: EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildDetailItem(CupertinoIcons.time, "Durasi", "8 jam"),
                                _buildDetailItem(CupertinoIcons.play_circle, "Video", "24 video"),
                              ],
                            ),
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildDetailItem(CupertinoIcons.doc_text, "Materi", "12 modul"),
                                _buildDetailItem(CupertinoIcons.checkmark_seal, "Sertifikat", "Ya"),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 30),

                      
                      
                      // Purchase button
                      Container(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle purchase
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.textOnPrimary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Text(
                            "Beli Sekarang",
                            style: TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 20),
                      
                      // Add to cart button
                      Container(
                        width: double.infinity,
                        height: 55,
                        child: OutlinedButton(
                          onPressed: () {
                            // Handle add to cart
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: BorderSide(color: AppColors.primary, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Text(
                            "Tambah ke Keranjang",
                            style: TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
            
            // Back button
            Positioned(
              top: 40,
              left: 25,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: AppColors.surface.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    CupertinoIcons.back,
                    color: AppColors.textPrimary,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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

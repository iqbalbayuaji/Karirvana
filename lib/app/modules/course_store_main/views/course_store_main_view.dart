import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../styles/app_colors.dart';
import '../controllers/course_store_main_controller.dart';
import '../local_widgets/filter_chip.dart';

class CourseStoreMainView extends StatefulWidget {
  const CourseStoreMainView({super.key});

  @override
  State<CourseStoreMainView> createState() => _CourseStoreMainViewState();
}

class _CourseStoreMainViewState extends State<CourseStoreMainView> {
  String selectedFilter = "Semua";
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(
                      CupertinoIcons.back, 
                      size: 30, 
                      color: AppColors.textPrimary
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: AppColors.outline.withOpacity(0.3),
                          width: 1,
                        ),
                        ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Cari course ",
                          hintStyle: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 14,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w400,
                          ),
                          prefixIcon: Icon(
                            CupertinoIcons.search,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: 14,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 25),
                children: [
                  Row(
                    children: [
                      Container(
                        height: 40,
                        width: 45,
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Icon(
                          CupertinoIcons.slider_horizontal_3,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(width: 10),
                      Row(
                        children: [
                          CustomFilterChip(
                            label: "Semua", 
                            isSelected: selectedFilter == "Semua",
                            onTap: () {
                              setState(() {
                                selectedFilter = "Semua";
                              });
                            },
                          ),
                          SizedBox(width: 8),
                          CustomFilterChip(
                            label: "Programming", 
                            isSelected: selectedFilter == "Programming",
                            onTap: () {
                              setState(() {
                                selectedFilter = "Programming";
                              });
                            },
                          ),
                          SizedBox(width: 8),
                          CustomFilterChip(
                            label: "Design", 
                            isSelected: selectedFilter == "Design",
                            onTap: () {
                              setState(() {
                                selectedFilter = "Design";
                              });
                            },
                          ),
                          SizedBox(width: 8),
                          CustomFilterChip(
                            label: "Business", 
                            isSelected: selectedFilter == "Business",
                            onTap: () {
                              setState(() {
                                selectedFilter = "Business";
                              });
                            },
                          ),
                          SizedBox(width: 8),
                          CustomFilterChip(
                            label: "Marketing", 
                            isSelected: selectedFilter == "Marketing",
                            onTap: () {
                              setState(() {
                                selectedFilter = "Marketing";
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      )
    );
  }

}

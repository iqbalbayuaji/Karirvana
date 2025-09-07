import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../../styles/app_colors.dart';
import '../controllers/course_user_controller.dart';

class CourseUserView extends GetView<CourseUserController> {
  const CourseUserView({super.key});
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.heroGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.04,
                      horizontal: 25,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: screenHeight * 0.06),
                        PieChart(
                          dataMap: const {
                            "Selesai": 40,
                            "Tertunda": 25,
                          },
                          chartType: ChartType.ring,
                          ringStrokeWidth: screenWidth * 0.065,
                          chartRadius: screenWidth * 0.375,
                          legendOptions: const LegendOptions(
                            showLegends: false,
                          ),
                          chartValuesOptions: ChartValuesOptions(
                            showChartValueBackground: false,
                            showChartValues: false,
                            showChartValuesInPercentage: false,
                            showChartValuesOutside: false,
                            decimalPlaces: 1,
                          ),
                          centerWidget: Container(
                            child: Text(
                              "60%", 
                              style: TextStyle(
                                fontSize: screenWidth * 0.0625,
                                color: AppColors.textOnPrimary,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ),
                          colorList: [
                            Color(0xFF3B82F6), 
                            Color(0xFFC7D2FE), 
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        Text(
                          "Progress Course",
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: AppColors.textOnPrimary,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.04),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: screenWidth * 0.40,
                              child: Text(
                                "Express JS Intermediate",
                                style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: AppColors.textOnPrimary,
                                ),
                                maxLines: 2,
                              ),
                            ),
                            SizedBox(
                              child: Text(
                                "akowandwjsh",
                                style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: AppColors.textOnPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        Container(
                          width: double.infinity,
                          height: screenHeight * 0.06,
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Modul",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textOnPrimary,
                                ),
                              ),
                              Text(
                                "4/16",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textOnPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                      height: 115,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 15),
                                width: 150,
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Pengenalan",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Progress:",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        SizedBox(height: 9),
                                        StepProgressIndicator(
                                          totalSteps: 10,
                                          currentStep: 7,
                                          size: 6,
                                          padding: 0,
                                          selectedColor: AppColors.primary,
                                          unselectedColor: AppColors.textPrimary.withOpacity(0.2),
                                          roundedEdges: Radius.circular(3),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "7/10 Selesai",
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                ],
              ),
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
      ),
    );
  }
}

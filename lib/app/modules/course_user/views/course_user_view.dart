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
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.02,
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
                    SizedBox(height: screenHeight * 0.04),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Modul",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w600,
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
                              color: AppColors.surfaceVariant,
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
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../../styles/app_colors.dart';
import '../controllers/course_user_controller.dart';

class CourseUserView extends GetView<CourseUserController> {
  const CourseUserView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 300,
              decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.heroGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Column(
                children: [
                  PieChart(
                              dataMap: const {
                                "Selesai": 40,
                                "Tertunda": 25,
                              },
                              chartType: ChartType.ring,
                              ringStrokeWidth: 26,
                              chartRadius: 150,
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
                                child: Text("60%", 
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: AppColors.textOnPrimary,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w600,
                                  ),
                                )),
                              colorList: [
                                Color(0xFF3B82F6), 
                                Color(0xFFC7D2FE), 
                              ],
                            ),
                ],
              ),
            ),
          
          ],
        ),
      )
    );
  }
}

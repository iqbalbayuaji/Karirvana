import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../../styles/app_colors.dart';

class Chart_Pie extends StatelessWidget {
  const Chart_Pie({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PieChart(
                        dataMap: const {
                          "Selesai": 40,
                          "Tertunda": 25,
                        },
                        chartType: ChartType.ring,
                        ringStrokeWidth: 18,
                        chartRadius: 100,
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
                              color: AppColors.textPrimary,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w600,
                            ),
                          )),
                        colorList: [
                          Color(0xFF3B82F6), 
                          Colors.grey[400]!, 
                        ],
                      );
  }
}

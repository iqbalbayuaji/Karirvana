import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../../styles/app_colors.dart';

class Chart_Pie extends StatelessWidget {
  final double progress;
  
  const Chart_Pie({
    super.key,
    this.progress = 60.0,
  });

  @override
  Widget build(BuildContext context) {
    final completed = progress;
    final remaining = 100 - progress;
    
    return PieChart(
                        dataMap: {
                          "Selesai": completed,
                          "Tertunda": remaining,
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
                          child: Text("${progress.toInt()}%", 
                            style: TextStyle(
                              fontSize: 25,
                              color: AppColors.textPrimary,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w600,
                            ),
                          )),
                        colorList: [
                          Color(0xFF3B82F6), 
                          Color(0xFFC7D2FE), 
                        ],
                      );
  }
}

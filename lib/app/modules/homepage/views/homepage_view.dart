import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:karirvana/app/modules/homepage/local_widget/pie_chart.dart';
import 'package:get/get.dart';
import 'package:karirvana/app/styles/app_colors.dart'; // <-- Import baru

import '../controllers/homepage_controller.dart';
import '../local_widget/Rekomendasi_Container.dart';
import '../local_widget/icon_features.dart';

class HomepageView extends GetView<HomepageController> {
  const HomepageView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 350,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.heroGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          ListView(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        children: [
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    CupertinoIcons.bell_fill,
                                    size: 27,
                                    color: AppColors.textOnPrimary, // Warna baru
                                  )),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  CupertinoIcons.bars,
                                  size: 42,
                                  color: AppColors.textOnPrimary, // Warna baru
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Siap Berkembang ",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textOnPrimary, // Warna baru
                                  ),
                                ),
                                const Text(
                                  "Banon?",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textOnPrimary), // Warna baru
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Stack(
                      children: [
                        Column(
                          children: [
                            const SizedBox(height: 90),
                            Container(
                              width: double.infinity,
                              height: 800,
                              decoration: const BoxDecoration(
                                color: AppColors.surfaceVariant, // Warna baru
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25),
                                ),
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(height: 120),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 35),
                                    child: const Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconFeatures(),
                                        IconFeatures(),
                                        IconFeatures(),
                                        IconFeatures(),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 35),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Rekomendasi",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: "Montserrat",
                                                color: AppColors.textSecondary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      SizedBox(
                                        height: 140,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: 2,
                                          padding: const EdgeInsets.only(left: 35),
                                          itemBuilder: (context, index) {
                                            return Row(
                                              children: [
                                                RekomendasiContainer(),
                                                RekomendasiContainer(),
                                              ],
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 25),
                                    child: Container(
                                      height: 100,
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(horizontal: 20),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                        colors: AppColors.heroGradientSecondary,
                                        begin: Alignment.topRight,
                                        end: Alignment.bottomCenter,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.10),
                                          blurRadius: 24,
                                          // offset: const Offset(0, 8),
                                        )
                                      ],
                                        borderRadius: BorderRadius.circular(15)
                                      ),
                                      
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 55,
                                            width: 55,
                                            decoration: BoxDecoration(
                                              color: AppColors.primary,
                                              borderRadius: BorderRadius.circular(15)
                                            ),
                                          ),
                                          Container(
                                            width: 190,
                                            child: Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text("Vana Plus",
                                                    style: TextStyle(
                                                    fontFamily: "Montserrat",
                                                    fontSize: 15,
                                                    color: AppColors.textOnPrimary,
                                                    fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  Text("Berkembang Lebih asik dengan Vana Plus",
                                                    style: TextStyle(
                                                      fontFamily: "Montserrat",
                                                      fontSize: 13,
                                                      color: AppColors.textOnPrimary,
                                                      fontWeight: FontWeight.w500,
                                                      ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Icon(CupertinoIcons.arrow_right, color: AppColors.textOnPrimary,)
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Container(
                                    height: 220,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: AppColors.heroGradient,
                                        begin: Alignment.topRight,
                                        end: Alignment.bottomLeft,
                                      ),
                                    ),
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: 4,
                                      padding: const EdgeInsets.only(left: 35),
                                      itemBuilder: (context, index) {
                                            return Row(
                                              children: [
                                                RekomendasiContainer(),
                                                RekomendasiContainer(),
                                              ],
                                            );
                                          },
                                      ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                              width: 320,
                              height: 180,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 20),
                              decoration: BoxDecoration(
                                color: AppColors.surface, // Warna baru
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 24,
                                    offset: const Offset(0, 8),
                                  )
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Express JS Intermediate",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: "Montserrat",
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.textPrimary, // Warna baru
                                            ),
                                            softWrap: true,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Progress Modul :",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: "Montserrat",
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColors.textSecondary, // Warna baru
                                                ),
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const Text(
                                                "Intermediate",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: "Montserrat",
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.textPrimary, // Warna baru
                                                ),
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Chart_Pie(),
                                ],
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          
        ],
      ),
    );
  }
}
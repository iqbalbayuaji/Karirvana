import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../styles/app_colors.dart';
import '../controllers/job_openings_controller.dart';

class JobOpeningsView extends GetView<JobOpeningsController> {
  const JobOpeningsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 30, 25, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
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
                          Text(
                              'Detail Pekerjaan',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 33),
                    ],
                  ),
                ),
              ),
              Text(
                        'Junior Mobile Developer',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat',
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                        Text(
                          "PT Transcosmos Indonesia",
                          style: const TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Rp 9.000.000 - 10.000.000",
                              style: const TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                            TextSpan(
                              text: "/ Bulan",
                              style: const TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        "PT Transcosmos Indonesia, a joint venture between Transcosmos Inc. and CBN (a member of the Salim Group), is a Global Digital Transformation Partner in Customer Experience Solutions and Digital Marketing Solutions.",
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary
                        ),
                      ),
                      // const SizedBox(
                      //   height: 15,
                      // ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 15, 3, 15),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 22,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "Jl. Kebon Jeruk No. 123, Jakarta Selatan",
                                    style: TextStyle(
                                      fontFamily: "Montserrat",
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  CupertinoIcons.clock,
                                  size: 21,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "Full Time",
                                    style: TextStyle(
                                      fontFamily: "Montserrat",
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.phone,
                                  size: 20,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "0858 0279 4255",
                                    style: TextStyle(
                                      fontFamily: "Montserrat",
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  CupertinoIcons.house,
                                  size: 19,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "Remote",
                                    style: TextStyle(
                                      fontFamily: "Montserrat",
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Deskripsi Lowongan Dropdown
                      Container(
                        child: ExpansionTile(
                          title: const Text(
                            "Deskripsi Lowongan",
                            style: TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          iconColor: AppColors.primary,
                          collapsedIconColor: AppColors.textSecondary,
                          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          tilePadding: const EdgeInsets.symmetric(horizontal: 16,),
                          shape: const RoundedRectangleBorder(),
                          collapsedShape: const RoundedRectangleBorder(),
                          children: [
                            Obx(() => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: controller.responsibilities.map((item) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 6, right: 8),
                                      width: 4,
                                      height: 4,
                                      decoration: const BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          fontFamily: "Montserrat",
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )).toList(),
                            )),
                          ],
                        ),
                      ),
                      Container(
                        child: ExpansionTile(
                          title: const Text(
                            "Persyaratan Lowongan",
                            style: TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          iconColor: AppColors.primary,
                          collapsedIconColor: AppColors.textSecondary,
                          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                          tilePadding: const EdgeInsets.symmetric(horizontal: 16,),
                          shape: const RoundedRectangleBorder(),
                          collapsedShape: const RoundedRectangleBorder(),
                          children: [
                            Obx(() => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: controller.qualifications.map((item) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 6, right: 8),
                                      width: 4,
                                      height: 4,
                                      decoration: const BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          fontFamily: "Montserrat",
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )).toList(),
                            )),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          // Apply Button - Fixed at bottom
          Container(
            padding: const EdgeInsets.fromLTRB(25, 15, 25, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 3, bottom: 12),
                  child: Row(
                    children: [
                      Text(
                        "3 hari yang lalu",
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(
                        width: 14,
                      ),
                      Text(
                        "6 Pelamar",
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Lamar Sekarang',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showApplyBottomSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Pilih Cara Melamar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'Montserrat',
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.upload_file, color: AppColors.primary),
              title: const Text(
                'Upload CV',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: const Text(
                'Upload CV yang sudah ada',
                style: TextStyle(fontFamily: 'Montserrat'),
              ),
              onTap: () {
                Get.back();
                Get.toNamed('/cv-assistant');
              },
            ),
            ListTile(
              leading: const Icon(Icons.auto_awesome, color: AppColors.primary),
              title: const Text(
                'Buat CV dengan AI',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: const Text(
                'Buat CV otomatis dengan bantuan AI',
                style: TextStyle(fontFamily: 'Montserrat'),
              ),
              onTap: () {
                Get.back();
                Get.toNamed('/cv-assistant');
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

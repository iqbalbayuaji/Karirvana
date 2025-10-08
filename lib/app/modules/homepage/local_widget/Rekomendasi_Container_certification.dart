import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:karirvana/app/styles/app_colors.dart';

import '../../../routes/app_pages.dart';
import '../../certification_store_main/controllers/certification_store_main_controller.dart';

class RekomendasiContainerCertification extends StatefulWidget {
  final int index;

  const RekomendasiContainerCertification({
    super.key,
    required this.index,
  });

  @override
  State<RekomendasiContainerCertification> createState() => _RekomendasiContainerCertificationState();
}

class _RekomendasiContainerCertificationState extends State<RekomendasiContainerCertification> {
  CertificationStoreMainController? _certificationController;
  bool _isInitialized = false;
  
  String _formatPrice(int price) {
    return NumberFormat('#,##0', 'id_ID').format(price);
  }


  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    if (_isInitialized) return;
    
    try {
      _certificationController = Get.find<CertificationStoreMainController>();
    } catch (e) {
      _certificationController = Get.put(CertificationStoreMainController());
    }
    
    _isInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    if (_certificationController == null) {
      _initializeController();
    }
    
    return Obx(() {
      // Get certification from the controller
      final certification = _certificationController!.allCertifications.isNotEmpty 
          ? _certificationController!.allCertifications[widget.index % _certificationController!.allCertifications.length]
          : null;
      
    
      // If no certification data available, show loading or empty state
      if (certification == null) {
        return Container(
          margin: const EdgeInsets.fromLTRB(10, 5, 15, 20),
          width: 220,
          height: 200,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: _certificationController!.isLoading.value 
                ? CircularProgressIndicator(color: AppColors.primary)
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.school_outlined, color: AppColors.textSecondary, size: 40),
                      SizedBox(height: 8),
                      Text(
                        'Sertifikasi tidak tersedia',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontFamily: "Montserrat",
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
          ),
        );
      }
    
    final String title = certification.title;
    final int originalPrice = certification.originalPrice;
    final int discountedPrice = certification.discountedPrice;
    final String imageUrl = certification.imageUrl; // Use imageUrl from certification data
    final String discount = certification.discount;
    final bool showDiscount = certification.showDiscount;
    final bool isFree = certification.isFree;
    
      return GestureDetector(
        onTap: () {
          Get.toNamed(Routes.CERTIFICATION_STORE, arguments: {'certificationId': certification.id});
        },
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(10, 5, 15, 20),
            width: 220,
            decoration: BoxDecoration(
              boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1),
                                              blurRadius: 10,
                                              offset: const Offset(0, 8),
                                            )
                                          ],
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(15),
            ),
            
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Column(
                children: [
                  Expanded(
                    flex: 30,
                    child: SizedBox(
                      width: double.infinity,
                      child: Image.asset(
                        imageUrl,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 13,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontFamily: "Montserrat",
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (showDiscount && discountedPrice > 0) ...[
                            Row(
                              children: [
                                Text(
                                  _formatPrice(discountedPrice),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontFamily: "Montserrat",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                Text(
                                  _formatPrice(originalPrice),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontFamily: "Montserrat",
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.lineThrough,
                                    decorationColor: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ] else if (isFree)
                            Text(
                              'GRATIS',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color(0xFF10B981),
                                fontFamily: "Montserrat",
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          else
                            Text(
                              _formatPrice(originalPrice),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.primary,
                                fontFamily: "Montserrat",
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (showDiscount)
            Container(
              height: 24,
              constraints: BoxConstraints(
                minWidth: 70,
                maxWidth: 85,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(9),
                  bottomLeft: Radius.circular(9),
                ),
                gradient: LinearGradient(
                    colors: AppColors.heroGradientSecondary,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
              ),
              child: Center(
                child: Text(
                  discount,
                  style: TextStyle(
                    color: AppColors.textOnPrimary,
                    fontFamily: "Montserrat",
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
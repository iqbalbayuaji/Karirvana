import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:karirvana/app/styles/app_colors.dart';

import '../controllers/interview_practice_history_controller.dart';

class InterviewPracticeHistoryView
    extends GetView<InterviewPracticeHistoryController> {
  const InterviewPracticeHistoryView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
                Padding(
                  padding: const EdgeInsets.only(top: 60),
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
                        "Interview Practice History",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(width: 10)
                    ],
                  ),
                ),
                SizedBox(height: 25),
                // ✅ Dynamic content based on controller state
                Obx(() {
                  if (controller.isLoading.value) {
                    return _buildLoadingState();
                  }
                  
                  if (controller.hasError.value) {
                    return _buildErrorState();
                  }
                  
                  if (!controller.hasSessions) {
                    return _buildEmptyState();
                  }
                  
                  return _buildSessionsList();
                })
            ],
          ),
        ),
      )
    );
  }

  Widget _buildSessionCard({
    required String sessionTitle,
    required String date,
    required String duration,
    required String score,
    required String status,
    required VoidCallback onOpen,
    required VoidCallback onViewChat,
    required VoidCallback onDelete,
  }) {
    return GestureDetector(
      onTap: onViewChat,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    sessionTitle,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Delete button
                GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            
            // Session details
            Container(
              width: 190,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Date
                  Text(
                    date,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Icon(
                    Icons.circle,
                    size: 3,
                    color: AppColors.textSecondary,
                  ),
                  // Duration
                  Text(
                    duration,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Score and status
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Score
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star_outlined,
                        size: 16,
                        color: _getScoreColor(int.parse(score)),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$score/100',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getScoreColor(int.parse(score)),
                        ),
                      ),
                    ],
                  ),
                  // Status
                  Text(
                    status,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            
            // Action buttons
            // Row(
            //   children: [
            //     // View Chat button
            //     Expanded(
            //       child: GestureDetector(
            //         onTap: onViewChat,
            //         child: Container(
            //           padding: const EdgeInsets.symmetric(vertical: 8),
            //           decoration: BoxDecoration(
            //             color: AppColors.primary.withOpacity(0.1),
            //             borderRadius: BorderRadius.circular(8),
            //             border: Border.all(
            //               color: AppColors.primary.withOpacity(0.3),
            //               width: 1,
            //             ),
            //           ),
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               Icon(
            //                 Icons.chat_bubble_outline,
            //                 size: 16,
            //                 color: AppColors.primary,
            //               ),
            //               const SizedBox(width: 6),
            //               Text(
            //                 'Lihat Chat',
            //                 style: TextStyle(
            //                   fontFamily: 'Montserrat',
            //                   fontSize: 12,
            //                   fontWeight: FontWeight.w600,
            //                   color: AppColors.primary,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ),
            //     const SizedBox(width: 8),
            //     // View Feedback button
            //     Expanded(
            //       child: GestureDetector(
            //         onTap: onOpen,
            //         child: Container(
            //           padding: const EdgeInsets.symmetric(vertical: 8),
            //           decoration: BoxDecoration(
            //             color: AppColors.primary,
            //             borderRadius: BorderRadius.circular(8),
            //           ),
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               Icon(
            //                 Icons.assessment_outlined,
            //                 size: 16,
            //                 color: Colors.white,
            //               ),
            //               const SizedBox(width: 6),
            //               Text(
            //                 'Lihat Feedback',
            //                 style: TextStyle(
            //                   fontFamily: 'Montserrat',
            //                   fontSize: 12,
            //                   fontWeight: FontWeight.w600,
            //                   color: Colors.white,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  /// Build loading state widget
  Widget _buildLoadingState() {
    return Container(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppColors.primary,
            ),
            SizedBox(height: 16),
            Text(
              'Memuat riwayat interview...',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build error state widget
  Widget _buildErrorState() {
    return Container(
      height: 500,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.withOpacity(0.6),
            ),
            SizedBox(height: 16),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => controller.refreshHistory(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: Text(
                'Coba Lagi',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build empty state widget (no data, but no error)
  Widget _buildEmptyState() {
    return Container(
      height: 500,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            SizedBox(height: 16),
            Text(
              'Belum ada riwayat interview.\nMulai interview practice untuk melihat riwayat di sini.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build sessions list widget
  Widget _buildSessionsList() {
    return Column(
      children: controller.interviewSessions.map((session) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildSessionCard(
            sessionTitle: controller.getSessionTitle(session),
            date: controller.formatDate(session.createdAt),
            duration: session.formattedDuration,
            score: controller.getSessionScore(session),
            status: "Selesai",
            onOpen: () => controller.openFeedbackPage(session.id),
            onViewChat: () => controller.openChatHistory(session.id),
            onDelete: () => _showDeleteConfirmation(session.id),
          ),
        );
      }).toList(),
    );
  }

  /// Show delete confirmation dialog
  void _showDeleteConfirmation(String sessionId) {
    final screenWidth = MediaQuery.of(Get.context!).size.width;
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Hapus Riwayat Interview?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SizedBox(
                        width: screenWidth * 0.2,
                      )
                    ],
                  ),

                  const SizedBox(height: 10),
                  // Description text
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Riwayat interview yang dihapus tidak dapat dikembalikan. Apakah Anda yakin ingin melanjutkan?',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SizedBox(
                        width: screenWidth * 0.05,
                      )
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 30),
              
              // Buttons
              Column(
                children: [
                  // Delete Button (Red)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        controller.deleteInterviewSession(sessionId);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Hapus Riwayat',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),
                  // Cancel Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.outline),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Batal',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat',
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 90) {
      return Colors.green;
    } else if (score >= 75) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}

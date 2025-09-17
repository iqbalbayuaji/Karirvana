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
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 60),
          child: Column(
            children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: AppColors.textPrimary,
                        size: 26,
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
                SizedBox(height: 25),
                Column(
                  children: [
                    // Session Card 1
                    _buildSessionCard(
                      sessionTitle: "Frontend Developer Interview",
                      date: "15 September 2024",
                      duration: "25 menit",
                      score: "85",
                      status: "Selesai",
                      onOpen: () {
                        // Navigate to session details
                        print("Open session 1");
                      },
                      onDelete: () {
                        // Delete session
                        print("Delete session 1");
                      },
                    ),
                    SizedBox(height: 16),
                    
                    // Session Card 2
                    _buildSessionCard(
                      sessionTitle: "Backend Developer Interview",
                      date: "12 September 2024",
                      duration: "30 menit",
                      score: "78",
                      status: "Selesai",
                      onOpen: () {
                        print("Open session 2");
                      },
                      onDelete: () {
                        print("Delete session 2");
                      },
                    ),
                    SizedBox(height: 16),
                    
                    // Session Card 3
                    _buildSessionCard(
                      sessionTitle: "UI/UX Designer Interview",
                      date: "10 September 2024",
                      duration: "20 menit",
                      score: "92",
                      status: "Selesai",
                      onOpen: () {
                        print("Open session 3");
                      },
                      onDelete: () {
                        print("Delete session 3");
                      },
                    ),
                  ],
                )
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
    required VoidCallback onDelete,
  }) {
    return Container(
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
            padding: const EdgeInsets.only(bottom: 2),
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
        ],
      ),
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

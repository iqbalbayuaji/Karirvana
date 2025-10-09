import 'package:flutter/material.dart';
import '../../../styles/app_colors.dart';
import '../controllers/certification_manage_controller.dart';

class ManagedCertificationCard extends StatelessWidget {
  final ManagedCertification certification;
  final VoidCallback? onTap;

  const ManagedCertificationCard({
    Key? key,
    required this.certification,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.outline.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 90,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage(_getCertificationImage()),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            
              SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // Top section - Title and Provider
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          certification.title,
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2),
                        Text(
                          certification.provider,
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
      
                    // Bottom section - Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _getCertificationStatusText(),
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _getCertificationStatusColor(),
                          ),
                        ),
                        Text(
                          _formatDate(certification.completedDate ?? DateTime.now()),
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Get certification image based on category/title
  String _getCertificationImage() {
    final title = certification.title.toLowerCase();
    if (title.contains('flutter') || title.contains('mobile')) {
      return 'assets/course/course-programming-1.jpg';
    } else if (title.contains('ui') || title.contains('ux') || title.contains('design')) {
      return 'assets/course/course-uiux-1.jpg';
    } else if (title.contains('marketing') || title.contains('digital')) {
      return 'assets/course/course-marketing-1.jpg';
    } else if (title.contains('data') || title.contains('analytics')) {
      return 'assets/course/course-programming-1.jpg';
    } else if (title.contains('business') || title.contains('management')) {
      return 'assets/course/course-akuntansi-1.jpg';
    } else if (title.contains('cloud') || title.contains('aws') || title.contains('azure')) {
      return 'assets/course/course-backend-1.webp';
    }
    return 'assets/course/course-programming-1.jpg';
  }

  // Get certification status text
  String _getCertificationStatusText() {
    if (certification.isCompleted) {
      return 'Completed';
    } else {
      return 'Active';
    }
  }

  // Get certification status color
  Color _getCertificationStatusColor() {
    if (certification.isCompleted) {
      return const Color(0xFF10B981); // Green for completed
    } else {
      return AppColors.primary; // Primary for active
    }
  }

  // Format date
    String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    }
  }
}

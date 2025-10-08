import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../styles/app_colors.dart';
import '../controllers/course_manage_controller.dart';

class ManagedCourseCard extends StatelessWidget {
  final ManagedCourse course;
  final VoidCallback? onTap;

  const ManagedCourseCard({
    super.key,
    required this.course,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.fromLTRB(10, 13, 10, 10),
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
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
                  image: AssetImage(_getCourseImage()),
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
                        course.title,
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
                        course.provider,
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                    // Enrollment date or completion info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _getCourseStatusText(),
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _getCourseStatusColor(),
                          ),
                        ),
                        Text(
                          _formatDate(course.isCompleted 
                              ? course.completedDate 
                              : course.enrolledDate),
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


  // Get course status text for main display
  String _getCourseStatusText() {
    if (course.isCompleted) {
      return 'Completed';
    } else if (course.progress > 0) {
      return 'On Progress';
    } else {
      return 'Active';
    }
  }

  // Get course status color for main display
  Color _getCourseStatusColor() {
    if (course.isCompleted) {
      return Color(0xFF10B981); // Green for completed
    } else if (course.progress > 0) {
      return Color(0xFFEF4444); // Red for on progress
    } else {
      return AppColors.primary; // Primary color for newly added
    }
  }

  // Get course image based on title/category
  String _getCourseImage() {
    final title = course.title.toLowerCase();
    
    if (title.contains('flutter') || title.contains('mobile')) {
      return 'assets/course/course-frontend-1.jpg';
    } else if (title.contains('python') || title.contains('data')) {
      return 'assets/course/course-python.jpg';
    } else if (title.contains('react')) {
      return 'assets/course/course-programming-1.jpg';
    } else if (title.contains('ui') || title.contains('ux') || title.contains('design')) {
      return 'assets/course/course-uiux-1.jpg';
    } else if (title.contains('marketing')) {
      return 'assets/course/course-marketing-1.png';
    } else if (title.contains('business')) {
      return 'assets/course/course-akuntansi-1.jpg';
    } else {
      return 'assets/course/course-programming-1.jpg'; // Fallback
    }
  }

  // Format date for display
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

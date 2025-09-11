import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:karirvana/app/styles/app_colors.dart';
import 'package:karirvana/app/shared/widgets/bottom_navbar.dart';
import '../controllers/profile_user_controller.dart';

class ProfileUserView extends GetView<ProfileUserController> {
  const ProfileUserView({super.key});
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.heroGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                SafeArea(
                  child: Column(
                    children: [
                      // Header Section
                      Padding(
                        padding: const EdgeInsets.all(25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Profile User',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textOnPrimary,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Handle logout
                                  },
                                  child: Icon(
                                    Icons.logout,
                                    color: AppColors.textOnPrimary,
                                    size: 30,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(top: screenHeight * 0.02),
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: AppColors.surfaceVariant,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 85,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Manage",
                                        style: TextStyle(
                                          fontFamily: "Montserrat",
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 15,
                                      mainAxisSpacing: 15,
                                      childAspectRatio: 1.0,
                                    ),
                                    itemCount: 5,
                                    itemBuilder: (context, index) {
                                      return _buildGridItem(index);
                                    },
                                  ),
                                  SizedBox(height: 120),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Container(
                          margin: EdgeInsets.only(top: screenHeight * 0.16),
                          width: double.infinity,
                          height: 90,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.10),
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 8),
                                                )
                                              ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 7,),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.account_circle,
                                  color: AppColors.textSecondary,
                                  size: 70,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Banon Kenta Oktora",
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                          fontFamily: "Montserrat",
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "Pelajar",
                                        style: TextStyle(
                                          color: AppColors.textSecondary,
                                          fontFamily: "Montserrat",
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                )
              ],
            ),
          ),
          BottomNavbar(currentIndex: 2)
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            CupertinoIcons.chevron_right,
            color: AppColors.textSecondary,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(int index) {
    final items = [
      {
        'title': 'Roadmap',
        'icon': Icons.map_outlined,
        'color': AppColors.primary,
        'gradient': [Color(0xFF6366F1), Color(0xFF8B5CF6)],
      },
      {
        'title': 'Jadwal',
        'icon': Icons.schedule_outlined,
        'color': AppColors.secondary,
        'gradient': [Color(0xFF10B981), Color(0xFF059669)],
      },
      {
        'title': 'Interview\nPractice',
        'icon': Icons.psychology_outlined,
        'color': Color(0xFFEF4444),
        'gradient': [Color(0xFFEF4444), Color(0xFFDC2626)],
      },
      {
        'title': 'Course',
        'icon': Icons.school_outlined,
        'color': Color(0xFFF59E0B),
        'gradient': [Color(0xFFF59E0B), Color(0xFFD97706)],
      },
      {
        'title': 'Certification',
        'icon': Icons.verified_outlined,
        'color': Color(0xFF8B5CF6),
        'gradient': [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
      },
    ];

    final item = items[index];
    
    return GestureDetector(
      onTap: () {
        // Handle navigation based on index
        switch (index) {
          case 0:
            // Navigate to Roadmap
            break;
          case 1:
            // Navigate to Jadwal
            break;
          case 2:
            // Navigate to Interview Practice
            break;
          case 3:
            // Navigate to Course
            break;
          case 4:
            // Navigate to Certification
            break;
        }
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: item['gradient'] as List<Color>,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: (item['color'] as Color).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                item['icon'] as IconData,
                color: Colors.white,
                size: 40,
              ),
              const SizedBox(height: 12),
              Text(
                item['title'] as String,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

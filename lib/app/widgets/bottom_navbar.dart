import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:karirvana/app/styles/app_colors.dart';

class BottomNavbar extends StatelessWidget {
  final int currentIndex;
  
  const BottomNavbar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            icon: CupertinoIcons.house_fill,
            inactiveIcon: CupertinoIcons.house,
            label: 'Homepage',
            index: 0,
            onTap: () => Get.offAllNamed('/homepage'),
          ),
          _buildNavItem(
            icon: CupertinoIcons.chat_bubble_2_fill,
            inactiveIcon: CupertinoIcons.chat_bubble_2,
            label: 'AI Assistant',
            index: 1,
            onTap: () => Get.offAllNamed('/career-assistant'),
          ),
          _buildNavItem(
            icon: CupertinoIcons.person_fill,
            inactiveIcon: CupertinoIcons.person,
            label: 'Profile',
            index: 2,
            onTap: () => Get.offAllNamed('/profile-user'),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData inactiveIcon,
    required String label,
    required int index,
    required VoidCallback onTap,
  }) {
    final isActive = currentIndex == index;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
  	      borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? icon : inactiveIcon,
              color: isActive ? AppColors.primary : AppColors.textSecondary,
              size: 24,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

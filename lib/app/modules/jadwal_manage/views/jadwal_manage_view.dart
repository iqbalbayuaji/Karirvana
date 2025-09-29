import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karirvana/app/routes/app_pages.dart';

import '../../../styles/app_colors.dart';
import '../controllers/jadwal_manage_controller.dart';
import '../models/task_model.dart';

class JadwalManageView extends GetView<JadwalManageController> {
  const JadwalManageView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
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
                  const Text(
                    'Jadwal',
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
            
            // Calendar Section
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Calendar Card
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        // border: Border.all(color: AppColors.outline),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Calendar Header
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(() => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    controller.getCurrentMonthYear(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Montserrat',
                                      color: AppColors.primary,
                                    ),
                                  ),
                                )),
                                Row(
                                  children: [
                                    _buildAnimatedNavButton(
                                      icon: CupertinoIcons.chevron_left,
                                      onTap: () => controller.goToPreviousMonth(),
                                    ),
                                    const SizedBox(width: 3),
                                    _buildAnimatedNavButton(
                                      icon: CupertinoIcons.chevron_right,
                                      onTap: () => controller.goToNextMonth(),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // Custom Calendar with Enhanced Swipe Gesture & Animation
                            Obx(() => GestureDetector(
                              onPanEnd: (details) {
                                // Swipe left to go to next month
                                if (details.velocity.pixelsPerSecond.dx < -500) {
                                  controller.goToNextMonth();
                                }
                                // Swipe right to go to previous month
                                else if (details.velocity.pixelsPerSecond.dx > 500) {
                                  controller.goToPreviousMonth();
                                }
                              },
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 400),
                                switchInCurve: Curves.easeOutCubic,
                                switchOutCurve: Curves.easeInCubic,
                                transitionBuilder: (Widget child, Animation<double> animation) {
                                  return AnimatedBuilder(
                                    animation: animation,
                                    builder: (context, child) {
                                      return Transform(
                                        alignment: Alignment.center,
                                        transform: Matrix4.identity()
                                          ..setEntry(3, 2, 0.001) // Perspective
                                          ..rotateY((1 - animation.value) * 0.3)
                                          ..scale(0.8 + (animation.value * 0.2)),
                                        child: SlideTransition(
                                          position: Tween<Offset>(
                                            begin: const Offset(0.5, 0),
                                            end: Offset.zero,
                                          ).animate(CurvedAnimation(
                                            parent: animation,
                                            curve: Curves.elasticOut,
                                          )),
                                          child: FadeTransition(
                                            opacity: Tween<double>(
                                              begin: 0.0,
                                              end: 1.0,
                                            ).animate(CurvedAnimation(
                                              parent: animation,
                                              curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
                                            )),
                                            child: child,
                                          ),
                                        ),
                                      );
                                    },
                                    child: child,
                                  );
                                },
                                child: Container(
                                  key: ValueKey(controller.getCurrentMonthYear()),
                                  child: _buildCustomCalendar(),
                                ),
                              ),
                            )),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Today's Schedule Section
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        // border: Border.all(color: AppColors.outline),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(() => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      color: AppColors.primary,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _getSelectedDateTitle(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat',
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(Routes.JADWAL_ADD, arguments: {
                                      'selectedDate': controller.selectedDate.value,
                                    });  
                                  },
                                  child: Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                )
                              ],
                            )),
                            
                            const SizedBox(height: 16),
                            
                            // Dynamic Schedule Items
                            Obx(() => _buildScheduleList()),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  
  String _getSelectedDateTitle() {
    final selectedDate = controller.selectedDate.value;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    
    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    
    if (selected.isAtSameMomentAs(today)) {
      return 'Jadwal Hari Ini';
    } else {
      return 'Jadwal ${selectedDate.day} ${months[selectedDate.month - 1]}';
    }
  }
  
  bool _isSelectedDate(DateTime date) {
    final selectedDate = controller.selectedDate.value;
    return date.year == selectedDate.year &&
           date.month == selectedDate.month &&
           date.day == selectedDate.day;
  }
  
  Widget _buildScheduleList() {
    final selectedTasks = controller.getTasksForDate(controller.selectedDate.value);
    
    if (selectedTasks.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.event_busy,
                size: 48,
                color: AppColors.textSecondary.withOpacity(0.5),
              ),
              const SizedBox(height: 12),
              Text(
                'Tidak ada jadwal',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    return Column(
      children: selectedTasks.asMap().entries.map((entry) {
        final index = entry.key;
        final task = entry.value;
        
        return Column(
          children: [
            _buildScheduleItem(
              task: task,
              time: task.time != null 
                  ? '${task.time!.hour.toString().padLeft(2, '0')}:${task.time!.minute.toString().padLeft(2, '0')}'
                  : 'Sepanjang hari',
              title: task.title,
              type: _getTaskTypeString(task.category),
              color: _getTaskColor(task.category),
            ),
            if (index < selectedTasks.length - 1) const SizedBox(height: 12),
          ],
        );
      }).toList(),
    );
  }
  
  String _getTaskTypeString(TaskCategory category) {
    switch (category) {
      case TaskCategory.work:
        return 'Pekerjaan';
      case TaskCategory.personal:
        return 'Pribadi';
      case TaskCategory.study:
        return 'Belajar';
      case TaskCategory.other:
        return 'Lainnya';
    }
  }
  
  Color _getTaskColor(TaskCategory category) {
    switch (category) {
      case TaskCategory.work:
        return Colors.blue;
      case TaskCategory.personal:
        return Colors.teal;
      case TaskCategory.study:
        return Colors.orange;
      case TaskCategory.other:
        return Colors.grey;
    }
  }
  
  Widget _buildCustomCalendar() {
    final now = DateTime.now();
    final calendarDate = controller.currentCalendarDate.value;
    final firstDayOfMonth = DateTime(calendarDate.year, calendarDate.month, 1);
    final startDate = firstDayOfMonth.subtract(Duration(days: firstDayOfMonth.weekday - 1));
    
    return Column(
      children: [
        // Days of week header
        Row(
          children: ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min']
              .map((day) => Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat',
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
        
        const SizedBox(height: 12),
        
        // Calendar grid
        ...List.generate(6, (weekIndex) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: List.generate(7, (dayIndex) {
                final date = startDate.add(Duration(days: weekIndex * 7 + dayIndex));
                final isCurrentMonth = date.month == calendarDate.month;
                final isToday = date.day == now.day && 
                               date.month == now.month && 
                               date.year == now.year;
                final hasEvent = _hasEventOnDate(date);
                
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      controller.updateSelectedDate(date);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOutCubic,
                      height: 40,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: _isSelectedDate(date)
                            ? AppColors.primary
                            : isToday 
                                ? AppColors.primary.withOpacity(0.8)
                                : hasEvent 
                                    ? AppColors.primary.withOpacity(0.1)
                                    : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: hasEvent && !isToday && !_isSelectedDate(date)
                            ? Border.all(color: AppColors.primary.withOpacity(0.4), width: 1)
                            : null,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${date.day}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                                fontFamily: 'Montserrat',
                                color: _isSelectedDate(date)
                                    ? Colors.white
                                    : isToday
                                        ? Colors.white
                                        : isCurrentMonth
                                            ? AppColors.textPrimary
                                            : AppColors.textSecondary.withOpacity(0.5),
                              ),
                            ),
                            // Animated Dot indicator untuk tanggal yang memiliki jadwal
                            if (hasEvent && !_isSelectedDate(date))
                              TweenAnimationBuilder<double>(
                                duration: const Duration(milliseconds: 800),
                                tween: Tween<double>(begin: 0.8, end: 1.2),
                                curve: Curves.elasticOut,
                                builder: (context, scale, child) {
                                  return Transform.scale(
                                    scale: scale,
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 2),
                                      width: 4,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: isToday 
                                            ? Colors.white 
                                            : AppColors.primary,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: (isToday ? Colors.white : AppColors.primary)
                                                .withOpacity(0.4),
                                            blurRadius: 3,
                                            spreadRadius: 0.5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        }),
      ],
    );
  }
  
  Widget _buildScheduleItem({
    required TaskModel task,
    required String time,
    required String title,
    required String type,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: task.isCompleted 
            ? Colors.grey.withOpacity(0.1) 
            : color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: task.isCompleted 
              ? Colors.grey.withOpacity(0.3) 
              : color.withOpacity(0.3)
        ),
      ),
      child: Row(
        children: [
          // Completion checkbox
          GestureDetector(
            onTap: () => controller.toggleTaskCompletion(task.id),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: task.isCompleted 
                    ? const Color(0xFF4CAF50) 
                    : Colors.transparent,
                border: Border.all(
                  color: task.isCompleted 
                      ? const Color(0xFF4CAF50) 
                      : color,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: task.isCompleted
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    )
                  : null,
            ),
          ),
          
          const SizedBox(width: 12),
          
          Container(
            width: 3,
            height: 40,
            decoration: BoxDecoration(
              color: task.isCompleted ? Colors.grey : color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          const SizedBox(width: 12),
          
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat',
                          color: task.isCompleted 
                              ? Colors.grey 
                              : AppColors.textPrimary,
                          decoration: task.isCompleted 
                              ? TextDecoration.lineThrough 
                              : TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: task.isCompleted 
                                ? Colors.grey 
                                : AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            time,
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Montserrat',
                              color: task.isCompleted 
                                  ? Colors.grey 
                                  : AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: task.isCompleted 
                                  ? Colors.grey.withOpacity(0.2) 
                                  : color.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              type,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Montserrat',
                                color: task.isCompleted ? Colors.grey : color,
                              ),
                            ),
                          ),
                          if (task.isCompleted) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4CAF50).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Selesai',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Montserrat',
                                  color: Color(0xFF4CAF50),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => controller.deleteTask(task.id),
                  child: Icon(
                    Icons.delete_outlined,
                    color: Colors.red[400],
                    size: 25,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  bool _hasEventOnDate(DateTime date) {
    return controller.getTasksForDate(date).isNotEmpty;
  }

  Widget _buildAnimatedNavButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 200),
      tween: Tween<double>(begin: 1.0, end: 1.0),
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                // Trigger scale animation
                (context as Element).markNeedsBuild();
                onTap();
              },
              onTapDown: (_) {
                // Scale down on press
                (context as Element).markNeedsBuild();
              },
              onTapUp: (_) {
                // Scale back up on release
                (context as Element).markNeedsBuild();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(10),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  
  // void _onDateSelected(DateTime date) {
  //   Get.snackbar(
  //     'Tanggal Dipilih',
  //     'Anda memilih tanggal ${date.day}/${date.month}/${date.year}',
  //     snackPosition: SnackPosition.BOTTOM,
  //     backgroundColor: AppColors.primary,
  //     colorText: Colors.white,
  //   );
  // }

}

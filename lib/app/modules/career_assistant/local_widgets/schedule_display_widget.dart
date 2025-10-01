import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../styles/app_colors.dart';
import '../../jadwal_manage/models/task_model.dart';
import '../controllers/career_assistant_controller.dart';

class ScheduleDisplayWidget extends StatelessWidget {
  final List<TaskModel> tasks;
  final String title;
  final String description;
  final String duration;

  const ScheduleDisplayWidget({
    Key? key,
    required this.tasks,
    required this.title,
    required this.description,
    required this.duration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Schedule Container
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.outline.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.calendar_today,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Montserrat',
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (description.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'Montserrat',
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  duration,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Tasks List
          if (tasks.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              child: const Center(
                child: Text(
                  'Tidak ada jadwal yang dibuat',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            )
          else
            Column(
              children: [
                // Group tasks by date
                ...tasks.asMap().entries.map((entry) {
                  final index = entry.key;
                  final task = entry.value;
                  final isFirst = index == 0;
                  final isLast = index == tasks.length - 1;
                  
                  // Check if this is a new date
                  final showDateHeader = isFirst || 
                      !_isSameDate(task.date, tasks[index - 1].date);
                  
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date header
                      if (showDateHeader) ...[
                        if (!isFirst) const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _formatDate(task.date),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Montserrat',
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      
                      // Task item
                      _buildTaskItem(task),
                      
                      if (!isLast) const SizedBox(height: 8),
                    ],
                  );
                }).toList(),
              ],
            ),
            ],
          ),
        ),
        
        const SizedBox(height: 10),
        
        // Action buttons (outside container)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Apakah jadwal ini sesuai dengan kebutuhan Anda?',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Montserrat',
                color: AppColors.textOnPrimary,
              ),
            ),
            const SizedBox(height: 7),
            Row(
              children: [
                // Save Button
                GestureDetector(
                  onTap: () {
                    final controller = Get.find<CareerAssistantController>();
                    controller.saveSchedule();
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Icon(
                          CupertinoIcons.checkmark_alt,
                          color: AppColors.textOnPrimary,
                          size: 20,
                        ),
                      ),
                      Text(
                        'Simpan',
                        style: TextStyle(
                          color: AppColors.textOnPrimary,
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                
                // Regenerate Button
                GestureDetector(
                  onTap: () {
                    final controller = Get.find<CareerAssistantController>();
                    controller.regenerateSchedule();
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Icon(
                          CupertinoIcons.xmark,
                          color: AppColors.textOnPrimary,
                          size: 20,
                        ),
                      ),
                      Text(
                        'Buat Ulang',
                        style: TextStyle(
                          color: AppColors.textOnPrimary,
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ],
    );
  }

  Widget _buildTaskItem(TaskModel task) {
    final color = _getTaskColor(task.category);
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          // Task indicator
          Container(
            width: 3,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          const SizedBox(width: 12),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                if (task.description.isNotEmpty) ...[
                  Text(
                    task.description,
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                ],
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatTimeRange(task),
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'Montserrat',
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Color(task.priority.colorValue).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        task.priority.displayName,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat',
                          color: Color(task.priority.colorValue),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getTaskColor(TaskCategory category) {
    switch (category) {
      case TaskCategory.study:
        return AppColors.primary;
      case TaskCategory.work:
        return Colors.orange;
      case TaskCategory.personal:
        return Colors.green;
      case TaskCategory.other:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(date.year, date.month, date.day);
    
    if (taskDate == today) {
      return 'Hari Ini';
    } else {
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    }
  }

  String _formatTimeRange(TaskModel task) {
    if (task.time == null) return 'Sepanjang hari';
    
    final timeFormat = '${task.time!.hour.toString().padLeft(2, '0')}:${task.time!.minute.toString().padLeft(2, '0')}';
    
    if (task.endTime != null) {
      final endTimeFormat = '${task.endTime!.hour.toString().padLeft(2, '0')}:${task.endTime!.minute.toString().padLeft(2, '0')}';
      return '$timeFormat - $endTimeFormat';
    }
    
    return timeFormat;
  }

  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }
}

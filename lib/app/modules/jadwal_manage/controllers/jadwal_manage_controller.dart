import 'package:get/get.dart';
import '../models/task_model.dart';

class JadwalManageController extends GetxController {
  // Observable list of tasks
  final RxList<TaskModel> tasks = <TaskModel>[].obs;
  
  // Selected date for calendar view
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  
  // Current calendar month/year view
  final Rx<DateTime> currentCalendarDate = DateTime.now().obs;
  
  @override
  void onInit() {
    super.onInit();
    _loadSampleTasks();
  }

  /// Get tasks for specific date
  List<TaskModel> getTasksForDate(DateTime date) {
    return tasks.where((task) {
      return task.date.year == date.year &&
             task.date.month == date.month &&
             task.date.day == date.day;
    }).toList();
  }
  
  /// Update selected date
  void updateSelectedDate(DateTime date) {
    selectedDate.value = date;
  }
  
  /// Navigate to previous month
  void goToPreviousMonth() {
    final current = currentCalendarDate.value;
    currentCalendarDate.value = DateTime(current.year, current.month - 1, 1);
  }
  
  /// Navigate to next month
  void goToNextMonth() {
    final current = currentCalendarDate.value;
    currentCalendarDate.value = DateTime(current.year, current.month + 1, 1);
  }
  
  /// Get current month year string for display
  String getCurrentMonthYear() {
    final date = currentCalendarDate.value;
    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  /// Load sample tasks for demonstration
  void _loadSampleTasks() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    tasks.addAll([
      TaskModel(
        id: '1',
        title: 'Meeting dengan Tim',
        description: 'Diskusi project baru',
        date: today,
        time: DateTime(today.year, today.month, today.day, 10, 0),
        priority: TaskPriority.high,
        category: TaskCategory.work,
        isCompleted: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      TaskModel(
        id: '2',
        title: 'Belajar Flutter',
        description: 'Mempelajari state management',
        date: today.add(const Duration(days: 1)),
        time: DateTime(today.year, today.month, today.day + 1, 14, 0),
        priority: TaskPriority.medium,
        category: TaskCategory.study,
        isCompleted: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      TaskModel(
        id: '3',
        title: 'Olahraga Pagi',
        description: 'Jogging di taman',
        date: today.add(const Duration(days: 2)),
        priority: TaskPriority.low,
        category: TaskCategory.health,
        isCompleted: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ]);
  }
}

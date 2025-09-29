import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../jadwal_manage/controllers/jadwal_manage_controller.dart';
import '../../jadwal_manage/models/task_model.dart';

class JadwalAddController extends GetxController {
  // Form Controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  
  // Observable Variables
  final selectedDate = DateTime.now().obs;
  final selectedTime = TimeOfDay.now().obs;
  final selectedPriority = TaskPriority.medium.obs;
  final selectedCategory = TaskCategory.personal.obs;
  final isLoading = false.obs;
  
  // Form Key
  final formKey = GlobalKey<FormState>();
  
  @override
  void onInit() {
    super.onInit();
    // Initialize locale data for Indonesian formatting
    _initializeLocaleData();
    // Get selected date from arguments if available
    if (Get.arguments != null && Get.arguments['selectedDate'] != null) {
      selectedDate.value = Get.arguments['selectedDate'];
    }
  }

  // Initialize locale data
  Future<void> _initializeLocaleData() async {
    try {
      await initializeDateFormatting('id_ID', null);
    } catch (e) {
      // Fallback to default locale if Indonesian locale fails
      print('Failed to initialize Indonesian locale: $e');
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  // Date Selection
  Future<void> selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: selectedDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      selectedDate.value = picked;
    }
  }

  // Time Selection
  Future<void> selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: Get.context!,
      initialTime: selectedTime.value,
    );
    if (picked != null) {
      selectedTime.value = picked;
    }
  }

  // Priority Selection
  void updatePriority(TaskPriority priority) {
    selectedPriority.value = priority;
  }

  // Category Selection
  void updateCategory(TaskCategory category) {
    selectedCategory.value = category;
  }

  // Get formatted date
  String get formattedDate {
    try {
      return DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(selectedDate.value);
    } catch (e) {
      // Fallback to simple Indonesian format without locale dependency
      final date = selectedDate.value;
      final dayNames = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
      final monthNames = ['', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 
                         'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
      
      final dayName = dayNames[date.weekday % 7];
      final monthName = monthNames[date.month];
      
      return '$dayName, ${date.day} $monthName ${date.year}';
    }
  }

  // Get formatted time
  String get formattedTime {
    final hour = selectedTime.value.hour.toString().padLeft(2, '0');
    final minute = selectedTime.value.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  // Save Task
  Future<void> saveTask() async {
    if (!formKey.currentState!.validate()) return;
    
    isLoading.value = true;
    
    try {
      // Create DateTime from selected date and time
      final taskDateTime = DateTime(
        selectedDate.value.year,
        selectedDate.value.month,
        selectedDate.value.day,
        selectedTime.value.hour,
        selectedTime.value.minute,
      );
      
      // Create new task
      final task = TaskModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        date: selectedDate.value,
        time: taskDateTime,
        priority: selectedPriority.value,
        category: selectedCategory.value,
        isCompleted: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      // Add to jadwal manage controller
      final jadwalController = Get.find<JadwalManageController>();
      jadwalController.tasks.add(task);
      
      // Show success message
      Get.snackbar(
        'Berhasil',
        'Jadwal berhasil ditambahkan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      
      // Navigate back
      Get.back();
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menambahkan jadwal: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Validation
  String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Judul jadwal tidak boleh kosong';
    }
    if (value.trim().length < 3) {
      return 'Judul jadwal minimal 3 karakter';
    }
    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Deskripsi tidak boleh kosong';
    }
    return null;
  }
}

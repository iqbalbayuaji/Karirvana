import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../jadwal_manage/models/task_model.dart';
import '../../jadwal_manage/controllers/jadwal_manage_controller.dart';

class AddTaskController extends GetxController {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final selectedDate = DateTime.now().obs;
  final selectedTime = Rx<TimeOfDay?>(null);
  final selectedPriority = TaskPriority.medium.obs;
  final selectedCategory = TaskCategory.personal.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Get selected date from arguments if available
    final args = Get.arguments;
    if (args != null && args['selectedDate'] != null) {
      selectedDate.value = args['selectedDate'];
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  void selectDate() async {
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

  void selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: Get.context!,
      initialTime: selectedTime.value ?? TimeOfDay.now(),
    );
    if (picked != null) {
      selectedTime.value = picked;
    }
  }

  void saveTask() async {
    if (titleController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Judul task tidak boleh kosong',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final task = TaskModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        date: selectedDate.value,
        time: selectedTime.value != null 
            ? DateTime(
                selectedDate.value.year,
                selectedDate.value.month,
                selectedDate.value.day,
                selectedTime.value!.hour,
                selectedTime.value!.minute,
              )
            : null,
        priority: selectedPriority.value,
        category: selectedCategory.value,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Add task to JadwalManageController
      final jadwalController = Get.find<JadwalManageController>();
      jadwalController.addTask(task);

      Get.back();
      Get.snackbar(
        'Berhasil',
        'Task berhasil ditambahkan',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menambahkan task',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}

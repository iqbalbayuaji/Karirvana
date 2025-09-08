import 'package:get/get.dart';
import '../../course_store_main/controllers/course_store_main_controller.dart';

class CourseStoreController extends GetxController {
  final Rx<Course?> selectedCourse = Rx<Course?>(null);
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Get course data from arguments or default to first course
    final courseId = Get.arguments as String?;
    loadCourse(courseId);
  }

  void loadCourse(String? courseId) {
    isLoading.value = true;
    
    // Sample course data - same structure as course_store_main
    final courses = [
      Course(
        id: '1',
        title: 'Microsoft Excel Beginner Course',
        instructor: 'Dr. Ahmad Wijaya',
        category: 'Programming',
        description: 'Pelajari Microsoft Excel dari dasar hingga mahir. Kursus ini dirancang khusus untuk pemula yang ingin menguasai spreadsheet dan analisis data. Dengan metode pembelajaran yang mudah dipahami dan praktis.',
        imageUrl: 'assets/images/hero.jpg',
        rating: 4.8,
        totalStudents: 2847,
        totalLessons: 24,
        duration: '8 jam',
        originalPrice: 599000,
        discountedPrice: 299000,
        isFree: false,
        level: 'Pemula',
        discount: '50% Off',
        showDiscount: true,
      ),
    ];
    
    // Find course by ID or use first course
    selectedCourse.value = courses.firstWhere(
      (course) => course.id == courseId,
      orElse: () => courses.first,
    );
    
    isLoading.value = false;
  }

  String formatPrice(int price) {
    return 'Rp ${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  String formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    }
    return number.toString();
  }
}

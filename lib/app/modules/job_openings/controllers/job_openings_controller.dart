import 'package:get/get.dart';
import '../../job_openings_main/controllers/job_openings_main_controller.dart';

class JobOpeningsController extends GetxController {
  final Rxn<JobOpeningMain> job = Rxn<JobOpeningMain>();

  final qualifications = <String>[
    'Lulusan S1/D3 Teknik Informatika, Sistem Informasi, atau bidang terkait',
    'Memiliki pengalaman minimal 1 tahun dalam pengembangan aplikasi mobile',
    'Menguasai Flutter dan Dart programming language',
    'Familiar dengan REST API integration dan state management',
    'Kemampuan komunikasi yang baik dan mampu bekerja dalam tim',
    'Motivasi belajar yang tinggi dan mengikuti perkembangan teknologi terbaru',
  ].obs;

  final responsibilities = <String>[
    'Mengembangkan aplikasi mobile menggunakan Flutter framework',
    'Berkolaborasi dengan tim UI/UX untuk implementasi desain',
    'Melakukan testing dan debugging aplikasi',
    'Mengintegrasikan aplikasi dengan backend services melalui REST API',
    'Memelihara dan mengoptimalkan performa aplikasi',
    'Berpartisipasi dalam code review dan dokumentasi teknis',
  ].obs;

  final benefits = <String>[
    'Gaji kompetitif sesuai pengalaman',
    'Asuransi kesehatan dan kecelakaan',
    'Cuti tahunan dan cuti sakit',
    'Kesempatan pengembangan karir',
    'Lingkungan kerja yang fleksibel',
  ].obs;

  final isSaved = false.obs;

  @override
  void onInit() {
    super.onInit();
    final arg = Get.arguments;
    if (arg is JobOpeningMain) {
      job.value = arg;
    }
  }

  void toggleSaved() => isSaved.toggle();
}
